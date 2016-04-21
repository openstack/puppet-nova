require 'puppet'
require 'puppet/type/nova_service'

describe Puppet::Type.type(:nova_service) do

  before :each do
    Puppet::Type.rmtype(:nova_service)
  end

  it 'should raise error for setting ids property' do
    incorrect_input = {
      :name => 'test_type',
      :ids  => 'some_id'
    }
    expect { Puppet::Type.type(:nova_service).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /This is a read only property/)
  end

  it 'should raise error if wrong format of name' do
    incorrect_input = {
      :name     => ['node-1','node-2'],
    }
    expect { Puppet::Type.type(:nova_service).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /name parameter must be a String/)
  end
end
