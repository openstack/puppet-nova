Puppet::Type.type(:virtlockd_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:libvirtd_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/libvirt/virtlockd.conf'
  end

end
