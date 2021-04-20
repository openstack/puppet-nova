Puppet::Type.type(:nova_api_metadata_uwsgi_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/nova/nova-api-metadata-uwsgi.ini'
  end

end
