Puppet::Type.type(:nova_api_uwsgi_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/nova/nova-api-uwsgi.ini'
  end

end
