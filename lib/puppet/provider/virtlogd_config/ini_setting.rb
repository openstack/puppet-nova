Puppet::Type.type(:virtlogd_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  def exists?
    if resource[:value] == ensure_absent_val
      resource[:ensure] = :absent
    elsif resource[:quote]
      unless resource[:value].start_with?('"')
        resource[:value] = '"' + resource[:value] + '"'
      end
    end
    super
  end

  def section
    ''
  end

  def setting
    resource[:name]
  end

  def separator
    '='
  end

  def ensure_absent_val
    resource[:ensure_absent_val]
  end

  def self.file_path
    '/etc/libvirt/virtlogd.conf'
  end

end
