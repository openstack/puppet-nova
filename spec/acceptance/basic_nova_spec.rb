require 'spec_helper_acceptance'

describe 'basic nova' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

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

      # Nova resources
      class { '::nova':
        database_connection => 'mysql+pymysql://nova:a_big_secret@127.0.0.1/nova?charset=utf8',
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
