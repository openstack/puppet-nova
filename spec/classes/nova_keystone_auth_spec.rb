require 'spec_helper'

describe 'nova::keystone::auth' do

  let :params do
    {:password => 'nova_password'}
  end

  let :default_params do
    { :auth_name              => 'nova',
      :service_name           => 'nova',
      :region                 => 'RegionOne',
      :tenant                 => 'services',
      :email                  => 'nova@localhost',
      :public_url             => 'http://127.0.0.1:8774/v2.1',
      :internal_url           => 'http://127.0.0.1:8774/v2.1',
      :admin_url              => 'http://127.0.0.1:8774/v2.1' }
  end

  context 'with default parameters' do

    it { is_expected.to contain_keystone_user('nova').with(
      :ensure   => 'present',
      :password => 'nova_password'
    ) }

    it { is_expected.to contain_keystone_user_role('nova@services').with(
      :ensure => 'present',
      :roles  => ['admin']
    )}

    it { is_expected.to contain_keystone_service('nova::compute').with(
      :ensure      => 'present',
      :description => 'Openstack Compute Service'
    )}

    it { is_expected.to contain_keystone_endpoint('RegionOne/nova::compute').with(
      :ensure       => 'present',
      :public_url   => 'http://127.0.0.1:8774/v2.1',
      :admin_url    => 'http://127.0.0.1:8774/v2.1',
      :internal_url => 'http://127.0.0.1:8774/v2.1'
    )}

  end

  context 'when setting auth name' do
    before do
      params.merge!( :auth_name => 'foo' )
    end

    it { is_expected.to contain_keystone_user('foo').with(
      :ensure   => 'present',
      :password => 'nova_password'
    ) }

    it { is_expected.to contain_keystone_user_role('foo@services').with(
      :ensure => 'present',
      :roles  => ['admin']
    )}

    it { is_expected.to contain_keystone_service('nova::compute').with(
      :ensure      => 'present',
      :description => 'Openstack Compute Service'
    )}

  end

  context 'when overriding endpoint parameters' do
    before do
      params.merge!(
        :region       => 'RegionTwo',
        :public_url   => 'https://10.0.0.1:9774/v2.2',
        :internal_url => 'https://10.0.0.3:9774/v2.2',
        :admin_url    => 'https://10.0.0.2:9774/v2.2',
      )
    end

    it { is_expected.to contain_keystone_endpoint('RegionTwo/nova::compute').with(
      :ensure       => 'present',
      :public_url   => params[:public_url],
      :internal_url => params[:internal_url],
      :admin_url    => params[:admin_url]
    )}

  end

  describe 'when disabling endpoint configuration' do
    before do
      params.merge!( :configure_endpoint => false )
    end

    it { is_expected.to_not contain_keystone_endpoint('RegionOne/nova::compute') }
  end

  describe 'when disabling user configuration' do
    before do
      params.merge!( :configure_user => false )
    end

    it { is_expected.to_not contain_keystone_user('nova') }
    it { is_expected.to contain_keystone_user_role('nova@services') }
    it { is_expected.to contain_keystone_service('nova::compute').with(
      :ensure      => 'present',
      :description => 'Openstack Compute Service'
    )}
  end

  describe 'when disabling user and user role configuration' do
    let :params do
      {
        :configure_user      => false,
        :configure_user_role => false,
        :password            => 'nova_password'
      }
    end

    it { is_expected.to_not contain_keystone_user('nova') }
    it { is_expected.to_not contain_keystone_user_role('nova@services') }
    it { is_expected.to contain_keystone_service('nova::compute').with(
      :ensure      => 'present',
      :description => 'Openstack Compute Service'
    )}
  end

  describe 'when configuring nova-api and the keystone endpoint' do
    let :pre_condition do
      "class { 'nova::api': admin_password => 'test' }
      include nova"
    end

    let :facts do
      @default_facts.merge({ :osfamily => "Debian"})
    end

    let :params do
      {
        :password => 'test'
      }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/nova::compute').with_notify(['Service[nova-api]']) }
  end

  describe 'when overriding service names' do

    let :params do
      {
        :service_name => 'nova_service',
        :password     => 'nova_password'
      }
    end

    it { is_expected.to contain_keystone_user('nova') }
    it { is_expected.to contain_keystone_user_role('nova@services') }
    it { is_expected.to contain_keystone_service('nova_service::compute') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/nova_service::compute') }

  end

end

