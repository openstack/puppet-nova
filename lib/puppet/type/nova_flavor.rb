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
require 'puppet'

Puppet::Type.newtype(:nova_flavor) do

  @doc = "Manage creation of nova flavors."

  ensurable

  autorequire(:nova_config) do
    ['auth_uri', 'project_name', 'username', 'password']
  end

  # Require the nova-api service to be running
  autorequire(:service) do
    ['nova-api']
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

  newparam(:id) do
    desc 'Unique ID (integer or UUID) for the flavor.'
  end

  newparam(:ram) do
    desc 'Amount of RAM to use (in megabytes).'
  end

  newparam(:disk) do
    desc 'Amount of disk space (in gigabytes) to use for the root (/) partition.'
  end

  newparam(:vcpus) do
    desc 'Number of virtual CPUs to use.'
  end

  newparam(:ephemeral) do
    desc 'Amount of disk space (in gigabytes) to use for the ephemeral partition.'
  end

  newparam(:swap) do
    desc 'Amount of swap space (in megabytes) to use.'
  end

  newparam(:rxtx_factor) do
    desc 'The slice of bandiwdth that the instances with this flavor can use (through the Virtual Interface (vif) creation in the hypervisor)'
  end

  newparam(:is_public) do
    desc "Whether the image is public or not. Default true"
    newvalues(/(y|Y)es/, /(n|N)o/, /(t|T)rue/, /(f|F)alse/, true, false)
    defaultto(true)
    munge do |v|
      if v =~ /^(y|Y)es$/
        :true
      elsif v =~ /^(n|N)o$/
        :false
      else
        v.to_s.downcase.to_sym
      end
    end
  end

  newproperty(:properties) do
    desc "The set of flavor properties"

    munge do |value|
      return value if value.is_a? Hash

      # wrap property value in commas
      value.gsub!(/=(\w+)/, '=\'\1\'')
      Hash[value.scan(/(\S+)='([^']*)'/)]
    end

    validate do |value|
      return true if value.is_a? Hash

      value.split(',').each do |property|
        raise ArgumentError, "Key/value pairs should be separated by an =" unless property.include?('=')
      end
    end
  end

  validate do
    unless self[:name]
      raise(ArgumentError, 'Name must be set')
    end
  end

end

