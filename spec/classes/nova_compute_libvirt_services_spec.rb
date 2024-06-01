require 'spec_helper'

describe 'nova::compute::libvirt::services' do

  shared_examples_for 'nova compute libvirt services' do

    context 'with default parameters' do
      it 'deploys libvirt service' do
        is_expected.to contain_package('libvirt').with(
          :ensure => 'present',
          :name   => platform_params[:libvirt_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
        is_expected.to contain_service('libvirt').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:libvirt_service_name],
          :tag    => ['libvirt-service', 'libvirt-qemu-service'],
        )
      end

      it 'installs ovmf' do
        is_expected.to contain_package('ovmf').with(
          :ensure => 'present',
          :name   => platform_params[:ovmf_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
      end

      it 'installs swtpm' do
        is_expected.to_not contain_package('swtpm').with(
          :ensure => 'present',
          :name   => platform_params[:swtpm_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :libvirt_service_name => false,
          :manage_ovmf          => false,
          :manage_swtpm         => true,
        }
      end

      it 'skips installing libvirt' do
        is_expected.not_to contain_package('libvirt')
        is_expected.not_to contain_service('libvirt')
      end

      it 'skips installing ovmf' do
        is_expected.not_to contain_package('ovmf')
      end

      it 'skips installs swtpm' do
        is_expected.to contain_package('swtpm')
      end
    end
  end

  shared_examples_for 'nova compute libvirt services with modular libvirt' do
    context 'with default parameters' do
      let :params do
        {
          :modular_libvirt => true
        }
      end

      it 'deploys libvirt packages and services with modular-libvirt' do
        is_expected.to contain_package('libvirt')
        is_expected.to contain_package('virtqemu')
        is_expected.to contain_package('virtsecret')
        is_expected.to contain_package('virtstorage')
        is_expected.to contain_package('virtnodedev')
        is_expected.to contain_service('virtlogd')
        is_expected.to contain_service('virtproxyd')
        is_expected.to contain_service('virtnodedevd')
        is_expected.to contain_service('virtsecretd')
        is_expected.to contain_service('virtstoraged')
        is_expected.to contain_service('virtqemud')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let :facts do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
        case facts[:os]['family']
        when 'Debian'
          {
            :libvirt_package_name => 'libvirt-daemon-system',
            :libvirt_service_name => 'libvirtd',
            :ovmf_package_name    => 'ovmf',
            :swtpm_package_name   => 'swtpm'
          }
        when 'RedHat'
          {
            :libvirt_package_name => 'libvirt-daemon-kvm',
            :libvirt_service_name => 'libvirtd',
            :ovmf_package_name    => 'edk2-ovmf',
            :swtpm_package_name   => 'swtpm'
          }
        end
      end

      it_configures 'nova compute libvirt services'
      if facts[:os]['family'] == 'RedHat'
        it_configures 'nova compute libvirt services with modular libvirt'
      end
    end
  end
end
