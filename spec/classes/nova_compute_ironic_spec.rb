require 'spec_helper'

describe 'nova::compute::ironic' do

  shared_examples_for 'nova::compute::ironic' do
    context 'with default parameters' do
      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('ironic.IronicDriver')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :compute_driver => 'ironic.FoobarDriver',
        }
      end

      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('ironic.FoobarDriver')
      end
    end
  end

  shared_examples_for 'nova::compute::ironic in Debian' do
    context 'with default parameters' do
      it 'installs nova-compute-ironic' do
        is_expected.to contain_package('nova-compute-ironic').with(
          :ensure => 'present',
          :tag    => ['openstack', 'nova-package'],
        )
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

      it_configures 'nova::compute::ironic'
      if facts[:os]['family'] == 'Debian'
        it_configures 'nova::compute::ironic in Debian'
      end
    end
  end
end
