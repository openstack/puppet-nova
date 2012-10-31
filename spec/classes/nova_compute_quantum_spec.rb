require 'spec_helper'
describe 'nova::compute::quantum' do

  it { should contain_nova_config('libvirt_use_virtio_for_bridges').with_value('True')}
  it { should contain_nova_config('libvirt_vif_driver').with_value('nova.virt.libvirt.vif.LibvirtOpenVswitchDriver')}

  context 'when overriding params' do
    let :params do
      {:libvirt_vif_driver => 'foo' }
    end
    it { should contain_nova_config('libvirt_vif_driver').with_value('foo')}
  end

end
