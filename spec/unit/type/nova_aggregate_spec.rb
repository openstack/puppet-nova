require 'puppet'
require 'puppet/type/nova_aggregate'

describe Puppet::Type.type(:nova_aggregate) do

  before :each do
    Puppet::Type.rmtype(:nova_aggregate)
  end

  it 'should raise error for setting id property' do
    incorrect_input = {
      :name => 'test_type',
      :id   => 'some_id'
    }
    expect { Puppet::Type.type(:nova_aggregate).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /This is a read only property/)
  end

  it 'should raise error if wrong format of metadata' do
    incorrect_input = {
      :name     => 'new_aggr',
      :metadata => 'some_id,sd'
    }
    expect { Puppet::Type.type(:nova_aggregate).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /Key\/value pairs must be separated by an =/)
  end

  it 'should raise error if wrong type for availability zone' do
    incorrect_input = {
      :name => 'new_aggr',
      :availability_zone => {'zone'=>'23'},
    }
    expect { Puppet::Type.type(:nova_aggregate).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /availability zone must be a String/)
  end
end
