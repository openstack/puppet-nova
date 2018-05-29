require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova_aggregate/openstack'

provider_class = Puppet::Type.type(:nova_aggregate).provider(:openstack)

describe provider_class do

  shared_examples 'authenticated with environment variables' do
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
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#instances' do
        it 'finds existing aggregates' do
          provider_class.expects(:openstack)
            .with('aggregate', 'list', '--quiet', '--format', 'csv', [])
            .returns('"ID","Name","Availability Zone"
just,"simple","just"
')
          provider_class.expects(:openstack)
            .with('aggregate', 'show', '--format', 'shell', 'simple')
            .returns('"id="just"
name="simple"
availability_zone=just"
properties="key=\'2value\'"
hosts="[]"
')
          instances = provider_class.instances
          expect(instances.count).to eq(1)
          expect(instances[0].name).to eq('simple')
        end
      end

      describe '#create' do
        it 'creates aggregate' do
          provider.class.stubs(:openstack)
                        .with('aggregate', 'list', '--quiet', '--format', 'csv', '--long')
                        .returns('"ID","Name","Availability Zone","Properties"
')
          provider.class.stubs(:openstack)
                  .with('aggregate', 'create', '--format', 'shell', ['just', '--zone', 'simple', '--property', 'nice=cookie' ])
                  .returns('name="just"
id="just"
availability_zone="simple"
properties="{u\'nice\': u\'cookie\'}"
hosts="[]"
')
          provider.class.stubs(:openstack)
                  .with('aggregate', 'add host', ['just', 'example'])
                  .returns('name="just"
id="just"
availability_zone="simple"
properties="{u\'nice\': u\'cookie\'}"
hosts="[u\'example\']"
')
          provider.exists?
          provider.create
          expect(provider.exists?).to be_falsey
        end
      end

      describe '#destroy' do
        it 'removes aggregate with hosts' do
          provider_class.expects(:openstack)
            .with('aggregate', 'remove host', ['just', 'example'])
          provider_class.expects(:openstack)
            .with('aggregate', 'delete', 'just')
          provider.instance_variable_set(:@property_hash, aggregate_attrs)
          provider.destroy
          expect(provider.exists?).to be_falsey
        end
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
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do

      # create an aggregate and actually aggregate hosts to it
      describe 'create aggregate and add/remove hosts with filter_hosts toggled' do

        it 'creates aggregate with filter_hosts toggled' do

          provider.class.stubs(:get_known_hosts)
            .returns(['known', 'known_too'])

          # these expectations are the actual tests that check the provider's behaviour
          # and make sure only known hosts ('known' is the only known host) will be
          # aggregated.

          provider_class.expects(:openstack)
            .with('aggregate', 'create', '--format', 'shell', ['just', '--zone', 'simple', "--property", "nice=cookie"])
            .once
            .returns('name="just"
id="just"
availability_zone="simple"
properties="{u\'nice\': u\'cookie\'}"
hosts="[]"
')

          provider_class.expects(:openstack)
            .with('aggregate', 'add host', ['just', 'known'])
            .once
            .returns('name="just"
id="just"
availability_zone="simple"
properties="{u\'nice\': u\'cookie\'}"
hosts="[u\'known\']"
')

          provider_class.expects(:openstack)
            .with('aggregate', 'add host', ['just', 'known_too'])
            .once
            .returns('name="just"
id="just"
availability_zone="simple"
properties="{u\'nice\': u\'cookie\'}"
hosts="[u\'known\', u\'known_too\']"
')

          provider_class.expects(:openstack)
            .with('aggregate', 'remove host', ['just', 'known'])
            .once
            .returns('name="just"
id="just"
availability_zone="simple"
properties="{u\'nice\': u\'cookie\'}"
hosts="[u\'known_too\']"
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

end
