require 'spec_helper'

describe 'nova::wsgi::apache_placement' do
  shared_examples_for 'apache serving nova with mod_wsgi' do
    context 'with default parameters' do

      let :pre_condition do
        "include nova
         class { '::nova::keystone::authtoken':
           password => 'secrete',
         }
         "
      end

      it { is_expected.to contain_class('nova::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to contain_class('apache::mod::ssl') }
      it { is_expected.to contain_nova__generic_service('placement-api').with(
        :service_name   => false,
        :package_name   => platform_params[:placement_package_name],
        :ensure_package => 'present',
      )}
      it { is_expected.to contain_file(platform_params[:placement_httpd_config_file]) }
      it { is_expected.to contain_openstacklib__wsgi__apache('placement_wsgi').with(
        :bind_port                   => 80,
        :group                       => 'nova',
        :path                        => '/placement',
        :servername                  => facts[:fqdn],
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'nova',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'placement-api',
        :wsgi_process_group          => 'placement-api',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'nova-placement-api',
        :wsgi_script_source          => platform_params[:placement_wsgi_script_source],
        :custom_wsgi_process_options => {},
        :access_log_file             => false,
        :access_log_format           => false,
        :error_log_file              => nil,
      )}

    end

    context 'when overriding parameters using different ports' do
      let :pre_condition do
        "include nova
         class { '::nova::keystone::authtoken':
           password => 'secrete',
         }
         "
      end

      let :params do
        {
          :servername                => 'dummy.host',
          :bind_host                 => '10.42.51.1',
          :api_port                  => 12345,
          :ssl                       => false,
          :wsgi_process_display_name => 'placement-api',
          :workers                   => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :access_log_file           => '/var/log/httpd/access_log',
          :access_log_format         => 'some format',
          :error_log_file            => '/var/log/httpd/error_log'
        }
      end

      it { is_expected.to contain_class('nova::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_nova__generic_service('placement-api').with(
        :service_name   => false,
        :package_name   => platform_params[:placement_package_name],
        :ensure_package => 'present',
      )}
      it { is_expected.to contain_file(platform_params[:placement_httpd_config_file]) }
      it { is_expected.to contain_openstacklib__wsgi__apache('placement_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'nova',
        :path                        => '/placement',
        :servername                  => 'dummy.host',
        :ssl                         => false,
        :workers                     => 37,
        :threads                     => 1,
        :user                        => 'nova',
        :wsgi_daemon_process         => 'placement-api',
        :wsgi_process_display_name   => 'placement-api',
        :wsgi_process_group          => 'placement-api',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'nova-placement-api',
        :wsgi_script_source          => platform_params[:placement_wsgi_script_source],
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log'
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
