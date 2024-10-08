require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova_aggregate/openstack'

describe Puppet::Type.type(:nova_aggregate).provider(:openstack) do

  let(:set_env) do
    ENV['OS_USERNAME']     = 'test'
    ENV['OS_PASSWORD']     = 'abc123'
    ENV['OS_PROJECT_NAME'] = 'test'
    ENV['OS_AUTH_URL']     = 'http://127.0.0.1:5000/v3'
  end

  describe 'managing aggregates' do

    let(:aggregate_attrs) do
      {
         :name              => 'just',
         :availability_zone => 'simple',
         :hosts             => ['example'],
         :ensure            => 'present',
         :metadata          => 'nice=cookie',
      }
    end

    let(:resource) do
      Puppet::Type::Nova_aggregate.new(aggregate_attrs)
    end

    let(:provider) do
      described_class.new(resource)
    end

    before(:each) do
      set_env
    end

    describe '#instances' do
      it 'finds existing aggregates' do
        expect(described_class).to receive(:openstack)
          .with('aggregate', 'list', '--quiet', '--format', 'csv', [])
          .and_return('"ID","Name","Availability Zone"
just,"simple","just"
')
        expect(described_class).to receive(:openstack)
          .with('aggregate', 'show', '--format', 'shell', 'simple')
          .and_return('"id="just"
name="simple"
availability_zone=just"
properties="{\'key1\': \'tomato\', \'key2\':\'mushroom\'}"
hosts="[]"
')
        instances = described_class.instances
        expect(instances.count).to eq(1)
        expect(instances[0].name).to eq('simple')
        expect(instances[0].metadata).to eq({"key1"=>"tomato", "key2"=>"mushroom"})
      end
    end

    describe '#create' do
      it 'creates aggregate' do
        expect(described_class).to receive(:openstack)
          .with('aggregate', 'create', '--format', 'shell',
                ['just', '--zone', 'simple', '--property', 'nice=cookie' ])
          .and_return('name="just"
id="just"
availability_zone="simple"
properties="{\'nice\': \'cookie\'}"
hosts="[]"
')
        expect(described_class).to receive(:openstack)
          .with('aggregate', 'add host', ['just', 'example'])
          .and_return('name="just"
id="just"
availability_zone="simple"
properties="{\'nice\': \'cookie\'}"
hosts="[\'example\']"
')

        provider.create
        expect(provider.exists?).to be_truthy
      end
    end

    describe '#destroy' do
      it 'removes aggregate with hosts' do
        expect(described_class).to receive(:openstack)
          .with('aggregate', 'remove host', ['just', 'example'])
        expect(described_class).to receive(:openstack)
          .with('aggregate', 'delete', 'just')
        provider.instance_variable_set(:@property_hash, aggregate_attrs)
        provider.destroy
        expect(provider.exists?).to be_falsey
      end
    end

    describe '#pythondict2hash' do
      it 'should return a hash with key-value when provided with a unicode python dict' do
        s = "{'key': 'value', 'key2': 'value2'}"
        expect(described_class.pythondict2hash(s)).to eq({"key"=>"value", "key2"=>"value2"})
      end

      it 'should return a hash with key-value when provided with a python dict' do
        s = "{'key': 'value', 'key2': 'value2'}"
        expect(described_class.pythondict2hash(s)).to eq({"key"=>"value", "key2"=>"value2"})
      end
    end
  end


  describe 'managing aggregates with filter_hosts toggled' do

    # instantiation attributes for the provider with filter_hosts set.
    let(:aggregate_attrs) do
      {
         :name              => 'just',
         :availability_zone => 'simple',
         :hosts             => ['known'],
         :ensure            => 'present',
         :metadata          => 'nice=cookie',
         :filter_hosts      => 'true'
      }
    end

    let(:resource) do
      Puppet::Type::Nova_aggregate.new(aggregate_attrs)
    end

    let(:provider) do
      described_class.new(resource)
    end

    before(:each) do
      set_env
    end

    # create an aggregate and actually aggregate hosts to it
    describe 'create aggregate and add/remove hosts with filter_hosts toggled' do

      it 'creates aggregate with filter_hosts toggled' do

        allow(provider.class).to receive(:get_known_hosts)
          .and_return(['known', 'known_too'])

        # these expectations are the actual tests that check the provider's behaviour
        # and make sure only known hosts ('known' is the only known host) will be
        # aggregated.

        expect(described_class).to receive(:openstack)
          .with('aggregate', 'create', '--format', 'shell', ['just', '--zone', 'simple', "--property", "nice=cookie"])
          .once
          .and_return('name="just"
id="just"
availability_zone="simple"
properties="{\'nice\': \'cookie\'}"
hosts="[]"
')

        expect(described_class).to receive(:openstack)
          .with('aggregate', 'add host', ['just', 'known'])
          .once
          .and_return('name="just"
id="just"
availability_zone="simple"
properties="{\'nice\': \'cookie\'}"
hosts="[\'known\']"
')

        expect(described_class).to receive(:openstack)
          .with('aggregate', 'add host', ['just', 'known_too'])
          .once
          .and_return('name="just"
id="just"
availability_zone="simple"
properties="{\'nice\': \'cookie\'}"
hosts="[\'known\', \'known_too\']"
')

        expect(described_class).to receive(:openstack)
          .with('aggregate', 'remove host', ['just', 'known'])
          .once
          .and_return('name="just"
id="just"
availability_zone="simple"
properties="{\'nice\': \'cookie\'}"
hosts="[\'known_too\']"
')

        # this creates a provider with the attributes defined above as 'aggregate_attrs'
        # and tries to add some hosts and then to remove some hosts.
        # the hosts will be filtered against known active hosts and the expectations
        # described above are the actual tests that check the provider's behaviour

        provider.create
        property_hash = provider.instance_variable_get(:@property_hash)
        property_hash[:hosts] = ['known']
        provider.instance_variable_set(:@property_hash, property_hash)

        provider.hosts = ['known', 'known_too', 'unknown']
        property_hash = provider.instance_variable_get(:@property_hash)
        property_hash[:hosts] = ['known', 'known_too']
        provider.instance_variable_set(:@property_hash, property_hash)

        provider.hosts = ['known_too']

      end
    end
  end

end
