Puppet::Type.type(:novajoin_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/novajoin/join.conf'
  end

end
