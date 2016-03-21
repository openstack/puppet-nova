require 'puppet'
require 'puppet/provider/nova_security_rule/nova'
require 'tempfile'

provider_class = Puppet::Type.type(:nova_security_rule).provider(:nova)

describe provider_class do

  let :secrule_attrs do
    {
      :name => "scr0",
      :ip_protocol => "tcp",
      :from_port => '22',
      :to_port => '23',
      :ip_range => '0.0.0.0/0',
      :security_group => 'scg0'
    }
  end

  let :resource do
    Puppet::Type::Nova_security_rule.new(secrule_attrs)
  end

  let :provider do
    provider_class.new(resource)
  end

  shared_examples "nova_security_rule" do
    describe "#create" do
      it 'should create security rule' do
        provider.expects(:auth_nova).with('secgroup-add-rule', ['scg0', 'tcp', '22', '23', '0.0.0.0/0']).returns('+-------------+-----------+---------+-----------+--------------+\n| IP Protocol | From Port | To Port | IP Range  | Source Group |\n+-------------+-----------+---------+-----------+--------------+\n| tcp         | 22        | 23      | 0.0.0.0/0 |              |\n+-------------+-----------+---------+-----------+--------------+')

        provider.create
      end 
    end


    describe "#destroy" do
      it 'should destroy security rule' do
        provider.expects(:auth_nova).with('secgroup-delete-rule', ['scg0', 'tcp', '22', '23', '0.0.0.0/0']).returns('+-------------+-----------+---------+-----------+--------------+\n| IP Protocol | From Port | To Port | IP Range  | Source Group |\n+-------------+-----------+---------+-----------+--------------+\n| tcp         | 22        | 23      | 0.0.0.0/0 |              |\n+-------------+-----------+---------+-----------+--------------+')

        provider.destroy
      end 
    end
  end

  it_behaves_like('nova_security_rule')
end
