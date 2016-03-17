require 'puppet'
require 'puppet/provider/nova_security_group/nova'
require 'tempfile'

provider_class = Puppet::Type.type(:nova_security_group).provider(:nova)

describe provider_class do

  let :secgroup_attrs do
    {
      :name => "scg0",
      :description => "Security Group",
    }
  end

  let :resource do
    Puppet::Type::Nova_security_group.new(secgroup_attrs)
  end

  let :provider do
    provider_class.new(resource)
  end

  shared_examples "nova_security_group" do
    describe "#exists?" do
      it 'should check non-existing security group' do
        output = <<-EOT
+--------------------------------------+---------+------------------------+
| Id                                   | Name    | Description            |
+--------------------------------------+---------+------------------------+
| f630dd92-3ff7-49bc-b012-b211451aa418 | default | Default security group |
+--------------------------------------+---------+------------------------+
EOT

        provider.expects(:auth_nova).with('secgroup-list').returns(output)

        expect(provider.exists?).to be_falsey
      end 

      it 'should check existing security group' do
        output = <<-EOT
+--------------------------------------+------+----------------+
| Id                                   | Name | Description    |
+--------------------------------------+------+----------------+
| f630dd92-3ff7-49bc-b012-b211451aa419 | scg0 | Security Group |
+--------------------------------------+------+----------------+
EOT

        provider.expects(:auth_nova).with('secgroup-list').returns(output)

        expect(provider.exists?).to be_truthy
      end
    end

    
    describe "#create" do
      it 'should create security group' do
        output = <<-EOT
+--------------------------------------+------+----------------+
| Id                                   | Name | Description    |
+--------------------------------------+------+----------------+
| f630dd92-3ff7-49bc-b012-b211451aa419 | scg0 | Security Group |
+--------------------------------------+------+----------------+
EOT

        provider.expects(:auth_nova).with('secgroup-create', 'scg0', 'Security Group').returns(output)

        expect(provider.create).to be_truthy
      end 
    end


    describe "#destroy" do
      it 'should destroy security group' do
        output = <<-EOT
+--------------------------------------+------+----------------+
| Id                                   | Name | Description    |
+--------------------------------------+------+----------------+
| f630dd92-3ff7-49bc-b012-b211451aa419 | scg0 | Security Group |
+--------------------------------------+------+----------------+
EOT

        provider.expects(:auth_nova).with('secgroup-delete', 'scg0').returns(output)

        expect(provider.destroy).to be_truthy
      end 
    end
  end

  it_behaves_like('nova_security_group')
end
