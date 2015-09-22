require 'spec_helper_acceptance'

describe 'basic nova' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      # Common resources
      case $::osfamily {
        'Debian': {
          include ::apt
          class { '::openstack_extras::repo::debian::ubuntu':
            release         => 'liberty',
            repo            => 'proposed',
            package_require => true,
          }
          $package_provider = 'apt'
        }
        'RedHat': {
          class { '::openstack_extras::repo::redhat::redhat':
            manage_rdo => false,
            repo_hash => {
              'openstack-common-testing' => {
                'baseurl'  => 'http://cbs.centos.org/repos/cloud7-openstack-common-testing/x86_64/os/',
                'descr'    => 'openstack-common-testing',
                'gpgcheck' => 'no',
              },
              'openstack-liberty-testing' => {
                'baseurl'  => 'http://cbs.centos.org/repos/cloud7-openstack-liberty-testing/x86_64/os/',
                'descr'    => 'openstack-liberty-testing',
                'gpgcheck' => 'no',
              },
              'openstack-liberty-trunk' => {
                'baseurl'  => 'http://trunk.rdoproject.org/centos7-liberty/current-passed-ci/',
                'descr'    => 'openstack-liberty-trunk',
                'gpgcheck' => 'no',
              },
            },
          }
          package { 'openstack-selinux': ensure => 'latest' }
          $package_provider = 'yum'
        }
        default: {
          fail("Unsupported osfamily (${::osfamily})")
        }
      }

      class { '::mysql::server': }

      class { '::rabbitmq':
        delete_guest_user => true,
        package_provider  => $package_provider,
      }

      rabbitmq_vhost { '/':
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user { 'nova':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'nova@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Keystone resources, needed by Nova to run
      class { '::keystone::db::mysql':
        password => 'keystone',
      }
      class { '::keystone':
        verbose             => true,
        debug               => true,
        database_connection => 'mysql://keystone:keystone@127.0.0.1/keystone',
        admin_token         => 'admin_token',
        enabled             => true,
      }
      class { '::keystone::roles::admin':
        email    => 'test@example.tld',
        password => 'a_big_secret',
      }
      class { '::keystone::endpoint':
        public_url => "https://${::fqdn}:5000/",
        admin_url  => "https://${::fqdn}:35357/",
      }

      # Nova resources
      class { '::nova':
        database_connection => 'mysql://nova:a_big_secret@127.0.0.1/nova?charset=utf8',
        rabbit_userid       => 'nova',
        rabbit_password     => 'an_even_bigger_secret',
        image_service       => 'nova.image.glance.GlanceImageService',
        glance_api_servers  => 'localhost:9292',
        verbose             => true,
        debug               => true,
        rabbit_host         => '127.0.0.1',
      }
      class { '::nova::db::mysql':
        password => 'a_big_secret',
      }
      class { '::nova::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::nova::api':
        admin_password => 'a_big_secret',
        identity_uri   => 'http://127.0.0.1:35357/',
        osapi_v3       => true,
      }
      class { '::nova::cert': }
      class { '::nova::client': }
      class { '::nova::conductor': }
      class { '::nova::consoleauth': }
      class { '::nova::cron::archive_deleted_rows': }
      class { '::nova::compute': vnc_enabled => true }
      class { '::nova::compute::libvirt':
        migration_support => true,
        vncserver_listen  => '0.0.0.0',
      }
      class { '::nova::scheduler': }
      class { '::nova::vncproxy': }
      # TODO: networking with neutron
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8773) do
      it { is_expected.to be_listening.with('tcp') }
    end

    describe port(8774) do
      it { is_expected.to be_listening.with('tcp') }
    end

    describe port(8775) do
      it { is_expected.to be_listening.with('tcp') }
    end

    describe port(6080) do
      it { is_expected.to be_listening.with('tcp') }
    end

    describe cron do
      it { is_expected.to have_entry('1 0 * * * nova-manage db archive_deleted_rows --max_rows 100 >>/var/log/nova/nova-rowsflush.log 2>&1').with_user('nova') }
    end

  end
end
