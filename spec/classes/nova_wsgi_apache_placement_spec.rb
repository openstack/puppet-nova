require 'spec_helper'

describe 'nova::wsgi::apache_placement' do

  let :global_facts do
    @default_facts.merge({
      :processorcount => 42,
      :concat_basedir => '/var/lib/puppet/concat',
      :fqdn           => 'some.host.tld'
    })
  end

 let :pre_condition do
   "include nova
    class { '::nova::keystone::authtoken':
      password => 'secrete',
    }
    "
 end

  shared_examples_for 'apache serving nova with mod_wsgi' do
    it { is_expected.to contain_service('httpd').with_name(platform_params[:httpd_service_name]) }
    it { is_expected.to contain_class('nova::params') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_class('apache::mod::wsgi') }

    describe 'with default parameters' do

      let :pre_condition do
        "include nova
         class { '::nova::keystone::authtoken':
           password => 'secrete',
         }
         "
      end

      it { is_expected.to contain_package('nova-placement-api').with(
        :name   => "#{platform_params[:placement_package_name]}",
        :ensure => 'present',
        :tag    => ['openstack', 'nova-package'],
      )}

      it { is_expected.to contain_file("#{platform_params[:wsgi_script_path]}").with(
        'ensure'  => 'directory',
        'owner'   => 'nova',
        'group'   => 'nova',
        'require' => 'Package[httpd]'
      )}


      it { is_expected.to contain_file('placement_wsgi').with(
        'ensure'  => 'file',
        'path'    => "#{platform_params[:wsgi_script_path]}/nova-placement-api",
        'source'  => platform_params[:placement_wsgi_script_source],
        'owner'   => 'nova',
        'group'   => 'nova',
        'mode'    => '0644'
      )}
      it { is_expected.to contain_file('placement_wsgi').that_requires("File[#{platform_params[:wsgi_script_path]}]") }

      it { is_expected.to contain_apache__vhost('placement_wsgi').with(
        'servername'                  => 'some.host.tld',
        'ip'                          => nil,
        'port'                        => '80',
        'docroot'                     => "#{platform_params[:wsgi_script_path]}",
        'docroot_owner'               => 'nova',
        'docroot_group'               => 'nova',
        'ssl'                         => 'true',
        'wsgi_daemon_process'         => 'placement-api',
        'wsgi_process_group'          => 'placement-api',
        'wsgi_script_aliases'         => { '/placement' => "#{platform_params[:wsgi_script_path]}/nova-placement-api" },
        'require'                     => 'File[placement_wsgi]'
      )}
      it { is_expected.to contain_concat("#{platform_params[:httpd_ports_file]}") }

      it { is_expected.to contain_file('placement_wsgi').with(
        'ensure'  => 'file',
        'path'    => "#{platform_params[:wsgi_script_path]}/nova-placement-api",
        'source'  => platform_params[:placement_wsgi_script_source],
        'owner'   => 'nova',
        'group'   => 'nova',
        'mode'    => '0644'
      )}
      it { is_expected.to contain_file('placement_wsgi').that_requires("File[#{platform_params[:wsgi_script_path]}]") }

      it { is_expected.to contain_concat("#{platform_params[:httpd_ports_file]}") }

      it { is_expected.to contain_file(platform_params[:placement_httpd_config_file]) }
    end

    describe 'when overriding parameters using different ports' do
      let :pre_condition do
        "include nova
         class { '::nova::keystone::authtoken':
           password => 'secrete',
         }
         "
      end

      let :params do
        {
          :servername  => 'dummy.host',
          :bind_host   => '10.42.51.1',
          :api_port    => 12345,
          :ssl         => false,
          :workers     => 37,
        }
      end

      it { is_expected.to contain_apache__vhost('placement_wsgi').with(
        'servername'                  => 'dummy.host',
        'ip'                          => '10.42.51.1',
        'port'                        => '12345',
        'docroot'                     => "#{platform_params[:wsgi_script_path]}",
        'docroot_owner'               => 'nova',
        'docroot_group'               => 'nova',
        'ssl'                         => 'false',
        'wsgi_daemon_process'         => 'placement-api',
        'wsgi_process_group'          => 'placement-api',
        'wsgi_script_aliases'         => { '/placement' => "#{platform_params[:wsgi_script_path]}/nova-placement-api" },
        'require'                     => 'File[placement_wsgi]'
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name           => 'apache2',
            :httpd_ports_file             => '/etc/apache2/ports.conf',
            :wsgi_script_path             => '/usr/lib/cgi-bin/nova',
            :placement_wsgi_script_source => '/usr/bin/nova-placement-api',
            :placement_package_name       => 'nova-placement-api',
            :placement_httpd_config_file  => '/etc/apache2/sites-available/nova-placement-api.conf',
          }
        when 'RedHat'
          {
            :httpd_service_name           => 'httpd',
            :httpd_ports_file             => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path             => '/var/www/cgi-bin/nova',
            :placement_wsgi_script_source => '/usr/bin/nova-placement-api',
            :placement_package_name       => 'openstack-nova-placement-api',
            :placement_httpd_config_file  => '/etc/httpd/conf.d/00-nova-placement-api.conf',
          }
        end
      end

      it_behaves_like 'apache serving nova with mod_wsgi'
    end
  end
end
