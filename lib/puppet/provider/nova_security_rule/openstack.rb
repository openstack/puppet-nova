require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/nova')

Puppet::Type.type(:nova_security_rule).provide(
  :openstack,
  :parent => Puppet::Provider::Nova
) do
  desc <<-EOT
      Manage nova security rules
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  def create
    opts = [@resource[:security_group]]
    opts << '--protocol' << @resource[:ip_protocol]

    if @resource[:ip_protocol].to_s == 'icmp'
      unless @resource[:from_port].to_i == -1 and @resource[:to_port].to_i == -1
        opts << "--icmp-type" << @resource[:from_port]
        opts << "--icmp-code" << @resource[:to_port]
      end
    else
      opts << "--dst-port" << "#{@resource[:from_port]}:#{@resource[:to_port]}"
    end

    unless @resource[:ip_range].nil?
      opts << "--src-ip" << @resource[:ip_range]
    else
      opts << "--src-group" << @resource[:source_group]
    end

    @property_hash = self.class.nova_request('security group rule', 'create', nil, opts)
    @property_hash[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('security group rule', 'delete', @property_hash[:name])
    @property_hash[:ensure] == :absent
  end

  mk_resource_methods

  def self.instances
    rules = []
    secgroup_provider = Puppet::Type.type(:nova_security_group).provider(:openstack)
    groups = secgroup_provider.instances

    groups.each do |g|
      self.nova_request('security group rule', 'list', nil, ['--long', g.id]).each do |attrs|
        # NOTE(mnaser): Originally, security groups were ingress only so to maintain
        #               backwards compatibility, we ignore all egress rules.
        next if attrs[:direction] == 'egress'

        # NOTE(mnaser): With Neutron, an empty ip_range means all networks, therefore
        #               we replace it by '0.0.0.0/0' for backwards compatibility.
        attrs[:ip_range] = '0.0.0.0/0' if attrs[:ip_range].empty? and attrs[:remote_security_group].empty?

        # NOTE(mnaser): Another quirk, Neutron can have an empty port range which means
        #               all ports, we adjust the field accordingly for the protocol.
        if attrs[:port_range].empty?
          if ['tcp', 'udp'].include? attrs[:ip_protocol]
            attrs[:from_port] = 0
            attrs[:to_port] = 65536
          else
            attrs[:from_port] = -1
            attrs[:to_port] = -1
          end
        else
          attrs[:from_port], attrs[:to_port] = attrs[:port_range].split(':')
        end

        rule = {
          :ensure         => :present,
          :name           => attrs[:id],
          :security_group => g.name,
          :from_port      => attrs[:from_port],
          :to_port        => attrs[:to_port],
        }

        # NOTE(mnaser): The puppet type does not like getting source_group even if it's not set.
        unless attrs[:ip_range].empty?
          rule[:ip_range] = attrs[:ip_range]
        else
          rule[:source_group] = attrs[:remote_security_group]
        end

        # NOTE(mnaser): With Neutron, it is possible to have the ip_protocol empty
        #               which means all 3 protocols are allowed.  We create three
        #               resources to maintain backwards compatible.
        if attrs[:ip_protocol].empty?
          rules << new(rule.merge(:ip_protocol => 'tcp', :from_port => 0, :to_port => 65536))
          rules << new(rule.merge(:ip_protocol => 'udp', :from_port => 0, :to_port => 65536))
          rules << new(rule.merge(:ip_protocol => 'icmp', :from_port => -1, :to_port => -1))
        else
          rules << new(rule.merge(:ip_protocol => attrs[:ip_protocol]))
        end
      end
    end

    rules
  end

  def self.prefetch(resources)
    security_group_rules = instances
    resources.keys.each do |name|
      resource = resources[name].to_hash

      rule = security_group_rules.find do |r|
        r.security_group == resource[:security_group] && \
        r.ip_protocol.to_s == resource[:ip_protocol].to_s && \
        r.from_port.to_s == resource[:from_port].to_s && \
        r.to_port.to_s == resource[:to_port].to_s
      end

      resources[name].provider = rule if rule
    end
  end
end