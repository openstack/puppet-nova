require 'spec_helper'

describe 'nova::compute::libvirt::services' do

  shared_examples_for 'nova compute libvirt services' do
    context 'with default parameters' do
      it 'installs ovmf' do
        is_expected.to contain_package('ovmf').with(
          :ensure => 'present',
          :name   => platform_params[:ovmf_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
      end

      it 'skips installs swtpm' do
        is_expected.to_not contain_package('swtpm')
      end
    end

    context 'when libvirt service is not managed' do
      let :params do
        {
          :libvirt_service_name => false,
        }
      end

      it 'skips installing libvirt' do
        is_expected.not_to contain_package('libvirt')
        is_expected.not_to contain_package('libvirt-daemon')
        is_expected.not_to contain_service('libvirt')
      end
    end

    context 'when ovmf package is not managed' do
      let :params do
        {
          :manage_ovmf => false,
        }
      end

      it 'skips installing ovmf' do
        is_expected.not_to contain_package('ovmf')
      end
    end

    context 'when swtpm package is managed' do
      let :params do
        {
          :manage_swtpm => true,
        }
      end

      it 'installs swtpm' do
        is_expected.to contain_package('swtpm').with(
          :ensure => 'present',
          :name   => platform_params[:swtpm_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
      end
    end
  end

  shared_examples_for 'nova compute libvirt services with monolithic libvirt' do
    context 'with default parameters' do
      it 'deploys libvirt service' do
        is_expected.to contain_package('libvirt').with(
          :ensure => 'present',
          :name   => platform_params[:libvirt_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
        if facts[:os]['family'] == 'RedHat'
          is_expected.to contain_package('libvirt-daemon').with(
            :ensure => 'present',
            :name   => platform_params[:libvirt_daemon_package_name],
            :tag    => ['openstack', 'nova-support-package'],
          )
        end

        is_expected.to contain_service('libvirt').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:libvirt_service_name],
          :tag    => ['libvirt-service', 'libvirt-qemu-service'],
        )
        is_expected.to contain_service('virtlogd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtlog_service_name],
          :tag    => ['libvirt-service'],
        )
        is_expected.to contain_service('virtlockd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtlock_service_name],
          :tag    => ['libvirt-service'],
        )
      end

      it 'does not deploy modular libvirt services' do
        is_expected.to_not contain_package('virtsecret')
        is_expected.to_not contain_package('virtnodedev')
        is_expected.to_not contain_package('virtqemu')
        is_expected.to_not contain_package('virtstorage')

        is_expected.to_not contain_service('virtsecretd')
        is_expected.to_not contain_service('virtnodedevd')
        is_expected.to_not contain_service('virtqemud')
        is_expected.to_not contain_service('virtproxyd')
        is_expected.to_not contain_service('virtstoraged')
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

      it 'deploys libvirt service' do
        is_expected.to contain_package('libvirt').with(
          :ensure => 'present',
          :name   => platform_params[:libvirt_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
        is_expected.to_not contain_package('libvirt-daemon')

        is_expected.to contain_service('libvirt').with(
          :ensure => 'stopped',
          :enable => false,
          :name   => platform_params[:libvirt_service_name],
          :tag    => ['libvirt-service', 'libvirt-qemu-service'],
        )
        is_expected.to contain_service('virtlogd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtlog_service_name],
          :tag    => ['libvirt-service'],
        )
        is_expected.to contain_service('virtlockd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtlock_service_name],
          :tag    => ['libvirt-service'],
        )
      end

      it 'deploys modular libvirt services' do
        is_expected.to contain_package('virtsecret').with(
          :ensure => 'present',
          :name   => platform_params[:virtsecret_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
        is_expected.to contain_package('virtnodedev').with(
          :ensure => 'present',
          :name   => platform_params[:virtnodedev_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
        is_expected.to contain_package('virtqemu').with(
          :ensure => 'present',
          :name   => platform_params[:virtqemu_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )
        is_expected.to contain_package('virtstorage').with(
          :ensure => 'present',
          :name   => platform_params[:virtstorage_package_name],
          :tag    => ['openstack', 'nova-support-package'],
        )

        is_expected.to contain_service('virtsecretd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtsecret_service_name],
          :tag    => ['libvirt-service', 'libvirt-modular-service'],
        )
        is_expected.to contain_service('virtnodedevd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtnodedev_service_name],
          :tag    => ['libvirt-service', 'libvirt-modular-service'],
        )
        is_expected.to contain_service('virtqemud').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtqemu_service_name],
          :tag    => ['libvirt-service', 'libvirt-qemu-service', 'libvirt-modular-service'],
        )
        is_expected.to contain_service('virtproxyd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtproxy_service_name],
          :tag    => ['libvirt-service', 'libvirt-modular-service'],
        )
        is_expected.to contain_service('virtnodedevd').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtnodedev_service_name],
          :tag    => ['libvirt-service', 'libvirt-modular-service'],
        )
        is_expected.to contain_service('virtstoraged').with(
          :ensure => 'running',
          :enable => true,
          :name   => platform_params[:virtstorage_service_name],
          :tag    => ['libvirt-service', 'libvirt-modular-service'],
        )
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
            :libvirt_package_name        => 'libvirt-daemon-system',
            :libvirt_service_name        => 'libvirtd',
            :virtlock_service_name       => 'virtlockd',
            :virtlog_service_name        => 'virtlogd',
            :ovmf_package_name           => 'ovmf',
            :swtpm_package_name          => 'swtpm'
          }
        when 'RedHat'
          {
            :libvirt_package_name          => 'libvirt-daemon-kvm',
            :libvirt_daemon_package_name   => 'libvirt-daemon',
            :libvirt_service_name          => 'libvirtd',
            :virtlock_service_name         => 'virtlockd',
            :virtlog_service_name          => 'virtlogd',
            :virtsecret_package_name       => 'libvirt-daemon-driver-secret',
            :virtnodedev_package_name      => 'libvirt-daemon-driver-nodedev',
            :virtqemu_package_name         => 'libvirt-daemon-driver-qemu',
            :virtstorage_package_name      => 'libvirt-daemon-driver-storage',
            :virtsecret_service_name       => 'virtsecretd.socket',
            :virtnodedev_service_name      => 'virtnodedevd.socket',
            :virtqemu_service_name         => 'virtqemud.socket',
            :virtproxy_service_name        => 'virtproxyd.socket',
            :virtstorage_service_name      => 'virtstoraged.socket',
            :ovmf_package_name             => 'edk2-ovmf',
            :swtpm_package_name            => 'swtpm'
          }
        end
      end

      it_configures 'nova compute libvirt services'
      it_configures 'nova compute libvirt services with monolithic libvirt'
      if facts[:os]['family'] == 'RedHat'
        it_configures 'nova compute libvirt services with modular libvirt'
      end
    end
  end
end
