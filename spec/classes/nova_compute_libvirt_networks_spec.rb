require 'spec_helper'

describe 'nova::compute::libvirt::networks' do

  shared_examples_for 'nova::compute::libvirt::networks' do

    context 'with defaults' do
      it { is_expected.to contain_exec('libvirt-default-net-disable-autostart').with(
        :command => 'virsh net-autostart default --disable',
        :path    => ['/bin', '/usr/bin'],
        :onlyif  => [
          'virsh net-info default 2>/dev/null',
          'virsh net-info default 2>/dev/null | grep -i "^autostart:\s*yes"'
        ]
      ) }
      it { is_expected.to contain_exec('libvirt-default-net-destroy').with(
        :command => 'virsh net-destroy default',
        :path    => ['/bin', '/usr/bin'],
        :onlyif  => [
          'virsh net-info default 2>/dev/null',
          'virsh net-info default 2>/dev/null | grep -i "^active:\s*yes"'
        ]
      ) }
    end

    context 'when not disabling the default network' do
      let :params do
        {
          :disable_default_network => false
        }
      end
      it { is_expected.to_not contain_exec('libvirt-default-net-disable-autostart') }
      it { is_expected.to_not contain_exec('libvirt-default-net-destroy') }
    end
  end

  on_supported_os({
     :supported_os => OSDefaults.get_supported_os
   }).each do |os,facts|
     context "on #{os}" do
       let (:facts) do
         facts.merge!(OSDefaults.get_facts())
       end

      it_configures 'nova::compute::libvirt::networks'
     end
  end

end
