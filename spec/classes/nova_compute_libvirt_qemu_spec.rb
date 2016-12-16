require 'spec_helper'

describe 'nova::compute::libvirt::qemu' do

  let :pre_condition do
   'include nova
    include nova::compute
    include nova::compute::libvirt'
  end

  shared_examples_for 'nova compute libvirt with qemu' do

    context 'when not configuring qemu' do
      let :params do
        {
          :configure_qemu => false
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [ "rm max_files", "rm max_processes" ],
      }).that_notifies('Service[libvirt]') }
    end

    context 'when configuring qemu by default' do
      let :params do
        {
          :configure_qemu => true
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [ "set max_files 1024", "set max_processes 4096" ],
        :tag     => 'qemu-conf-augeas',
      }).that_notifies('Service[libvirt]') }
    end

    context 'when configuring qemu with overriden parameters' do
      let :params do
        {
          :configure_qemu => true,
          :max_files => 32768,
          :max_processes => 131072,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [ "set max_files 32768", "set max_processes 131072" ],
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

      it_configures 'nova compute libvirt with qemu'
     end
  end

end
