require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/nova')

Puppet::Type.type(:nova_aggregate).provide(
  :openstack,
  :parent => Puppet::Provider::Nova
) do
  desc <<-EOT
    Provider to manage nova aggregations
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  mk_resource_methods

  def self.instances
    request('aggregate', 'list').collect do |el|
      attrs = request('aggregate', 'show', el[:name])
      properties = parsestring(attrs[:properties]) rescue nil
      new(
          :ensure => :present,
          :name => attrs[:name],
          :id => attrs[:id],
          :availability_zone => attrs[:availability_zone],
          :metadata => properties,
          :hosts => string2list(attrs[:hosts]).sort,
          :filter_hosts => attrs[:filter_hosts]
      )
    end
  end

  def self.string2list(input)
    return input[1..-2].split(",").map { |x| x.match(/'(.*?)'/)[1] }
  end

  def self.prefetch(resources)
    instances_ = instances
    resources.keys.each do |name|
      if provider = instances_.find{ |instance| instance.name == name }
        resources[name].provider = provider
      end
    end
  end

  def self.get_known_hosts
    # get list of hosts known to be active from openstack
    return request('compute service', 'list', ['--service', 'nova-compute']).map{|el| el[:host]}
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_hash[:hosts].each do |h|
      properties = [@property_hash[:name], h]
      self.class.request('aggregate', 'remove host', properties)
    end
    self.class.request('aggregate', 'delete', @property_hash[:name])
  end

  def create
    properties = [@resource[:name]]
    if not @resource[:availability_zone].nil? and not @resource[:availability_zone].empty?
      properties << "--zone" << @resource[:availability_zone]
    end
    if not @resource[:metadata].nil? and not @resource[:metadata].empty?
      @resource[:metadata].each do |key, value|
        properties << "--property" << "#{key}=#{value}"
      end
    end
    @property_hash = self.class.request('aggregate', 'create', properties)
    if not @resource[:hosts].nil? and not @resource[:hosts].empty?
      # filter host list by known hosts if filter_hosts is set
      if @resource[:filter_hosts] == :true
        @resource[:hosts] = @resource[:hosts] & self.class.get_known_hosts()
      end
      @resource[:hosts].each do |host|
        properties = [@property_hash[:name], host]
        self.class.request('aggregate', 'add host', properties)
      end
    end
  end

  def availability_zone=(value)
    self.class.request('aggregate', 'set', [ @resource[:name], '--zone', @resource[:availability_zone] ])
  end

  def metadata=(value)
    # clear obsolete keys
    if @property_hash[:metadata].keys.length > 0
      properties = [@resource[:name] ]
      (@property_hash[:metadata].keys - @resource[:metadata].keys).each do |key|
        properties << "--property" << "#{key}"
      end
      self.class.request('aggregate', 'unset', properties)
    end
    properties = [@resource[:name] ]
    @resource[:metadata].each do |key, value|
      properties << "--property" << "#{key}=#{value}"
    end
    self.class.request('aggregate', 'set', properties)
  end

  def hosts=(value)
    # filter host list by known hosts if filter_hosts is set
    if @resource[:filter_hosts] == :true
      value &= self.class.get_known_hosts()
    end
    if not @property_hash[:hosts].nil?
      # remove hosts that are not present in update
      (@property_hash[:hosts] - value).each do |host|
        self.class.request('aggregate', 'remove host', [@property_hash[:id], host])
      end
      # add hosts that are not already present
      (value - @property_hash[:hosts]).each do |host|
        self.class.request('aggregate', 'add host', [@property_hash[:id], host])
      end
    end
  end

  def self.string2hash(input)
    return Hash[input.scan(/(\S+)='([^']*)'/)]
  end

  def self.pythondict2hash(input)
    return JSON.parse(input.gsub(/u'([^']*)'/, '"\1"').gsub(/'/, '"'))
  end

  def self.parsestring(input)
    if input[0] == '{'
      # 4.0.0+ output, python dict
      return self.pythondict2hash(input)
    else
      # Pre-4.0.0 output, key=value
      return self.string2hash(input)
    end
  end

end
