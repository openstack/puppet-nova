# run with: rspec spec/type/nova_service_spec.rb

require 'spec_helper'


describe Puppet::Type.type(:nova_service) do
  before :each do
    @provider_class = described_class.provide(:simple) do
      mk_resource_methods
      def create; end
      def delete; end
      def exists?; get(:ensure) != :absent; end
      def flush; end
      def self.instances; []; end
    end
  end

  it "should be able to create an instance" do
    expect(described_class.new(:name => 'nova1')).not_to be_nil
  end

  it "should return the given values" do
    c = described_class.new(:name => 'nova1',
                            :service_name => 'nova-scheduler')
    expect(c[:name]).to eq("nova1")
    expect(c[:service_name]).to eq('nova-scheduler')
  end

end
