require 'puppet'
require 'puppet/type/nova_security_group'

describe 'Puppet::Type.type(:nova_security_group)' do

  it 'should reject invalid name value' do
    expect { Puppet::Type.type(:nova_security_group).new(:name => 65535) }.to raise_error(Puppet::Error, /name parameter must be a String/)
    expect { Puppet::Type.type(:nova_security_group).new(:name => 'sc g0') }.to raise_error(Puppet::Error, /is not a valid name/)
  end

  it 'should accept a valid name value' do
    Puppet::Type.type(:nova_security_group).new(:name => 'scg0')
  end

  it 'should accept description' do
    Puppet::Type.type(:nova_security_group).new(:name => 'scg0',
                                                :description => 'Security Group')
  end

end
