require 'puppet'
require 'puppet/type/nova_security_group'
describe 'Puppet::Type.type(:nova_security_group)' do

  it 'should reject an invalid ipv4 CIDR value' do
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '22',
                                                        :to_port => '22',
                                                        :ip_range => '192.168.1.0',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /Incorrect ip_range!/)
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '22',
                                                        :to_port => '22',
                                                        :ip_range => '::1/24',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /Incorrect ip_range!/)
  end

  it 'should reject an invalid from port value' do
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '-22',
                                                        :to_port => '22',
                                                        :ip_range => '192.168.1.0/24',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /Incorrect from port!/)
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :to_port => '22',
                                                        :ip_range => '192.168.1.0/24',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /You should give the source port/)
  end

  it 'should reject an invalid from port value' do
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '22',
                                                        :to_port => '-22',
                                                        :ip_range => '192.168.1.0/24',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /Incorrect to port!/)
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '22',
                                                        :ip_range => '192.168.1.0/24',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /You should give the destination port/)
  end

  it 'should fails with security group not specified' do
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '22',
                                                        :to_port => '22',
                                                        :ip_range => '192.168.1.0/24') }.to raise_error(Puppet::Error, /You should provide the security group/)
  end

  it 'should fails with none of ip_range and source_group specified' do
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '22',
                                                        :to_port => '22',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /You should give either ip_range or source_group/)
  end
  
  it 'should fails with both ip_range and source group specified' do
    expect { Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                                        :ip_protocol => 'tcp',
                                                        :from_port => '22',
                                                        :to_port => '22',
                                                        :ip_range => '192.168.1.0/24',
                                                        :source_group => 'tenant',
                                                        :security_group => 'scg0') }.to raise_error(Puppet::Error, /You should give either ip_range or source_group/)
  end


  it 'should accept a valid parameters' do
    Puppet::Type.type(:nova_security_rule).new(:name => 'scr0',
                                               :ip_protocol => 'tcp',
                                               :from_port => '22',
                                               :to_port => '22',
                                               :ip_range => '192.168.1.0/24',
                                               :security_group => 'scg0')
  end
end
