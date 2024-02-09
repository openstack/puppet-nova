require 'spec_helper'

describe 'nova::migration::qemu' do

  let :pre_condition do
   'include nova
    include nova::compute
    include nova::compute::libvirt'
  end

  shared_examples_for 'nova migration with qemu' do

    context 'when not configuring qemu' do
      it 'should clear all configurations' do
        is_expected.to contain_qemu_config('migration_address').with_ensure('absent')
        is_expected.to contain_qemu_config('migration_host').with_ensure('absent')
        is_expected.to contain_qemu_config('migration_port_min').with_ensure('absent')
        is_expected.to contain_qemu_config('migration_port_max').with_ensure('absent')
      end
    end

    context 'when configuring qemu with defaults' do
      let :params do
        {
          :configure_qemu => true
        }
      end
      it 'should configure the default values' do
        is_expected.to contain_qemu_config('migration_address').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_qemu_config('migration_host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_qemu_config('migration_port_min').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_qemu_config('migration_port_max').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when configuring qemu with overridden parameters' do
      let :params do
        {
          :configure_qemu     => true,
          :migration_address  => '0.0.0.0',
          :migration_host     => 'host.example.com',
          :migration_port_min => 61138,
          :migration_port_max => 61200,
        }
      end
      it 'should configure the given values' do
        is_expected.to contain_qemu_config('migration_address').with_value('0.0.0.0')
        is_expected.to contain_qemu_config('migration_host').with_value('host.example.com')
        is_expected.to contain_qemu_config('migration_port_min').with_value(61138)
        is_expected.to contain_qemu_config('migration_port_max').with_value(61200)
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

      it_configures 'nova migration with qemu'
     end
  end

end
