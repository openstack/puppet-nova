Puppet::Type.newtype(:nova_floating) do

  @doc = "Manage creation/deletion of nova floating ip ranges. "

  ensurable

  newparam(:network, :namevar => true) do
    desc "It can contain network (ie, 192.168.1.0/24 or 192.168.1.128/25 etc.),
          ip range ('192.168.1.1-192.168.1.55' or list of ip ranges ['192.168.1.1-192.168.1.25', '192.168.1.30-192.168.1.55'])"
    newvalues(/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ || ^(\d{1,3}\.){3}\d{1,3}-(\d{1,3}\.){3}\d{1,3}$/)
  end

  newparam(:pool) do
    desc "Floating IP pool name. Default: 'nova'"
    defaultto :nova
    newvalues(/^.{1,255}$/)
  end

end
