require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/nova')

Puppet::Type.type(:nova_service).provide(
  :openstack,
  :parent => Puppet::Provider::Nova
) do
  desc <<-EOT
    Provider to manage nova host services
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  mk_resource_methods

  def self.instances
    hosts = {}
    request('compute service', 'list').collect do |host_svc|
      hname = host_svc[:host]
      if hosts[hname].nil?
        hosts[hname] = Hash.new {|h,k| h[k]=[]}
        hosts[hname][:ids] = []
        hosts[hname][:service_name] = []
      end
      hosts[hname][:ids] << host_svc[:id]
      hosts[hname][:service_name] << host_svc[:binary]
    end
    hosts.collect do |hname, host|
      new(
        :ensure => :present,
        :name => hname,
        :ids => host[:ids],
        :service_name => host[:service_name]
      )
    end
  end

  def self.prefetch(resources)
    instances_ = self.instances
    resources.keys.each do |name|
      if provider = instances_.find{ |instance| instance.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    return unless @property_hash[:ids].kind_of?(Array)
    svcname_id_map = @property_hash[:service_name].zip(@property_hash[:ids]) || {}
    svcname_id_map.each do |service_name, id|
      if (@resource[:service_name].empty? ||
          (@resource[:service_name].include? service_name))
        self.class.request('compute service', 'delete', id)
      end
    end
    @property_hash[:ensure] = :absent
  end

  def create
    warning("Nova_service provider can only delete compute services because "\
            "of openstackclient limitations.")
  end
end
