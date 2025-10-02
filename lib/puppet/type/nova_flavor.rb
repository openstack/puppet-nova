# nova_flavor type
#
# == Parameters
#  [*name*]
#    Name for the flavor
#    Required
#
#  [*id*]
#    Unique ID (integer or UUID) for the flavor.
#    Optional
#
#  [*ram*]
#    Amount of RAM to use (in megabytes).
#    Optional
#
#  [*disk*]
#    Amount of disk space (in gigabytes) to use for the root (/) partition.
#    Optional
#
#  [*vcpus*]
#    Number of virtual CPUs to use.
#    Optional
#
#  [*ephemeral*]
#    Amount of disk space (in gigabytes) to use for the ephemeral partition.
#    Optional
#
#  [*swap*]
#    Amount of swap space (in megabytes) to use.
#    Optional
#
#  [*rxtx_factor*]
#    The slice of bandwidth that the instances with this flavor can use
#    (through the Virtual Interface (vif) creation in the hypervisor)
#    Optional
#
#  [*is_public*]
#    A boolean to indicate visibility
#    Optional
#
#  [*properties*]
#    A key => value hash used to set the properties for the flavor. This is
#    the only parameter that can be updated after the creation of the flavor.
#    Optional
#
#  [*project*]
#    Set flavor access to project (ID).
#    If you set this option, take care to set is_public to false.
#    Optional
#
#  [*project_name*]
#    Set flavor access to project (name).
#    If you set this option, take care to set is_public to false.
#    Optional
#
require 'puppet'

Puppet::Type.newtype(:nova_flavor) do

  @doc = "Manage creation of nova flavors."

  ensurable

  # Require the nova-api service to be running
  autorequire(:anchor) do
    ['nova::service::end']
  end

  autorequire(:keystone_tenant) do
    [self[:project_name]] if (self[:project_name] and self[:project_name] != '')
  end

  newparam(:name, :namevar => true) do
    desc 'Name for the flavor'
    validate do |value|
      if not value.is_a? String
        raise ArgumentError, "name parameter must be a String"
      end
      unless value =~ /^[a-zA-Z0-9\-\._]+$/
        raise ArgumentError, "#{value} is not a valid name"
      end
    end
  end

  newproperty(:id) do
    desc 'Unique ID (integer or UUID) for the flavor.'
  end

  newproperty(:ram) do
    desc 'Amount of RAM to use (in megabytes).'
  end

  newproperty(:disk) do
    desc 'Amount of disk space (in gigabytes) to use for the root (/) partition.'
  end

  newproperty(:vcpus) do
    desc 'Number of virtual CPUs to use.'
  end

  newproperty(:ephemeral) do
    desc 'Amount of disk space (in gigabytes) to use for the ephemeral partition.'
  end

  newproperty(:swap) do
    desc 'Amount of swap space (in megabytes) to use.'
  end

  newproperty(:rxtx_factor) do
    desc 'The slice of bandwidth that the instances with this flavor can use (through the Virtual Interface (vif) creation in the hypervisor)'
  end

  newproperty(:is_public) do
    desc "Whether the flavor is public or not. Default true"
    newvalues(/(y|Y)es/, /(n|N)o/, /(t|T)rue/, /(f|F)alse/, true, false)
    defaultto(true)
    munge do |v|
      if v.is_a?(String)
        if v =~ /^(y|Y)es$/
          :true
        elsif v =~ /^(n|N)o$/
          :false
        else
          v.to_s.downcase.to_sym
        end
      else
        v.to_s.downcase.to_sym
      end
    end
  end

  newproperty(:project) do
    desc 'Set flavor access to project (ID).'
  end

  newproperty(:project_name) do
    desc 'Set flavor access to project (Name).'
  end

  newproperty(:properties) do
    desc "The set of flavor properties"

    validate do |value|
      if value.is_a?(Hash)
        return true
      else
        raise ArgumentError, "Invalid properties #{value}. Requires a Hash, not a #{value.class}"
      end
    end
  end

  validate do
    unless self[:name]
      raise(ArgumentError, 'Name must be set')
    end

    if self[:project] && self[:project_name]
      raise(Puppet::Error, <<-EOT
Please provide a value for only one of project_name and project.
EOT
      )
    end
  end

end
