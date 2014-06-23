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
    # Install module
    puppet_module_install(:source => proj_root, :module_name => 'nova')
    hosts.each do |host|
      on host, puppet('module','install','dprince/qpid'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','duritong/sysctl'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-cinder'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-glance'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','stahnma-epel'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-keystone'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-mysql', '--version', '2.2'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-rabbitmq'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
