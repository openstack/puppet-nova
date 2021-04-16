Puppet::Type.type(:nova_api_metadata_uwsgi_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/nova/nova-api-metadata-uwsgi.ini'
  end

end
