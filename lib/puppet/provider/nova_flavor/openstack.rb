require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/nova')

Puppet::Type.type(:nova_flavor).provide(
  :openstack,
  :parent => Puppet::Provider::Nova
) do
  desc <<-EOT
     Manage Nova flavor
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  def initialize(value={})
    super(value)
    @property_flush = {}
    @project_flush = {}
  end

  def create
    opts = [@resource[:name]]
    opts << (@resource[:is_public] == :true ? '--public' : '--private')
    (opts << '--id' << @resource[:id]) if @resource[:id]
    (opts << '--ram' << @resource[:ram]) if @resource[:ram]
    (opts << '--disk' << @resource[:disk]) if @resource[:disk]
    (opts << '--ephemeral' << @resource[:ephemeral]) if @resource[:ephemeral]
    (opts << '--vcpus' << @resource[:vcpus]) if @resource[:vcpus]
    (opts << '--swap' << @resource[:swap]) if @resource[:swap]
    (opts << '--rxtx-factor' << @resource[:rxtx_factor]) if @resource[:rxtx_factor]
    @property_hash = self.class.request('flavor', 'create', opts)
    if @resource[:properties] and !(@resource[:properties].empty?)
      prop_opts = [@resource[:name]]
      prop_opts << props_to_s(@resource[:properties])
      self.class.request('flavor', 'set', prop_opts)
    end

    if @resource[:project] and @resource[:project] != ''
      proj_opts = [@resource[:name]]
      proj_opts << '--project' << @resource[:project]
      self.class.request('flavor', 'set', proj_opts)

      project = self.class.request('project', 'show', @resource[:project])
      @property_hash[:project_name] = project[:name]
      @property_hash[:project] = project[:id]

    elsif @resource[:project_name] and @resource[:project_name] != ''
      proj_opts = [@resource[:name]]
      proj_opts << '--project' << @resource[:project_name]
      self.class.request('flavor', 'set', proj_opts)

      project = self.class.request('project', 'show', @resource[:project_name])
      @property_hash[:project_name] = project[:name]
      @property_hash[:project] = project[:id]
    end

    @property_hash[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('flavor', 'delete', @property_hash[:id])
    @property_hash.clear
  end

  mk_resource_methods

  [
    :is_public,
    :id,
    :ram,
    :disk,
    :vcpus,
    :swap,
    :rtxt_factor,
  ].each do |attr|
    define_method(attr.to_s + "=") do |value|
      fail("{#attr.to_s} is read only")
    end
  end

  def properties=(value)
    @property_flush[:properties] = value
  end

  def project=(value)
    @project_flush[:project] = value
  end

  def project_name=(value)
    @project_flush[:project_name] = value
  end

  def self.instances
    request('flavor', 'list', ['--long', '--all']).collect do |attrs|
      project = request('flavor', 'show', [attrs[:id], '-c', 'access_project_ids'])

      access_project_ids = project[:access_project_ids]
      # Client can return None and this should be considered as ''
      if access_project_ids.downcase.chomp == 'none'
        project_id = nil
        project_name = nil
      else
        # TODO(tkajinam): We'd need to consider multiple projects can be returned
        project_value = parse_python_list(access_project_ids)[0]
        project = request('project', 'show', project_value)
        project_id = project[:id]
        project_name = project[:name]
      end

      properties = parse_python_dict(attrs[:properties])
      new(
        :ensure       => :present,
        :name         => attrs[:name],
        :id           => attrs[:id],
        :ram          => attrs[:ram],
        :disk         => attrs[:disk],
        :ephemeral    => attrs[:ephemeral],
        :vcpus        => attrs[:vcpus],
        :is_public    => attrs[:is_public].downcase.chomp == 'true'? true : false,
        :swap         => attrs[:swap],
        :rxtx_factor  => attrs[:rxtx_factor],
        :properties   => properties,
        :project      => project_id,
        :project_name => project_name,
      )
    end
  end

  def self.prefetch(resources)
    flavors = instances
    resources.keys.each do |name|
      if provider = flavors.find{ |flavor| flavor.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    unless @property_flush.empty?
      opts = [@resource[:name]]
      opts << props_to_s(@property_flush[:properties])

      self.class.request('flavor', 'set', opts)
      @property_flush.clear
    end

    unless @project_flush.empty?
      if @project_flush[:project]
        if @property_hash[:project] and @property_hash[:project] != ''
          opts = [@resource[:name], '--project', @property_hash[:project]]
          self.class.request('flavor', 'unset', opts)
        end
        if @project_flush[:project] != ''
          opts = [@resource[:name], '--project', @project_flush[:project]]
          self.class.request('flavor', 'set', opts)
        end
      elsif @project_flush[:project_name]
        if @property_hash[:project_name] and @property_hash[:project_name] != ''
          opts = [@resource[:name], '--project', @property_hash[:project_name]]
          self.class.request('flavor', 'unset', opts)
        end
        if @project_flush[:project_name] != ''
          opts = [@resource[:name], '--project', @project_flush[:project_name]]
          self.class.request('flavor', 'set', opts)
        end
      end
      @project_flush.clear
    end
  end
  private

  def props_to_s(props)
    props.flat_map{ |k, v| ['--property', "#{k}=#{v}"] }
  end
end

