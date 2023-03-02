require 'spec_helper'

describe 'nova::spicehtml5proxy' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova::spicehtml5proxy' do
    it 'configures nova.conf' do
      should contain_nova_config('spice/html5proxy_host').with(:value => '0.0.0.0')
      should contain_nova_config('spice/html5proxy_port').with(:value => '6082')
    end

    it { should contain_package('nova-spicehtml5proxy').with(
      :ensure => 'present',
      :name   => platform_params[:spicehtml5proxy_package_name]
    ) }

    it { should contain_service('nova-spicehtml5proxy').with(
      :ensure    => 'running',
      :name      => platform_params[:spicehtml5proxy_service_name],
      :hasstatus => true
    )}

    context 'with manage_service as false' do
      let :params do
        {
          :manage_service => false
        }
      end

      it { should_not contain_service('nova-spicehtml5proxy') }
    end

    context 'with package version' do
      let :params do
        { :ensure_package => '2012.1-2' }
      end

      it { should contain_package('nova-spicehtml5proxy').with(
        :ensure => params[:ensure_package],
        :name   => platform_params[:spicehtml5proxy_package_name],
      )}
    end
  end

  shared_examples 'nova::spicehtml5proxy on Debian' do
    let :params do
      {
        :enabled => true
      }
    end

    it { should contain_file_line('/etc/default/nova-consoleproxy:NOVA_CONSOLE_PROXY_TYPE').with(
        :path    => '/etc/default/nova-consoleproxy',
        :match   => '^NOVA_CONSOLE_PROXY_TYPE=(.*)$',
        :line    => 'NOVA_CONSOLE_PROXY_TYPE=spicehtml5',
        :tag     => 'nova-consoleproxy',
        :require => 'Anchor[nova::config::begin]',
        :notify  => 'Anchor[nova::config::end]',
    )}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          if facts[:os]['name'] == 'Debian' then
            package_name = 'nova-consoleproxy'
            service_name = 'nova-spicehtml5proxy'
          else
            package_name = 'nova-spiceproxy'
            service_name = 'nova-spiceproxy'
          end
          {
            :spicehtml5proxy_package_name => package_name,
            :spicehtml5proxy_service_name => service_name
          }
        when 'RedHat'
          {
            :spicehtml5proxy_package_name => 'openstack-nova-console',
            :spicehtml5proxy_service_name => 'openstack-nova-spicehtml5proxy'
          }
        end
      end

      it_behaves_like 'nova::spicehtml5proxy'

      if facts[:os]['name'] == 'Debian'
        it_behaves_like 'nova::spicehtml5proxy on Debian'
      end
    end
  end
end
