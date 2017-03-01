Puppet::Type.newtype(:nova_cell_v2) do
  ensurable

  newparam(:name, :namevar => true) do
    defaultto 'default'
  end

  newproperty(:uuid, :readonly => true) do
  end

  newproperty(:transport_url) do
    defaultto 'default'
  end

  newproperty(:database_connection) do
    defaultto 'default'
  end

end