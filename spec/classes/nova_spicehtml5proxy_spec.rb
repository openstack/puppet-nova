require 'spec_helper'

describe 'nova::spicehtml5proxy' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova-spicehtml5proxy debian package' do
    let :params do
      { :enabled => true }
    end

    it { is_expected.to contain_file_line('/etc/default/nova-consoleproxy:NOVA_CONSOLE_PROXY_TYPE').with(
        :path    => '/etc/default/nova-consoleproxy',
        :match   => '^NOVA_CONSOLE_PROXY_TYPE=(.*)$',
        :line    => 'NOVA_CONSOLE_PROXY_TYPE=spicehtml5',
        :tag     => 'nova-consoleproxy',
        :require => 'Anchor[nova::config::begin]',
        :notify  => 'Anchor[nova::config::end]',
    )}
  end

  shared_examples 'nova-spicehtml5proxy' do
    it 'configures nova.conf' do
      is_expected.to contain_nova_config('spice/html5proxy_host').with(:value => '0.0.0.0')
      is_expected.to contain_nova_config('spice/html5proxy_port').with(:value => '6082')
    end

    it { is_expected.to contain_package('nova-spicehtml5proxy').with(
      :ensure => 'present',
      :name   => platform_params[:spicehtml5proxy_package_name]
    ) }

    it { is_expected.to contain_service('nova-spicehtml5proxy').with(
      :ensure    => 'running',
      :name      => platform_params[:spicehtml5proxy_service_name],
      :hasstatus => true
    )}

    context 'with manage_service as false' do
      let :params do
        { :enabled        => true,
          :manage_service => false
        }
      end

      it { is_expected.to contain_service('nova-spicehtml5proxy').without_ensure }
    end

    context 'with package version' do
      let :params do
        { :ensure_package => '2012.1-2' }
      end

      it { is_expected.to contain_package('nova-spicehtml5proxy').with(
        :ensure => params[:ensure_package],
        :name   => platform_params[:spicehtml5proxy_package_name],
      )}
    end
  end

  context 'on Ubuntu system' do
    let :facts do
      @default_facts.merge({
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu',
        :os_package_type => 'ubuntu',
        :os => { :family => 'Debian', :release => { :major => '16'}}
      })
    end

    let :platform_params do
      { :spicehtml5proxy_package_name => 'nova-spiceproxy',
        :spicehtml5proxy_service_name => 'nova-spiceproxy' }
    end

    it_configures 'nova-spicehtml5proxy'
  end

  context 'on Debian system' do
    let :facts do
      @default_facts.merge({
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :operatingsystemmajrelease => '9',
        :os_package_type           => 'debian',
        :os => { :family => 'Debian', :release => { :major => '9'}}
      })
    end

    let :platform_params do
      { :spicehtml5proxy_package_name => 'nova-consoleproxy',
        :spicehtml5proxy_service_name => 'nova-spicehtml5proxy' }
    end

    it_configures 'nova-spicehtml5proxy debian package'
    it_configures 'nova-spicehtml5proxy'
  end

  context 'on Ubuntu system with Debian packages' do
    let :facts do
      @default_facts.merge({
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu',
        :os_package_type => 'debian',
        :os => { :family => 'Debian', :release => { :major => '16'}}
      })
    end

    let :platform_params do
      { :spicehtml5proxy_package_name => 'nova-consoleproxy',
        :spicehtml5proxy_service_name => 'nova-spicehtml5proxy' }
    end

    it_configures 'nova-spicehtml5proxy debian package'
    it_configures 'nova-spicehtml5proxy'
  end


  context 'on Redhat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat',
        :os => { :family => 'RedHat', :release => { :major => '7'}}
      })
    end

    let :platform_params do
      { :spicehtml5proxy_package_name => 'openstack-nova-console',
        :spicehtml5proxy_service_name => 'openstack-nova-spicehtml5proxy' }
    end

    it_configures 'nova-spicehtml5proxy'
  end

end
