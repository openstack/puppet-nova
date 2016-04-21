require 'puppet'
require 'spec_helper'
require 'puppet/provider/nova_service/openstack'

provider_class = Puppet::Type.type(:nova_service).provider(:openstack)

describe provider_class do

  shared_examples 'authenticated with environment variables' do
    ENV['OS_USERNAME']     = 'test'
    ENV['OS_PASSWORD']     = 'abc123'
    ENV['OS_PROJECT_NAME'] = 'test'
    ENV['OS_AUTH_URL']     = 'http://127.0.0.1:35357/v3'
  end

  describe 'managing nova services' do

    let(:service_attrs) do
      {
         :name              => 'myhost',
         :ensure            => 'present',
         :service_name      => ['waffles'],
         #:ids               => ['1']
      }
    end

    let(:service_attrs_without_name) do
      {
         :name              => 'myhost',
         :ensure            => 'absent',
      }
    end

    let(:resource) do
      Puppet::Type::Nova_service.new(service_attrs)
    end

    let(:provider) do
      provider_class.new(resource)
    end

    it_behaves_like 'authenticated with environment variables' do
      describe '#instances' do
        it 'finds existing services' do
          provider_class.expects(:openstack)
            .with('compute service', 'list', '--quiet', '--format', 'csv', [])
            .returns('"Id","Binary","Host","Zone","Status","State","Updated At"
"1","waffles","myhost","internal","enabled","down","2016-01-01T12:00:00.000000"')

          instances = provider_class.instances
          expect(instances.count).to eq(1)
        end
      end

      describe '#destroy' do

        it 'destroys a service' do
          provider.class.stubs(:openstack)
                        .with('compute service', 'delete', [])
          provider.destroy
          expect(provider.exists?).to be_falsey
        end
      end

    end
  end
end
