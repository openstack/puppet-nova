require 'puppet'
require 'puppet/provider/nova_network/nova'
require 'tempfile'

provider_class = Puppet::Type.type(:nova_network).provider(:nova)

describe provider_class do

  let :net_attrs do
    {
      :network => '10.20.0.0/16',
      :label   => 'novanetwork',
      :ensure  => 'present',
    }
  end

  let :resource do
    Puppet::Type::Nova_network.new(net_attrs)
  end

  let :provider do
    provider_class.new(resource)
  end

  shared_examples 'nova_network' do
    describe '#exists?' do
      it 'should check non-existsing network' do
        provider.expects(:auth_nova).with("network-list")
                      .returns('"+--------------------------------------+-------------+-------------+\n| ID                                   | Label       | Cidr        |\n+--------------------------------------+-------------+-------------+\n| 703edc62-36ab-4c41-9d73-884b30e9acbd | novanetwork | 10.0.0.0/16 |\n+--------------------------------------+-------------+-------------+\n"
')
        expect(provider.exists?).to be_falsey
      end

      it 'should check existsing network' do
        provider.expects(:auth_nova).with("network-list")
                      .returns('"+--------------------------------------+-------------+-------------+\n| ID                                   | Label       | Cidr        |\n+--------------------------------------+-------------+-------------+\n| 703edc62-36ab-4c41-9d73-884b30e9acbd | novanetwork | 10.20.0.0/16 |\n+--------------------------------------+-------------+-------------+\n"
')
        expect(provider.exists?).to be_truthy
      end
    end

    describe '#create' do
      it 'should create network' do
        provider.expects(:auth_nova).with("network-create", ['novanetwork', '--fixed-range-v4', '10.20.0.0/16'] )
                      .returns('"+--------------------------------------+-------------+-------------+\n| ID                                   | Label       | Cidr        |\n+--------------------------------------+-------------+-------------+\n| 703edc62-36ab-4c41-9d73-88sdfsdfsdfsd | nova-network | 10.20.0.0/16 |\n+--------------------------------------+-------------+-------------+\n"
')
        provider.create
      end
    end

    describe '#destroy' do
      it 'should destroy network' do
        resource[:ensure] = :absent
        provider.expects(:auth_nova).with("network-delete", "10.20.0.0/16")
                      .returns('"+--------------------------------------+-------------+-------------+\n| ID                                   | Label       | Cidr        |\n+--------------------------------------+-------------+-------------+\n
')
        provider.destroy
      end
    end
  end

  it_behaves_like('nova_network')
end
