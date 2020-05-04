Puppet::Type.type(:nova_paste_api_ini).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:nova_api_paste_ini).provider(:ini_setting)
) do

  def create
    super
    warning('nova_paste_api_ini is deprecated. Use nova_api_paste_ini')
  end
end
