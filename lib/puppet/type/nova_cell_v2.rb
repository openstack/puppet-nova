require 'uri/generic'

def sanitize_uri(sensitive_uri)
  begin
    uri = URI.parse(sensitive_uri)
  rescue URI::InvalidURIError
    return '<Invalid URI>'
  end

  sanitized_userinfo = nil
  unless uri.userinfo.nil?
    user, password = uri.userinfo.split(':', 2)
    unless user.nil?
      sanitized_userinfo = user
      unless password.nil?
        sanitized_userinfo << ':****'
      end
    end
  end
  return URI::Generic.new(
    uri.scheme,
    sanitized_userinfo,
    uri.host,
    uri.port,
    uri.registry,
    uri.path,
    uri.opaque,
    uri.query,
    uri.fragment
  ).to_s
end

Puppet::Type.newtype(:nova_cell_v2) do
  ensurable

  newparam(:name, :namevar => true) do
    defaultto 'default'
  end

  newproperty(:uuid, :readonly => true) do
  end

  newproperty(:transport_url) do
    defaultto 'default'

    def is_to_s( currentvalue )
      if currentvalue == 'default'
        return currentvalue
      else
        return sanitize_uri(currentvalue)
      end
    end

    def should_to_s( newvalue )
      if newvalue == 'default'
        return newvalue
      else
        return sanitize_uri(newvalue)
      end
    end

  end

  newproperty(:database_connection) do
    defaultto 'default'

    def is_to_s( currentvalue )
      if currentvalue == 'default'
        return currentvalue
      else
        return sanitize_uri(currentvalue)
      end
    end

    def should_to_s( newvalue )
      if newvalue == 'default'
        return newvalue
      else
        return sanitize_uri(newvalue)
      end
    end

  end

end