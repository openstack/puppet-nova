require 'spec_helper'

describe 'nova::migration::qemu' do

  let :pre_condition do
   'include nova
    include nova::compute
    include nova::compute::libvirt'
  end

  shared_examples_for 'nova migration with qemu' do

    context 'when not configuring qemu' do
      let :params do
        {
          :configure_qemu => false
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-migration-ports').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [ "rm migration_port_min", "rm migration_port_max" ],
      }).that_notifies('Service[libvirt]') }
    end

    context 'when configuring qemu by default' do
      let :params do
        {
          :configure_qemu => true
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-migration-ports').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [ "set migration_port_min 49152", "set migration_port_max 49215" ],
        :tag     => 'qemu-conf-augeas',
      }).that_notifies('Service[libvirt]') }
    end

    context 'when configuring qemu with overriden parameters' do
      let :params do
        {
          :configure_qemu => true,
          :migration_port_min => 61138,
          :migration_port_max => 61200,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-migration-ports').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [ "set migration_port_min 61138", "set migration_port_max 61200" ],
        :tag     => 'qemu-conf-augeas',
      }).that_notifies('Service[libvirt]') }
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
