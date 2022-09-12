Puppet::Type.type(:virtproxyd_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:libvirtd_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/libvirt/virtproxyd.conf'
  end

end

