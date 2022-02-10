require 'spec_helper'

describe 'nova::serialproxy' do

  let :pre_condition do
    'include nova'
  end

  let :params do
    { :enabled => true }
  end

  shared_examples 'nova-serialproxy' do

    it 'configures nova.conf' do
      is_expected.to contain_nova_config('serial_console/serialproxy_host').with(:value => '0.0.0.0')
      is_expected.to contain_nova_config('serial_console/serialproxy_port').with(:value => '6083')
    end

    it { is_expected.to contain_package('nova-serialproxy').with(
      :name   => platform_params[:serialproxy_package_name],
      :ensure => 'present'
    ) }

    it { is_expected.to contain_service('nova-serialproxy').with(
      :name      => platform_params[:serialproxy_service_name],
      :hasstatus => 'true',
      :ensure    => 'running'
    )}

    context 'with manage_service as false' do
      let :params do
        {
          :manage_service => false
        }
      end
      it { is_expected.to_not contain_service('nova-serialproxy') }
    end

    context 'with package version' do
      let :params do
        { :ensure_package => '2012.2' }
      end

      it { is_expected.to contain_package('nova-serialproxy').with(
        :ensure => params[:ensure_package]
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({}))
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:operatingsystem] == 'Debian'
            { :serialproxy_package_name => 'nova-consoleproxy',
              :serialproxy_service_name => 'nova-serialproxy' }
          else
            { :serialproxy_package_name => 'nova-serialproxy',
              :serialproxy_service_name => 'nova-serialproxy' }
          end
        when 'RedHat'
          { :serialproxy_package_name => 'openstack-nova-serialproxy',
            :serialproxy_service_name => 'openstack-nova-serialproxy' }
        end
      end
      it_configures 'nova-serialproxy'
    end
  end

end
