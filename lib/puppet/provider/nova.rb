# Run test ie with: rspec spec/unit/provider/nova_spec.rb

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
    raise error unless @credentials.set?
    Puppet::Provider::Openstack.request(service, action, properties, @credentials)
  end

  def self.conf_filename
    '/etc/nova/nova.conf'
  end

  # deprecated: method for old nova cli auth
  def self.withenv(hash, &block)
    saved = ENV.to_hash
    hash.each do |name, val|
      ENV[name.to_s] = val
    end

    yield
  ensure
    ENV.clear
    saved.each do |name, val|
      ENV[name] = val
    end
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
    auth_keys = ['auth_uri', 'project_name', 'username', 'password']
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
    "#{q['auth_uri']}"
  end

  def self.auth_endpoint
    @auth_endpoint ||= get_auth_endpoint
  end

  # deprecated: method for old nova cli auth
  def self.auth_nova(*args)
    q = nova_credentials
    authenv = {
      :OS_AUTH_URL     => self.auth_endpoint,
      :OS_USERNAME     => q['username'],
      :OS_PROJECT_NAME => q['project_name'],
      :OS_PASSWORD     => q['password']
    }
    if q.key?('region_name')
      authenv[:OS_REGION_NAME] = q['region_name']
    end
    begin
      withenv authenv do
        nova(args)
      end
    rescue Exception => e
      if (e.message =~ /\[Errno 111\] Connection refused/) or
          (e.message =~ /\(HTTP 400\)/)
        sleep 10
        withenv authenv do
          nova(args)
        end
      else
       raise(e)
      end
    end
  end

  # deprecated: method for old nova cli auth
  def auth_nova(*args)
    self.class.auth_nova(args)
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

  # deprecated: string to list for nova cli
  def self.str2list(s)
    #parse string
    if s.include? ","
      if s.include? "="
        new = {}
      else
        new = []
      end
      if s =~ /^'.+'$/
        s.split("', '").each do |el|
          ret = str2hash(el.strip())
          if s.include? "="
            new.update(ret)
          else
            new.push(ret)
          end
        end
      else
        s.split(",").each do |el|
          ret = str2hash(el.strip())
          if s.include? "="
            new.update(ret)
          else
            new.push(ret)
          end
        end
      end
      return new
    else
      return str2hash(s.strip())
    end
  end

  # deprecated: nova cli to list
  def self.cliout2list(output)
    #don't proceed with empty output
    if output.empty?
      return []
    end
    lines = []
    output.each_line do |line|
      #ignore lines starting with '+'
      if not line.match("^\\+")
        #split line at '|' and remove useless information
        line = line.gsub(/^\| /, "").gsub(/ \|$/, "").gsub(/[\n]+/, "")
        line = line.split("|").map do |el|
          el.strip().gsub(/^-$/, "")
        end
        #check every element for list
        line = line.map do |el|
          el = str2list(el)
        end
        lines.push(line)
      end
    end
    #create a list of hashes and return the list
    hash_list = []
    header = lines[0]
    lines[1..-1].each do |line|
      hash_list.push(Hash[header.zip(line)])
    end
    return hash_list
  end

end
