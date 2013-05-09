Puppet::Type.newtype(:nova_config) do

  ensurable

  newparam(:name, :namevar => true) do
    validate do |value|
      unless value =~ /\S+\/\S+/
        fail("Invalid nova_config #{value}, entries without sections are no longer supported, please add an explicit section (probably DEFAULT) to all nova_config resources")
      end
    end
  end

  newproperty(:value) do
    munge do |value|
      value.to_s
    end
    newvalues(/^[\S ]*$/)
  end

  validate do
    if self[:ensure] == :present
      if self[:value].nil?
        raise Puppet::Error, "Property value must be set for #{self[:name]} when ensure is present"
      end
    end
  end

end
