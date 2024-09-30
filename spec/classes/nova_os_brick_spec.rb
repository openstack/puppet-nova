require 'spec_helper'

describe 'nova::os_brick' do

  shared_examples 'nova::os_brick' do

    context 'with defaults' do
      it 'configures the default values' do
        is_expected.to contain_oslo__os_brick('nova_config').with(
          :lock_path                  => '<SERVICE DEFAULT>',
          :wait_mpath_device_attempts => '<SERVICE DEFAULT>',
          :wait_mpath_device_interval => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with parameters overridden' do
      let :params do
        {
          :lock_path                  => '/var/lib/openstack/lock',
          :wait_mpath_device_attempts => 4,
          :wait_mpath_device_interval => 1,
        }
      end

      it 'configures the overridden values' do
        is_expected.to contain_oslo__os_brick('nova_config').with(
          :lock_path                  => '/var/lib/openstack/lock',
          :wait_mpath_device_attempts => 4,
          :wait_mpath_device_interval => 1,
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      include_examples 'nova::os_brick'
    end
  end
end
