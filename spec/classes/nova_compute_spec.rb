require 'spec_helper'

describe 'nova::compute' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova-compute' do

    context 'with default parameters' do

      it 'installs nova-compute package and service' do
        should contain_service('nova-compute').with({
          :name      => platform_params[:nova_compute_service],
          :ensure    => 'stopped',
          :hasstatus => true,
          :enable    => false
        })
        should contain_package('nova-compute').with({
          :name => platform_params[:nova_compute_package]
        })
      end

      it { should contain_nova_config('DEFAULT/network_device_mtu').with(:ensure => 'absent') }
      it { should_not contain_nova_config('DEFAULT/novncproxy_base_url') }

      it { should_not contain_package('bridge-utils').with(
        :ensure => 'present',
        :before => 'Nova::Generic_service[compute]'
      ) }

      it { should contain_package('pm-utils').with(
        :ensure => 'present'
      ) }
    end

    context 'with overridden parameters' do
      let :params do
        { :enabled            => true,
          :ensure_package     => '2012.1-2',
          :vncproxy_host      => '127.0.0.1',
          :network_device_mtu => 9999 }
      end

      it 'installs nova-compute package and service' do
        should contain_service('nova-compute').with({
          :name      => platform_params[:nova_compute_service],
          :ensure    => 'running',
          :hasstatus => true,
          :enable    => true
        })
        should contain_package('nova-compute').with({
          :name   => platform_params[:nova_compute_package],
          :ensure => '2012.1-2'
        })
      end

      it 'configures network_device_mtu' do
        should contain_nova_config('DEFAULT/network_device_mtu').with_value('9999')
      end

      it 'configures vnc in nova.conf' do
        should contain_nova_config('DEFAULT/vnc_enabled').with_value(true)
        should contain_nova_config('DEFAULT/vncserver_proxyclient_address').with_value('127.0.0.1')
        should contain_nova_config('DEFAULT/novncproxy_base_url').with_value(
          'http://127.0.0.1:6080/vnc_auto.html'
        )
      end
    end

    context 'with neutron_enabled set to false' do
      let :params do
        { :neutron_enabled => false }
      end

      it 'installs bridge-utils package for nova-network' do
        should contain_package('bridge-utils').with(
          :ensure => 'present',
          :before => 'Nova::Generic_service[compute]'
        )
      end
    end

    context 'with vnc_enabled set to false' do
      let :params do
        { :vnc_enabled => false }
      end

      it 'disables vnc in nova.conf' do
        should contain_nova_config('DEFAULT/vnc_enabled').with_value(false)
        should contain_nova_config('DEFAULT/vncserver_proxyclient_address').with_value('127.0.0.1')
        should_not contain_nova_config('DEFAULT/novncproxy_base_url')
      end
    end

    context 'with force_config_drive parameter set to true' do
      let :params do
        { :force_config_drive => true }
      end

      it { should contain_nova_config('DEFAULT/force_config_drive').with_value(true) }
    end
  end


  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :nova_compute_package => 'nova-compute',
        :nova_compute_service => 'nova-compute' }
    end

    it_behaves_like 'nova-compute'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :nova_compute_package => 'openstack-nova-compute',
        :nova_compute_service => 'openstack-nova-compute' }
    end

    it_behaves_like 'nova-compute'
  end
end
