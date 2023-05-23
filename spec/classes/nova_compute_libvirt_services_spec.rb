require 'spec_helper'

describe 'nova::compute::libvirt::services' do

  shared_examples_for 'nova compute libvirt services' do

    context 'with default parameters' do
      it 'deploys libvirt packages and services' do
        is_expected.to contain_package('libvirt')
        is_expected.to contain_service('libvirt')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :libvirt_service_name => false,
          :modular_libvirt      => false,
        }
      end

      it 'disable libvirt service' do
        is_expected.not_to contain_package('libvirt')
        is_expected.not_to contain_service('libvirt')
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
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_configures 'nova compute libvirt services'
      if facts['osfamily'] == 'RedHat'
        it_configures 'nova compute libvirt services with modular libvirt'
      end
    end
  end
end
