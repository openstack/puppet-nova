require 'beaker-rspec'

hosts.each do |host|

  install_puppet

  on host, "mkdir -p #{host['distmoduledir']}"
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|

      # install git
      install_package host, 'git'

      # clean out any module cruft
      shell('rm -fr /etc/puppet/modules/*')

      # install library modules from the forge
      on host, puppet('module','install','puppetlabs-mysql'), { :acceptable_exit_codes => 0 }
      on host, puppet('module','install','dprince/qpid'), { :acceptable_exit_codes => 0 }
      on host, puppet('module','install','duritong/sysctl'), { :acceptable_exit_codes => 0 }
      on host, puppet('module','install','puppetlabs-inifile'), { :acceptable_exit_codes => 0 }
      on host, puppet('module','install','stahnma-epel'), { :acceptable_exit_codes => 0 }
      on host, puppet('module','install','puppetlabs-rabbitmq'), { :acceptable_exit_codes => 0 }

      # install puppet modules from git, use master
      shell('git clone https://git.openstack.org/stackforge/puppet-openstacklib /etc/puppet/modules/openstacklib')
      shell('git clone https://git.openstack.org/stackforge/puppet-keystone /etc/puppet/modules/keystone')
      shell('git clone https://git.openstack.org/stackforge/puppet-cinder /etc/puppet/modules/cinder')
      shell('git clone https://git.openstack.org/stackforge/puppet-glance /etc/puppet/modules/glance')

      # Install the module being tested
      puppet_module_install(:source => proj_root, :module_name => 'nova')
      # List modules installed to help with debugging
      on hosts[0], puppet('module','list'), { :acceptable_exit_codes => 0 }
    end
  end
end
