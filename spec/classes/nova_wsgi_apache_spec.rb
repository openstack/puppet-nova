# This class is deprecated, we'll remove the test in a future release.
require 'spec_helper'

describe 'nova::wsgi::apache' do

 let :pre_condition do
   "include nova
    class { '::nova::keystone::authtoken':
      password => 'secrete',
    }
    class { '::nova::api':
      service_name   => 'httpd',
    }"
 end

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
      it { is_expected.to contain_class('nova::wsgi::apache_api').with(
        :servername => facts[:fqdn],
        :api_port   => 8774,
        :path       => '/',
        :ssl        => true,
        :workers    => 1,
        :threads    => facts[:os_workers],
        :priority   => '10',
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
          :servername                => 'dummy.host',
          :bind_host                 => '10.42.51.1',
          :api_port                  => 12345,
          :ssl                       => false,
          :wsgi_process_display_name => 'nova-api',
          :workers                   => 37,
        }
      end

      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_class('nova::wsgi::apache_api').with(
        :servername                => 'dummy.host',
        :api_port                  => 12345,
        :path                      => '/',
        :ssl                       => false,
        :wsgi_process_display_name => 'nova-api',
        :workers                   => 37,
        :threads                   => facts[:os_workers],
        :priority                  => '10',
      )}

    end

    context 'when ::nova::api is missing in the composition layer' do

      let :pre_condition do
        "include nova"
      end

      it { is_expected.to raise_error Puppet::Error, /::nova::api class must be declared in composition layer./ }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 8,
          :fqdn           => 'some.host.tld'
        }))
      end

      let (:platform_params) do
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
