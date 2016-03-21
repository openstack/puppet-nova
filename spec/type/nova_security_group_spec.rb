# run with: rspec spec/type/nova_security_group_spec.rb

require 'spec_helper'


describe Puppet::Type.type(:nova_security_group) do
  before :each do
    @provider_class = described_class.provide(:simple) do
      mk_resource_methods
      def create; end
      def delete; end
      def exists?; get(:ensure) != :absent; end
      def flush; end
    end
  end

  it "should be able to create an instance" do
    expect(described_class.new(:name => 'scg0')).not_to be_nil
  end

  it "should be able to create a more complex instance" do
    expect(described_class.new(:name => 'scg0',
                        :description => "Security Group")).to_not be_nil
  end

  it "should be able to create a instance and have the default values" do
    c = described_class.new(:name => 'scg0')
    expect(c[:name]).to eq("scg0")
    expect(c[:description]).to eq('')
  end

  it "should return the given values" do
    c = described_class.new(:name => 'scg0',
                            :description => 'Security Group')
    expect(c[:name]).to eq("agg0")
    expect(c[:description]).to eq('Security Group')
  end
end
