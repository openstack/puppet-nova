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
        { :libvirt_service_name => false }
      end

      it 'disable libvirt service' do
        is_expected.not_to contain_package('libvirt')
        is_expected.not_to contain_service('libvirt')
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
    end
  end
end
