require 'spec_helper'

describe 'nova::compute::vgpu' do

  shared_examples_for 'nova-compute-vgpu' do
    context 'with default parameters' do
      it 'clears vgpu devices' do
        is_expected.to contain_nova_config('devices/enabled_vgpu_types').with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'with vgpu device' do
      let :params do
        {
            :enabled_vgpu_types => "nvidia-35",
        }
      end
      it 'configures nova vgpu device entries' do
        is_expected.to contain_nova_config('devices/enabled_vgpu_types').with(
          'value' => 'nvidia-35'
        )
      end
    end

    context 'with multiple vgpu devices' do
      let :params do
        {
          :enabled_vgpu_types => ["nvidia-35","nvidia-36"]
        }
      end

      it 'configures nova vgpu device entries' do
        is_expected.to contain_nova_config('devices/enabled_vgpu_types').with(
          'value' => "nvidia-35,nvidia-36"
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

      it_configures 'nova-compute-vgpu'
    end
  end
end
