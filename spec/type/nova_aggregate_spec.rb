# run with: rspec spec/type/nova_aggregate_spec.rb

require 'spec_helper'


describe Puppet::Type.type(:nova_aggregate) do
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
    described_class.new(:name => 'agg0').should_not be_nil
  end

  it "should be able to create an more complex instance" do
    described_class.new(:name => 'agg0',
                        :availability_zone => 'myzone',
                        :metadata => "a=b, c=d",
                        :hosts => "host1").should_not be_nil
  end

  it "should be able to create an more complex instance with multiple hosts" do
    described_class.new(:name => 'agg0',
                        :availability_zone => 'myzone',
                        :metadata => "a=b, c=d",
                        :hosts => "host1, host2").should_not be_nil
  end

  it "should be able to create a instance and have the default values" do
    c = described_class.new(:name => 'agg0')
    c[:name].should == "agg0"
    c[:availability_zone].should == nil
    c[:metadata].should == nil
    c[:hosts].should == nil
  end

  it "should return the given values" do
    c = described_class.new(:name => 'agg0',
                            :availability_zone => 'myzone',
                            :metadata => "  a  =  b  , c=  d  ",
                            :hosts => "  host1, host2    ")
    c[:name].should == "agg0"
    c[:availability_zone].should == "myzone"
    c[:metadata].should == {"a" => "b", "c" => "d"}
    c[:hosts].should == ["host1" , "host2"]
  end

  it "should return the given values" do
    c = described_class.new(:name => 'agg0',
                            :availability_zone => "",
                            :metadata => "",
                            :hosts => "")
    c[:name].should == "agg0"
    c[:availability_zone].should == ""
    c[:metadata].should == {}
    c[:hosts].should == []
  end

end
