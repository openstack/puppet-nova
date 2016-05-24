require 'spec_helper'

describe 'nova::wsgi::apache' do

  let :global_facts do
    @default_facts.merge({
      :processorcount => 42,
      :concat_basedir => '/var/lib/puppet/concat',
      :fqdn           => 'some.host.tld'
    })
  end

 let :pre_condition do
   "include nova
    class { '::nova::api':
      service_name   => 'httpd',
      admin_password => 'secrete',
    }"
 end

  shared_examples_for 'apache serving nova with mod_wsgi' do
    it { is_expected.to contain_service('httpd').with_name(platform_parameters[:httpd_service_name]) }
    it { is_expected.to contain_class('nova::params') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_class('apache::mod::wsgi') }

    describe 'with default parameters' do

      let :pre_condition do
        "include nova
         class { '::nova::api':
           service_name   => 'httpd',
           admin_password => 'secrete',
         }"
      end

      it { is_expected.to contain_file("#{platform_parameters[:wsgi_script_path]}").with(
        'ensure'  => 'directory',
        'owner'   => 'nova',
        'group'   => 'nova',
        'require' => 'Package[httpd]'
      )}


      it { is_expected.to contain_file('nova_api_wsgi').with(
        'ensure'  => 'file',
        'path'    => "#{platform_parameters[:wsgi_script_path]}/nova-api",
        'source'  => platform_parameters[:api_wsgi_script_source],
        'owner'   => 'nova',
        'group'   => 'nova',
        'mode'    => '0644'
      )}
      it { is_expected.to contain_file('nova_api_wsgi').that_requires("File[#{platform_parameters[:wsgi_script_path]}]") }

      it { is_expected.to contain_apache__vhost('nova_api_wsgi').with(
        'servername'                  => 'some.host.tld',
        'ip'                          => nil,
        'port'                        => '8774',
        'docroot'                     => "#{platform_parameters[:wsgi_script_path]}",
        'docroot_owner'               => 'nova',
        'docroot_group'               => 'nova',
        'ssl'                         => 'true',
        'wsgi_daemon_process'         => 'nova-api',
        'wsgi_process_group'          => 'nova-api',
        'wsgi_script_aliases'         => { '/' => "#{platform_parameters[:wsgi_script_path]}/nova-api" },
        'require'                     => 'File[nova_api_wsgi]'
      )}
      it { is_expected.to contain_concat("#{platform_parameters[:httpd_ports_file]}") }

      it { is_expected.to contain_file('nova_api_wsgi').with(
        'ensure'  => 'file',
        'path'    => "#{platform_parameters[:wsgi_script_path]}/nova-api",
        'source'  => platform_parameters[:api_wsgi_script_source],
        'owner'   => 'nova',
        'group'   => 'nova',
        'mode'    => '0644'
      )}
      it { is_expected.to contain_file('nova_api_wsgi').that_requires("File[#{platform_parameters[:wsgi_script_path]}]") }

      it { is_expected.to contain_concat("#{platform_parameters[:httpd_ports_file]}") }
    end

    describe 'when overriding parameters using different ports' do
      let :pre_condition do
        "include nova
         class { '::nova::api':
           service_name   => 'httpd',
           admin_password => 'secrete',
         }"
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

      it { is_expected.to contain_apache__vhost('nova_api_wsgi').with(
        'servername'                  => 'dummy.host',
        'ip'                          => '10.42.51.1',
        'port'                        => '12345',
        'docroot'                     => "#{platform_parameters[:wsgi_script_path]}",
        'docroot_owner'               => 'nova',
        'docroot_group'               => 'nova',
        'ssl'                         => 'false',
        'wsgi_daemon_process'         => 'nova-api',
        'wsgi_process_group'          => 'nova-api',
        'wsgi_script_aliases'         => { '/' => "#{platform_parameters[:wsgi_script_path]}/nova-api" },
        'require'                     => 'File[nova_api_wsgi]'
      )}
    end

    describe 'when ::nova::api is missing in the composition layer' do

      let :pre_condition do
        "include nova"
      end

      it { is_expected.to raise_error Puppet::Error, /::nova::api class must be declared in composition layer./ }
    end

  end

  context 'on RedHat platforms' do
    let :facts do
      global_facts.merge({
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '7.0'
      })
    end

    let :platform_parameters do
      {
        :httpd_service_name     => 'httpd',
        :httpd_ports_file       => '/etc/httpd/conf/ports.conf',
        :wsgi_script_path       => '/var/www/cgi-bin/nova',
        :api_wsgi_script_source => '/usr/lib/python2.7/site-packages/nova/wsgi/nova-api.py',
      }
    end

    it_configures 'apache serving nova with mod_wsgi'
  end

  context 'on Debian platforms' do
    let :facts do
      global_facts.merge({
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7.0'
      })
    end

    let :platform_parameters do
      {
        :httpd_service_name     => 'apache2',
        :httpd_ports_file       => '/etc/apache2/ports.conf',
        :wsgi_script_path       => '/usr/lib/cgi-bin/nova',
        :api_wsgi_script_source => '/usr/lib/python2.7/dist-packages/nova/wsgi/nova-api.py',
      }
    end

    it_configures 'apache serving nova with mod_wsgi'
  end
end
