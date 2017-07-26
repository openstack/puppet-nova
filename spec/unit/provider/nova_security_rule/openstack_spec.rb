require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova_security_rule/openstack'

provider_class = Puppet::Type.type(:nova_security_rule).provider(:openstack)

describe provider_class do

  shared_examples 'authenticated with environment variables' do
    ENV['OS_USERNAME']     = 'test'
    ENV['OS_PASSWORD']     = 'abc123'
    ENV['OS_PROJECT_NAME'] = 'test'
    ENV['OS_AUTH_URL']     = 'http://127.0.0.1:35357/v3'
  end

  describe 'managing security group rules' do
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

    it_behaves_like 'authenticated with environment variables' do
      describe "#create" do
        it 'should create security group rule' do
          provider.class.stubs(:openstack)
                        .with('security group rule', 'create', ['scg0', '--protocol', 'tcp', '--dst-port', '22:23', '--src-ip', '0.0.0.0/0'])
                        .returns('id="021114fb-67e0-4882-b2ed-e7c5328d8aa8"
  protocol="tcp"
  port_range_max="22"
  port_range_min="23"
  remote_ip_prefix="0.0.0.0/0"
  security_group_id="4812fe3c-69d4-4b27-992b-163a20dc82d1"')
        end
      end

      describe '#destroy' do
        it 'removes security group rule' do
          provider_class.expects(:openstack)
            .with('security group rule', 'delete', 'scr0')
          provider.instance_variable_set(:@property_hash, secrule_attrs)
          provider.destroy
          expect(provider.exists?).to be_falsey
        end
      end
    end
  end
end
