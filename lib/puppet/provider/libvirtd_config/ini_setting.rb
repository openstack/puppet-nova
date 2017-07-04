Puppet::Type.type(:libvirtd_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  def section
    ''
  end

  def setting
    resource[:name]
  end

  def separator
    '='
  end

  def self.file_path
    '/etc/libvirt/libvirtd.conf'
  end

  # this needs to be removed. This has been replaced with the class method
  def file_path
    self.class.file_path
  end

end
