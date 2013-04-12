require 'spec_helper'

describe 'nova::spicehtml5proxy' do

  let :pre_condition do
    'include nova'
  end

  let :params do
    {:enabled => true}
  end

  describe 'on debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it { should contain_nova_config('DEFAULT/spicehtml5proxy_host').with(:value => '0.0.0.0') }
    it { should contain_nova_config('DEFAULT/spicehtml5proxy_port').with(:value => '6082') }

    it { should contain_package('nova-spicehtml5proxy').with(
      :name   => 'nova-spicehtml5proxy',
      :ensure => 'present'
    ) }
    it { should contain_service('nova-spicehtml5proxy').with(
      :name   => 'nova-spicehtml5proxy',
      :hasstatus => 'true',
      :ensure => 'running'
    )}

    describe 'with package version' do
      let :params do
        {:ensure_package => '2012.1-2'}
      end
      it { should contain_package('nova-spicehtml5proxy').with(
        'ensure' => '2012.1-2'
      )}
    end

  end

  describe 'on debian system' do
    let :facts do
      { :osfamily => 'Debian',
        :operatingsystem => 'Debian',
      }
    end
    it { should contain_package('nova-spicehtml5proxy').with(
        :name => 'nova-consoleproxy'
    )}
  end

  describe 'on Redhatish platforms' do

    let :facts do
      { :osfamily => 'Redhat' }
    end
    it { should contain_service('nova-spicehtml5proxy').with(
      :name   => 'openstack-nova-spicehtml5proxy',
      :hasstatus => 'true',
      :ensure => 'running'
    )}
    it { should contain_package('nova-spicehtml5proxy').with(
        :name => 'openstack-nova-console'
    )}
  end

end
