require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/nova')

Puppet::Type.type(:nova_security_group).provide(
  :openstack,
  :parent => Puppet::Provider::Nova
) do
  desc <<-EOT
      Manage nova security groups
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def create
    opts = [@resource[:name]]
    (opts << '--description' << @resource[:description]) if @resource[:description]
    @property_hash = self.class.nova_request('security group', 'create', nil, opts)
    @property_hash[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('security group', 'delete', @resource[:name])
  end

  mk_resource_methods

  def id=(value)
    fail('id is read only')
  end

  def name=(value)
    fail('name is read only')
  end

  def description=(value)
    @property_flush[:description] = value
  end

  def self.instances
    # NOTE(mnaser): The OpenStack client makes a request to the Neutron endpoint
    #               to get security groups and if it has an admin role, it will
    #               retrieve all security groups.  The following helps filter it.
    project_id = self.nova_request('token', 'issue', nil, ['-c', 'project_id', '-f', 'value']).strip

    self.nova_request('security group', 'list', nil).select do |attrs|
      attrs[:project] == project_id
    end.collect do |attrs|
      new(
        :ensure      => :present,
        :id          => attrs[:id],
        :name        => attrs[:name],
        :description => attrs[:description]
      )
    end
  end

  def self.prefetch(resources)
    security_groups = instances
    resources.keys.each do |name|
      if provider = security_groups.find { |security_group| security_group.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    unless @property_flush.empty?
      opts = [@resource[:name]]
      (opts << '--description' << @resource[:description]) if @resource[:description]
      self.class.request('security group', 'set', opts)
      @property_flush.clear
    end
  end
end