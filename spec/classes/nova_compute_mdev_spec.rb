require 'spec_helper'

describe 'nova::compute::mdev' do

  shared_examples_for 'nova-compute-mdev' do
    context 'with default parameters' do
      it 'clears mdev devices' do
        is_expected.to contain_nova_config('devices/enabled_mdev_types').with_ensure('absent')
      end
    end

    context 'with mdev types and device addresses mapping' do
      let :params do
        {
          :mdev_types_device_addresses_mapping => { "nvidia-35" => [] },
        }
      end
      it { is_expected.to contain_nova_config('devices/enabled_mdev_types').with_value('nvidia-35') }
      it { is_expected.to contain_nova_config('mdev_nvidia-35/device_addresses').with_ensure('absent') }
    end

    context 'with multiple mdev types and corresponding device addresses mapping' do
      let :params do
        {
          :mdev_types_device_addresses_mapping => { "nvidia-35" => ['0000:84:00.0', '0000:85:00.0'],
                                                    "nvidia-36" => ['0000:86:00.0'] }
        }
      end

      it { is_expected.to contain_nova_config('devices/enabled_mdev_types').with_value('nvidia-35,nvidia-36') }
      it { is_expected.to contain_nova_config('mdev_nvidia-35/device_addresses').with_value('0000:84:00.0,0000:85:00.0') }
      it { is_expected.to contain_nova_config('mdev_nvidia-36/device_addresses').with_value('0000:86:00.0') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova-compute-mdev'
    end
  end
end
