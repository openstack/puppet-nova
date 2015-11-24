require 'puppet'
require 'puppet/provider/nova_floating/nova_manage'
require 'tempfile'

provider_class = Puppet::Type.type(:nova_floating).provider(:nova_manage)

describe provider_class do

  let :range_attrs do
    {
      :ensure          => 'present',
      :pool            => 'nova',
      :network         => '10.1.0.1-10.1.0.2',
    }
  end

  let :network_attrs do
    {
      :ensure         => 'present',
      :pool           => 'nova',
      :network        => '11.1.0.0/30'
    }
  end

  let :resource_range do
    Puppet::Type::Nova_floating.new(range_attrs)
  end

  let :resource_network do
    Puppet::Type::Nova_floating.new(network_attrs)
  end

  let :provider_range do
    provider_class.new(resource_range)
  end

  let :provider_network do
    provider_class.new(resource_network)
  end

  shared_examples 'nova_floating' do

    describe '#exists?' do

      it 'should check if ips of a network are not existing' do
        provider_network.expects(:nova_manage).with('floating', 'list').returns('No floating IP addresses have been defined.')
        expect(provider_network.exists?).to be_falsey
        end
      it 'should check if ips of a network are existing' do
        provider_network.expects(:nova_manage).with('floating', 'list').returns('None    11.1.0.1        None    nova    br-ex\nNone    11.1.0.2        None    nova    br-ex')
        expect(provider_network.exists?).to be_truthy
       end

      it 'should check if ips are not existing' do
        provider_range.expects(:nova_manage).with('floating', 'list').returns('No floating IP addresses have been defined.')
        expect(provider_range.exists?).to be_falsey
      end
      it 'should check if ips are existing' do
        provider_range.expects(:nova_manage).with('floating', 'list').returns('None    10.1.0.1        None    nova    br-ex\nNone    10.1.0.2        None    nova    br-ex')
        expect(provider_range.exists?).to be_truthy
      end

    end

    describe '#create' do
      it 'should check if ips of network were created' do
        provider_network.expects(:nova_manage).with('floating', 'create', '--pool', 'nova', '11.1.0.0/30').returns('None    11.1.0.1        None    nova    br-ex\nNone    11.1.0.2        None    nova    br-ex')
        expect(provider_network.create).to be_truthy
      end

      it 'should check if ips of range were created' do
        provider_range.stubs(:nova_manage).with('floating', 'create', '10.1.0.1')
        provider_range.stubs(:nova_manage).with('floating', 'create', '10.1.0.2')
        provider_range.stubs(:nova_manage).with('floating', 'list').returns('None    10.1.0.1        None    nova    br-ex\nNone    10.1.0.2        None    nova    br-ex')
        expect(provider_range.create).to be_truthy
      end

    end


    describe '#destroy' do
      it 'should check if ips of network were deleted' do
        provider_network.expects(:nova_manage).with('floating', 'delete', '11.1.0.0/30').returns('No floating IP addresses have been defined.')
      expect(provider_network.destroy).to be_truthy
      end

      it 'should check if ips of range were deleted' do
        provider_range.stubs(:nova_manage).with('floating', 'delete', '10.1.0.1')
        provider_range.expects(:nova_manage).with('floating', 'list').returns('None    10.1.0.2        None    nova    br-ex')
        provider_range.stubs(:nova_manage).with('floating', 'delete', '10.1.0.2')
        provider_range.expects(:nova_manage).with('floating', 'list').returns('No floating IP addresses have been defined.')
        expect(provider_range.destroy).to be_truthy
      end

    end
 end

it_behaves_like('nova_floating')
end
