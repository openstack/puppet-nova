require File.join(File.dirname(__FILE__), '..','..','..',
                  'puppet/provider/nova')

Puppet::Type.type(:nova_security_rule).provide(
  :nova,
  :parent => Puppet::Provider::Nova
) do

  desc "Manage nova security rules"

  commands :nova => 'nova'

  mk_resource_methods

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    args = Array.new

    args << "#{@resource[:security_group]}"
    args << "#{@resource[:ip_protocol]}"
    args << "#{@resource[:from_port]}"
    args << "#{@resource[:to_port]}"
    if not @resource[:ip_range].nil?
      args << "#{@resource[:ip_range]}"
    else
      args << "#{@resource[:source_group]}"
    end

    auth_nova("secgroup-delete-rule", args)
    @property_hash[:ensure] = :absent
  end

  def create
    args = Array.new

    args << "#{@resource[:security_group]}"
    args << "#{@resource[:ip_protocol]}"
    args << "#{@resource[:from_port]}"
    args << "#{@resource[:to_port]}"
    if not @resource[:ip_range].nil?
      args << "#{@resource[:ip_range]}"
    else
      args << "#{@resource[:source_group]}"
    end

    result = auth_nova("secgroup-add-rule", args)
  end
end
