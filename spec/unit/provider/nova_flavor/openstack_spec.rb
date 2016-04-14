require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova_flavor/openstack'

provider_class = Puppet::Type.type(:nova_flavor).provider(:openstack)

describe provider_class do

  describe 'managing flavors' do
    let(:flavor_attrs) do
      {
        :name     => 'example',
        :id       => '1',
        :ram      => '512',
        :disk     => '1',
        :vcpus    => '1',
        :ensure   => 'present',
      }
    end

    let :resource do
      Puppet::Type::Nova_flavor.new(flavor_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    describe '#create' do
      it 'creates flavor' do
        provider.class.stubs(:openstack)
                      .with('flavor', 'list', ['--long', '--all'])
                      .returns('"ID", "Name", "RAM", "Disk", "Ephemeral", "VCPUs", "Is Public", "Swap", "RXTX Factor", "Properties"')
        provider.class.stubs(:openstack)
            .with('flavor', 'create', 'shell', ['example', '--public', '--id', '1', '--ram', '512', '--disk', '1', '--vcpus', '1'])
                .returns('os-flv-disabled:disabled="False"
os-flv-ext-data:ephemeral="0"
disk="1"
id="1"
name="example"
os-flavor-access:is_public="True"
ram="512"
rxtx_factor="1.0"
swap=""
vcpus="1"')
      end
    end

    describe '#destroy' do
      it 'removes flavor' do
        provider_class.expects(:openstack)
          .with('flavor', 'delete', '1')
        provider.instance_variable_set(:@property_hash, flavor_attrs)
        provider.destroy
        expect(provider.exists?).to be_falsey
      end
    end
  end
end

