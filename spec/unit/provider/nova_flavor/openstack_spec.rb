require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova_flavor/openstack'

describe Puppet::Type.type(:nova_flavor).provider(:openstack) do

  let(:set_env) do
    ENV['OS_USERNAME']     = 'test'
    ENV['OS_PASSWORD']     = 'abc123'
    ENV['OS_PROJECT_NAME'] = 'test'
    ENV['OS_AUTH_URL']     = 'http://127.0.0.1:5000/v3'
  end

  describe 'managing flavors' do
    let(:flavor_attrs) do
      {
        :name   => 'example',
        :id     => '1',
        :ram    => '512',
        :disk   => '1',
        :vcpus  => '1',
        :ensure => 'present',
      }
    end

    let :resource do
      Puppet::Type::Nova_flavor.new(flavor_attrs)
    end

    let(:provider) do
      described_class.new(resource)
    end

    before(:each) do
      set_env
    end

    describe '#create' do
      context 'with defaults' do
        it 'creates flavor' do
          expect(provider.class).to receive(:openstack)
            .with('flavor', 'create', '--format', 'shell', ['example', '--public', '--id', '1', '--ram', '512', '--disk', '1', '--vcpus', '1'])
            .and_return('os-flv-disabled:disabled="False"
os-flv-ext-data:ephemeral="0"
disk="1"
id="1"
name="example"
os-flavor-access:is_public="True"
ram="512"
rxtx_factor="1.0"
swap=""
vcpus="1"')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end

      context 'with project' do
        before do
          flavor_attrs.merge!(
            :project => '3073e17b-fb7f-4524-bdcd-c54bc70e9da9'
          )
        end

        it 'creates flavor' do
          expect(provider.class).to receive(:openstack)
            .with('flavor', 'create', '--format', 'shell', ['example', '--public', '--id', '1', '--ram', '512', '--disk', '1', '--vcpus', '1'])
            .and_return('os-flv-disabled:disabled="False"
os-flv-ext-data:ephemeral="0"
disk="1"
id="1"
name="example"
os-flavor-access:is_public="True"
ram="512"
rxtx_factor="1.0"
swap=""
vcpus="1"')
          expect(provider.class).to receive(:openstack)
            .with('flavor', 'set', ['example', '--project', '3073e17b-fb7f-4524-bdcd-c54bc70e9da9'])
          expect(provider.class).to receive(:openstack)
            .with('project', 'show', '--format', 'shell', '3073e17b-fb7f-4524-bdcd-c54bc70e9da9')
            .and_return('enabled="True"
name="admin"
id="3073e17b-fb7f-4524-bdcd-c54bc70e9da9"
domain_id="domain_one_id"
')
          provider.create
          expect(provider.exists?).to be_truthy
          expect(provider.project).to eq('3073e17b-fb7f-4524-bdcd-c54bc70e9da9')
          expect(provider.project_name).to eq('admin')
        end
      end

      context 'with project_name' do
        before do
          flavor_attrs.merge!(
            :project_name => 'admin'
          )
        end

        it 'creates flavor with project_name' do
          expect(provider.class).to receive(:openstack)
            .with('flavor', 'create', '--format', 'shell', ['example', '--public', '--id', '1', '--ram', '512', '--disk', '1', '--vcpus', '1'])
            .and_return('os-flv-disabled:disabled="False"
os-flv-ext-data:ephemeral="0"
disk="1"
id="1"
name="example"
os-flavor-access:is_public="True"
ram="512"
rxtx_factor="1.0"
swap=""
vcpus="1"')
          expect(provider.class).to receive(:openstack)
            .with('flavor', 'set', ['example', '--project', 'admin'])
          expect(provider.class).to receive(:openstack)
            .with('project', 'show', '--format', 'shell', 'admin')
            .and_return('enabled="True"
name="admin"
id="3073e17b-fb7f-4524-bdcd-c54bc70e9da9"
domain_id="domain_one_id"
')
          provider.create
          expect(provider.exists?).to be_truthy
          expect(provider.project).to eq('3073e17b-fb7f-4524-bdcd-c54bc70e9da9')
          expect(provider.project_name).to eq('admin')
        end
      end
    end

    describe '#destroy' do
      it 'removes flavor' do
        expect(described_class).to receive(:openstack)
          .with('flavor', 'delete', '1')
        provider.instance_variable_set(:@property_hash, flavor_attrs)
        provider.destroy
        expect(provider.exists?).to be_falsey
      end
    end

    describe '#flush' do
      context '.project' do
        it 'updates flavor' do
          expect(provider.class).to receive(:openstack)
            .with('flavor', 'set', ['example', '--project', '3073e17b-fb7f-4524-bdcd-c54bc70e9da9'])
          provider.project = '3073e17b-fb7f-4524-bdcd-c54bc70e9da9'
          provider.flush
        end
      end

      context '.project_name' do
        it 'updates flavor' do
          expect(provider.class).to receive(:openstack)
            .with('flavor', 'set', ['example', '--project', 'admin'])
          provider.project_name = 'admin'
          provider.flush
        end
      end
    end
  end
end

