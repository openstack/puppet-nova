require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/nova')

Puppet::Type.type(:nova_network).provide(:nova, :parent => Puppet::Provider::Nova) do

  desc "Manage nova network"

  optional_commands :nova => 'nova'

  def create
    optional_opts = []
    {
      # this needs to be converted from a project name to an id
      :project          => '--project_id',
      :dns1             => '--dns1',
      :dns2             => '--dns2',
      :gateway          => '--gateway',
      :bridge           => '--bridge',
      :vlan_start       => '--vlan-start',
      :allowed_start    => '--allowed-start',
      :allowed_end      => '--allowed-end',
    }.each do |param, opt|
      if resource[param]
        optional_opts.push(opt).push(resource[param])
      end
    end

    opts = [resource[:label], "--fixed-range-v4", resource[:name]]

    auth_nova('network-create', opts + optional_opts)
  end

  def exists?
    instances = auth_nova('network-list')
    return instances.split('\n')[1..-1].detect do |n|
        n =~ /(\S+)\s+(#{resource[:network]})\s+(\S+)/
    end
  end

  def destroy
    auth_nova("network-delete", resource[:network])
  end

end
