require 'puppet/util/inifile'
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'

class Puppet::Provider::Nova < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

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

  def self.reset
    @nova_conf = nil
  end
end
