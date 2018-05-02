# Run test ie with: rspec spec/unit/provider/nova_spec.rb

# Add openstacklib code to $LOAD_PATH so that we can load this during
# standalone compiles without error.
File.expand_path('../../../../openstacklib/lib', File.dirname(__FILE__)).tap { |dir| $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir) }

require 'puppet/util/inifile'
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'

class Puppet::Provider::Nova < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

  def self.request(service, action, properties=nil)
    begin
      super
    rescue Puppet::Error::OpenstackAuthInputError => error
      nova_request(service, action, error, properties)
    end
  end

  def self.nova_request(service, action, error, properties=nil)
    properties ||= []
    @credentials.username = nova_credentials['username']
    @credentials.password = nova_credentials['password']
    @credentials.project_name = nova_credentials['project_name']
    @credentials.auth_url = auth_endpoint
    if @credentials.version == '3'
      @credentials.user_domain_name = nova_credentials['user_domain_name']
      @credentials.project_domain_name = nova_credentials['project_domain_name']
    end
    if nova_credentials['region_name']
      @credentials.region_name = nova_credentials['region_name']
    end
    raise error unless @credentials.set?
    Puppet::Provider::Openstack.request(service, action, properties, @credentials)
  end

  def self.nova_manage_request(*args)
    # Not using the nova-manage command directly,
    # so we can disable combining of stderr/stdout output.
    args.unshift(Puppet::Util.which('nova-manage'))

    # NOTE(mnaser): We pass the arguments as an array to avoid problems with
    #               symbols in the arguments breaking things.
    Puppet::Util::Execution.execute(args, {
      :uid                => nova_user,
      :failonfail         => true,
      :combine            => false,
      :custom_environment => {}
    })
  end

  def nova_manage_request(*args)
    self.class.nova_manage_request(args)
  end

  def self.nova_user
    'nova'
  end

  def self.conf_filename
    '/etc/nova/nova.conf'
  end

  def self.nova_conf
    return @nova_conf if @nova_conf
    @nova_conf = Puppet::Util::IniConfig::File.new
    @nova_conf.read(conf_filename)
    @nova_conf
  end

  def self.nova_credentials
    @nova_credentials ||= get_nova_credentials
  end

  def nova_credentials
    self.class.nova_credentials
  end

  def self.get_nova_credentials
    #needed keys for authentication
    auth_keys = ['www_authenticate_uri', 'project_name', 'username', 'password']
    conf = nova_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      creds = Hash[ auth_keys.map \
                   { |k| [k, conf['keystone_authtoken'][k].strip] } ]
      if conf['neutron'] and conf['neutron']['region_name']
        creds['region_name'] = conf['neutron']['region_name'].strip
      end
      if !conf['keystone_authtoken']['project_domain_name'].nil?
        creds['project_domain_name'] = conf['keystone_authtoken']['project_domain_name'].strip
      else
        creds['project_domain_name'] = 'Default'
      end
      if !conf['keystone_authtoken']['user_domain_name'].nil?
        creds['user_domain_name'] = conf['keystone_authtoken']['user_domain_name'].strip
      else
        creds['user_domain_name'] = 'Default'
      end
      return creds
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all " +
            "required sections.  Nova types will not work if nova is not " +
            "correctly configured.")
    end
  end

  def self.get_auth_endpoint
    q = nova_credentials
    "#{q['www_authenticate_uri']}"
  end

  def self.auth_endpoint
    @auth_endpoint ||= get_auth_endpoint
  end

  def self.reset
    @nova_conf = nil
    @nova_credentials = nil
  end

  def self.str2hash(s)
    #parse string
    if s.include? "="
      k, v = s.split("=", 2)
      return {k.gsub(/'/, "") => v.gsub(/'/, "")}
    else
      return s.gsub(/'/, "")
    end
  end
end
