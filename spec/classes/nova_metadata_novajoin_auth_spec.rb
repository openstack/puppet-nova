require 'spec_helper'

describe 'nova::metadata::novajoin::auth' do

  let :params do
    {:password => 'novajoin_password'}
  end

  let :default_params do
    { :auth_name              => 'novajoin',
      :service_name           => 'novajoin',
      :region                 => 'RegionOne',
      :tenant                 => 'services',
      :email                  => 'novajoin@localhost',
      :public_url             => 'http://127.0.0.1:9090',
      :internal_url           => 'http://127.0.0.1:9090',
      :admin_url              => 'http://127.0.0.1:9090' }
  end

  context 'with default parameters' do

    it { is_expected.to contain_keystone_user('novajoin').with(
      :ensure   => 'present',
      :password => 'novajoin_password'
    ) }

    it { is_expected.to contain_keystone_user_role('novajoin@services').with(
      :ensure => 'present',
      :roles  => ['admin']
    )}

    it { is_expected.to contain_keystone_service('novajoin::compute-vendordata-plugin').with(
      :ensure      => 'present',
      :description => 'Novajoin vendordata plugin'
    )}

    it { is_expected.to_not contain_keystone_endpoint('RegionOne/novajoin::compute-vendordata-plugin') }
  end

  context 'when setting auth name' do
    before do
      params.merge!( :auth_name => 'foo' )
    end

    it { is_expected.to contain_keystone_user('foo').with(
      :ensure   => 'present',
      :password => 'novajoin_password'
    ) }

    it { is_expected.to contain_keystone_user_role('foo@services').with(
      :ensure => 'present',
      :roles  => ['admin']
    )}

    it { is_expected.to contain_keystone_service('novajoin::compute-vendordata-plugin').with(
      :ensure      => 'present',
      :description => 'Novajoin vendordata plugin'
    )}

  end

  context 'when creating endpoint with default parameters' do
    before do
      params.merge!( :configure_endpoint => true )
    end
    it { is_expected.to contain_keystone_endpoint('RegionOne/novajoin::compute-vendordata-plugin').with(
      :ensure       => 'present',
      :public_url   => 'http://127.0.0.1:9090',
      :admin_url    => 'http://127.0.0.1:9090',
      :internal_url => 'http://127.0.0.1:9090'
    )}
  end

  context 'when overriding endpoint parameters' do
    before do
      params.merge!(
        :configure_endpoint => true,
        :region       => 'RegionTwo',
        :public_url   => 'https://10.0.0.1:9090',
        :internal_url => 'https://10.0.0.3:9090',
        :admin_url    => 'https://10.0.0.2:9090',
      )
    end

    it { is_expected.to contain_keystone_endpoint('RegionTwo/novajoin::compute-vendordata-plugin').with(
      :ensure       => 'present',
      :public_url   => params[:public_url],
      :internal_url => params[:internal_url],
      :admin_url    => params[:admin_url]
    )}

  end

  describe 'when disabling user configuration' do
    before do
      params.merge!( :configure_user => false )
    end

    it { is_expected.to_not contain_keystone_user('novajoin') }
    it { is_expected.to contain_keystone_user_role('novajoin@services') }
    it { is_expected.to contain_keystone_service('novajoin::compute-vendordata-plugin').with(
      :ensure      => 'present',
      :description => 'Novajoin vendordata plugin'
    )}
  end

  describe 'when disabling user and user role configuration' do
    let :params do
      {
        :configure_user      => false,
        :configure_user_role => false,
        :password            => 'novajoin_password'
      }
    end

    it { is_expected.to_not contain_keystone_user('novajoin') }
    it { is_expected.to_not contain_keystone_user_role('novajoin@services') }
    it { is_expected.to contain_keystone_service('novajoin::compute-vendordata-plugin').with(
      :ensure      => 'present',
      :description => 'Novajoin vendordata plugin'
    )}
  end

  describe 'when configuring novajoin and the keystone endpoint' do
    let :pre_condition do
      "class { '::nova::metadata::novajoin::authtoken':
         password => 'secrete',
       }
      class { '::ipaclient': password => 'join_otp', }
       class { '::nova::metadata::novajoin::api':
         nova_password => 'secrete',
         transport_url => 'rabbit://127.0.0.1//',
       }"
    end

    let :facts do
      @default_facts.merge({
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '7.0',
      })
    end

    let :params do
      {
        :password => 'test',
        :configure_endpoint => true,
      }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/novajoin::compute-vendordata-plugin').with_notify(['Service[novajoin-server]', 'Service[novajoin-notify]']) }
  end

  describe 'when overriding service names' do

    let :params do
      {
        :service_name => 'novajoin_service',
        :password     => 'novajoin_password'
      }
    end

    it { is_expected.to contain_keystone_user('novajoin') }
    it { is_expected.to contain_keystone_user_role('novajoin@services') }
    it { is_expected.to contain_keystone_service('novajoin_service::compute-vendordata-plugin') }

  end

end
