require File.join(File.dirname(__FILE__), '..','..','..',
                  'puppet/provider/nova')

Puppet::Type.type(:nova_security_group).provide(
  :nova,
  :parent => Puppet::Provider::Nova
) do

  desc "Manage nova security groups"

  commands :nova => 'nova'

  mk_resource_methods

  def exists?
    sec_groups = self.class.cliout2list(auth_nova('secgroup-list'))
    return sec_groups.detect do |n|
        n['Name'] == resource['name']
    end
  end

  def destroy
    auth_nova("secgroup-delete", name)
    @property_hash[:ensure] = :absent
  end

  def create
    result = self.class.cliout2list(auth_nova("secgroup-create", resource[:name], resource[:description]))

    @property_hash = {
      :ensure => :present,
      :name => resource[:name],
      :id => result[0]['Id'],
      :description => resource[:description]
    }
  end
end
