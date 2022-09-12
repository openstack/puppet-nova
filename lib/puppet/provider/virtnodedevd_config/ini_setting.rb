Puppet::Type.type(:virtnodedevd_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:libvirtd_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/libvirt/virtnodedevd.conf'
  end

end

