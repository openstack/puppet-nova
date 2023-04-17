Puppet::Type.newtype(:virtlockd_config) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'setting name to manage from virtlockd.conf'
    newvalues(/\S+/)
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |value|
      if [true, false].include?(value)
        # NOTE(tkajinam): libvirt config file does not accept boolean values
        #                 and the value should be converted to 1/0.
        value = value ? '1' : '0'
      else
        value = value.to_s.strip
      end
      value
    end

    def is_to_s( currentvalue )
      if resource.secret?
        return '[old secret redacted]'
      else
        return currentvalue
      end
    end

    def should_to_s( newvalue )
      if resource.secret?
        return '[new secret redacted]'
      else
        return newvalue
      end
    end
  end

  newparam(:secret, :boolean => true) do
    desc 'Whether to hide the value from Puppet logs. Defaults to `false`.'

    newvalues(:true, :false)

    defaultto false
  end

  newparam(:quote, :boolean => true) do
    desc 'Whether to quote the value. Defauls to `false`.'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:ensure_absent_val) do
    desc 'A value that is specified as the value property will behave as if ensure => absent was specified'
    defaultto('<SERVICE DEFAULT>')
  end

  autorequire(:anchor) do
    ['nova::install::end']
  end

end
