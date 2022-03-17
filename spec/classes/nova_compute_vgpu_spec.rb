require 'spec_helper'

describe 'nova::compute::vgpu' do

  shared_examples_for 'nova-compute-vgpu' do
    context 'with default parameters' do
      it 'clears vgpu devices' do
        is_expected.to contain_nova_config('devices/enabled_mdev_types').with_ensure('absent')
      end
    end

    context 'with vgpu types and device addresses mapping' do
      let :params do
        {
          :vgpu_types_device_addresses_mapping => { "nvidia-35" => [] },
        }
      end
      it { is_expected.to contain_nova_config('devices/enabled_mdev_types').with_value('nvidia-35') }
      it { is_expected.to contain_nova_config('mdev_nvidia-35/device_addresses').with_value('<SERVICE DEFAULT>') }
    end

    context 'with multiple vgpu types and corresponding device addresses mapping' do
      let :params do
        {
          :vgpu_types_device_addresses_mapping => { "nvidia-35" => ['0000:84:00.0', '0000:85:00.0'],
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

      it_configures 'nova-compute-vgpu'
    end
  end
end
