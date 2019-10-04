require 'spec_helper'

describe 'nova::wsgi::apache_api' do
  shared_examples_for 'apache serving nova with mod_wsgi' do
    context 'with default parameters' do

      let :pre_condition do
        "include nova
         class { '::nova::keystone::authtoken':
           password => 'secrete',
         }
         class { '::nova::api':
           service_name   => 'httpd',
         }"
      end
      it { is_expected.to contain_class('nova::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('nova_api_wsgi').with(
        :bind_port                   => 8774,
        :group                       => 'nova',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'nova',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'nova-api',
        :wsgi_process_group          => 'nova-api',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'nova-api',
        :wsgi_script_source          => platform_params[:api_wsgi_script_source],
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
         class { '::nova::api':
           service_name   => 'httpd',
         }"
      end

      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :api_port                    => 12345,
          :ssl                         => false,
          :wsgi_process_display_name   => 'nova-api',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log'
        }
      end

      it { is_expected.to contain_class('nova::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('nova_api_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'nova',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'nova',
        :workers                     => 37,
        :wsgi_daemon_process         => 'nova-api',
        :wsgi_process_display_name   => 'nova-api',
        :wsgi_process_group          => 'nova-api',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'nova-api',
        :wsgi_script_source          => platform_params[:api_wsgi_script_source],
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log'
      )}
    end

    context 'when ::nova::api is missing in the composition layer' do

      let :pre_condition do
        "include nova"
      end

      it { should raise_error(Puppet::Error, /::nova::api class must be declared in composition layer./) }
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
            :httpd_service_name     => 'apache2',
            :httpd_ports_file       => '/etc/apache2/ports.conf',
            :wsgi_script_path       => '/usr/lib/cgi-bin/nova',
            :api_wsgi_script_source => '/usr/bin/nova-api-wsgi',
          }
        when 'RedHat'
          {
            :httpd_service_name     => 'httpd',
            :httpd_ports_file       => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path       => '/var/www/cgi-bin/nova',
            :api_wsgi_script_source => '/usr/bin/nova-api-wsgi',
          }
        end
      end

      it_behaves_like 'apache serving nova with mod_wsgi'
    end
  end
end
