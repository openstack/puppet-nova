require 'spec_helper'

describe 'nova::compute::mdev' do

  shared_examples_for 'nova-compute-mdev' do
    context 'with default parameters' do
      it 'clears mdev devices' do
        is_expected.to contain_nova_config('devices/enabled_mdev_types').with_ensure('absent')
      end
    end

    context 'with mdev_types' do
      let :params do
        {
          :mdev_types => {
            'nvidia-35' => {
              'device_addresses' => ['0000:84:00.0', '0000:85:00.0']
            },
            'nvidia-36' => {
              'device_addresses' => [],
              'mdev_class'       => 'CUSTOM_MDEV1'
            },
            'nvidia-37' => {
              'mdev_class' => 'VGPU'
            }
          }
        }
      end

      it 'configures mdev devices' do
        is_expected.to contain_nova_config('devices/enabled_mdev_types').with_value('nvidia-35,nvidia-36,nvidia-37')
        is_expected.to contain_nova_config('mdev_nvidia-35/device_addresses').with_value('0000:84:00.0,0000:85:00.0')
        is_expected.to contain_nova_config('mdev_nvidia-35/mdev_class').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('mdev_nvidia-36/device_addresses').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('mdev_nvidia-36/mdev_class').with_value('CUSTOM_MDEV1')
        is_expected.to contain_nova_config('mdev_nvidia-37/device_addresses').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('mdev_nvidia-37/mdev_class').with_value('VGPU')
      end
    end

    context 'with device addresses mapping' do
      context 'with a single mdev type' do
        let :params do
          {
            :mdev_types_device_addresses_mapping => {
              "nvidia-35" => []
            }
          }
        end

        it 'configures mdev devices' do
          is_expected.to contain_nova_config('devices/enabled_mdev_types').with_value('nvidia-35')
          is_expected.to contain_nova_config('mdev_nvidia-35/device_addresses').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_nova_config('mdev_nvidia-35/mdev_class').with_value('<SERVICE DEFAULT>')
        end
      end

      context 'with multiple mdev types' do
        let :params do
          {
            :mdev_types_device_addresses_mapping => {
              'nvidia-35' => ['0000:84:00.0', '0000:85:00.0'],
              'nvidia-36' => []
            }
          }
        end

        it 'configures mdev devices' do
          is_expected.to contain_nova_config('devices/enabled_mdev_types').with_value('nvidia-35,nvidia-36')
          is_expected.to contain_nova_config('mdev_nvidia-35/device_addresses').with_value('0000:84:00.0,0000:85:00.0')
          is_expected.to contain_nova_config('mdev_nvidia-35/mdev_class').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_nova_config('mdev_nvidia-36/device_addresses').with_value('<SERVICE DEFAULT>')
          is_expected.to contain_nova_config('mdev_nvidia-36/mdev_class').with_value('<SERVICE DEFAULT>')
        end
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

      it_configures 'nova-compute-mdev'
    end
  end
end
