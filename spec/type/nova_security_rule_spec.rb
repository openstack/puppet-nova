# run with: rspec spec/type/nova_security_rule_spec.rb

require 'spec_helper'


describe Puppet::Type.type(:nova_security_rule) do
  before :each do
    @provider_class = described_class.provide(:simple) do
      mk_resource_methods
      def create; end
      def delete; end
      def exists?; get(:ensure) != :absent; end
      def flush; end
    end
  end

  it "should be able to create an instance with ip range" do
    expect(described_class.new(:name => 'scr0',
                               :ip_protocol => 'tcp',
                               :from_port => 22,
                               :to_port => 23, 
                               :ip_range => "0.0.0.0/0",
                               :security_group => "scg0")).not_to be_nil
  end

  it "should be able to create an instance with source group" do
    expect(described_class.new(:name => 'scr0',
                               :ip_protocol => 'tcp',
                               :from_port => 22,
                               :to_port => 23, 
                               :source_group => "tenant",
                               :security_group => "scg0")).not_to be_nil
  end

end
