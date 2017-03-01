require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/nova')
require 'uri'

Puppet::Type.type(:nova_cell_v2).provide(
  :nova_manage,
  :parent => Puppet::Provider::Nova
) do

  desc "Manage nova cellv2 cells"

  optional_commands :nova_manage => 'nova-manage'

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    cells_list = nova_manage("cell_v2", "list_cells", "--verbose")

    cells_list.split("\n")[3..-2].collect do |cell|
      $name, $uuid, $transport_url, $database_connection = cell.split('|')[1..-1].map{ |x| x.strip}
      default_transport_url = defaults(is_cell0($uuid))[:transport_url]
      default_database_connection = defaults(is_cell0($uuid))[:database_connection]

      if $transport_url == default_transport_url
        $transport_url = 'default'
      end
      if $database_connection == default_database_connection
        $database_connection = 'default'
      end
      new(
        :name => $name,
        :uuid => $uuid,
        :transport_url => $transport_url,
        :database_connection => $database_connection,
        :ensure => :present
      )
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  @cell0_uuid = '00000000-0000-0000-0000-000000000000'

  def self.is_cell0(uuid)
    uuid == @cell0_uuid
  end

  def self.defaults(cell0=false)
    conf = nova_conf
    if cell0
      database_uri = URI.parse(conf['database']['connection'].strip)
      database_uri.path += '_cell0'
      {
        :transport_url => 'none:///',
        :database_connection => database_uri.to_s
      }
    else
      {
        :transport_url => conf['DEFAULT']['transport_url'].strip,
        :database_connection => conf['database']['connection'].strip,
      }
    end
  end

  def is_cell0?
    self.class.is_cell0(@property_hash[:uuid])
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    optional_opts = []
    unless resource[:name] == 'None'
      optional_opts.push('--name').push(resource[:name])
    end
    {
      :transport_url       => '--transport-url',
      :database_connection => '--database_connection'
    }.each do |param, opt|
      if resource[param] and resource[param] != 'default'
        optional_opts.push(opt).push(resource[param])
      end
    end
    cell_uuid = nova_manage('cell_v2', 'create_cell',
      optional_opts, "--verbose"
    )
    @property_hash = {
      :uuid => cell_uuid.strip(),
      :ensure => :present,
      :transport_url => resource[:transport_url],
      :database_connection => resource[:database_connection]
    }
  end

  def transport_url=(value)
    @property_flush[:transport_url] = value
  end

  def database_connection=(value)
    @property_flush[:database_connection] = value
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def flush
    @property_hash.update(@property_flush)
    if @property_flush[:ensure] == :absent
      nova_manage("cell_v2", "delete_cell", "--cell_uuid", @property_hash[:uuid])
    elsif @property_flush[:transport_url] or @property_flush[:database_connection]
      opts = []
      if not @property_flush[:transport_url]
        # Must pass this even when not changed or it will change to the value in nova.conf
        @property_flush[:transport_url] = @property_hash[:transport_url]
      end
      if @property_flush[:transport_url] == 'default'
        @property_flush[:transport_url] = self.class.defaults(is_cell0?)[:transport_url]
      end
      opts.push('--transport-url').push(@property_flush[:transport_url])

      if not @property_flush[:database_connection]
        # Must pass this even when not changed or it will change to the value in nova.conf
        @property_flush[:database_connection] = @property_hash[:database_connection]
      end
      if @property_flush[:database_connection] == 'default'
        @property_flush[:database_connection] = self.class.defaults(is_cell0?)[:database_connection]
      end
      opts.push('--database_connection').push(@property_flush[:database_connection])

      nova_manage("cell_v2", "update_cell", "--cell_uuid", @property_hash[:uuid], opts)
    end
    @property_flush = {}
  end
end