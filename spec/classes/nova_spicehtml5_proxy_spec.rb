require 'spec_helper'

describe 'nova::spicehtml5proxy' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova-spicehtml5proxy' do

    it 'configures nova.conf' do
      is_expected.to contain_nova_config('spice/html5proxy_host').with(:value => '0.0.0.0')
      is_expected.to contain_nova_config('spice/html5proxy_port').with(:value => '6082')
    end

    it { is_expected.to contain_package('nova-spicehtml5proxy').with(
      :name   => platform_params[:spicehtml5proxy_package_name],
      :ensure => 'present'
    ) }

    it { is_expected.to contain_service('nova-spicehtml5proxy').with(
      :name      => platform_params[:spicehtml5proxy_service_name],
      :hasstatus => 'true',
      :ensure    => 'running'
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
        :ensure => params[:ensure_package]
      )}
    end
  end

  context 'on Ubuntu system' do
    let :facts do
      @default_facts.merge({
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu',
        :os_package_type => 'ubuntu'
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
        :osfamily        => 'Debian',
        :operatingsystem => 'Debian',
        :os_package_type => 'debian'
      })
    end

    let :platform_params do
      { :spicehtml5proxy_package_name => 'nova-consoleproxy',
        :spicehtml5proxy_service_name => 'nova-spicehtml5proxy' }
    end

    it_configures 'nova-spicehtml5proxy'
  end

  context 'on Ubuntu system with Debian packages' do
    let :facts do
      @default_facts.merge({
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu',
        :os_package_type => 'debian'
      })
    end

    let :platform_params do
      { :spicehtml5proxy_package_name => 'nova-consoleproxy',
        :spicehtml5proxy_service_name => 'nova-spicehtml5proxy' }
    end

    it_configures 'nova-spicehtml5proxy'
  end


  context 'on Redhat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    let :platform_params do
      { :spicehtml5proxy_package_name => 'openstack-nova-console',
        :spicehtml5proxy_service_name => 'openstack-nova-spicehtml5proxy' }
    end

    it_configures 'nova-spicehtml5proxy'
  end

end
