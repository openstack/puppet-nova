require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova_flavor/openstack'

provider_class = Puppet::Type.type(:nova_security_group).provider(:openstack)

describe provider_class do

  describe 'managing security groups' do
    let(:secgroup_attrs) do
      {
        :name => "scg0",
        :description => "Security Group",
      }
    end

    let :resource do
      Puppet::Type::Nova_security_group.new(secgroup_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    describe "#create" do
      it 'should create security group' do
        provider.class.stubs(:openstack)
                      .with('security group', 'list', ['--all'])
                      .returns('"ID", "Name", "Description", "Project"')
        provider.class.stubs(:openstack)
                      .with('security group', 'create', ['scg0', '--description', 'Security Group'])
                      .returns('id="f630dd92-3ff7-49bc-b012-b211451aa419"
name="scg0"
description="Security Group"')
      end
    end

    describe '#destroy' do
      it 'removes flavor' do
        provider_class.expects(:openstack)
          .with('security group', 'delete', 'scg0')
        provider.instance_variable_set(:@property_hash, secgroup_attrs)
        provider.destroy
        expect(provider.exists?).to be_falsey
      end
    end
  end
end
