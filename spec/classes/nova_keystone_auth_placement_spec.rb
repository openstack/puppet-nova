require 'spec_helper'

describe 'nova::keystone::auth_placement' do

  let :params do
    { :password => 'placement_password' }
  end

  let :default_params do
    { :auth_name              => 'placement',
      :service_name           => 'placement',
      :region                 => 'RegionOne',
      :tenant                 => 'services',
      :email                  => 'placement@localhost' }
  end

  shared_examples 'nova::keystone::auth_placement' do
    context 'with default parameters' do
      it { is_expected.to contain_keystone_user('placement').with(
        :ensure   => 'present',
        :password => 'placement_password'
      )}

      it { is_expected.to contain_keystone_user_role('placement@services').with(
        :ensure => 'present',
        :roles  => ['admin']
      )}

      it { is_expected.to contain_keystone_service('placement::placement').with(
        :ensure      => 'present',
        :description => 'Openstack Placement Service'
      )}

      it { is_expected.to contain_keystone_endpoint('RegionOne/placement::placement').with(
        :ensure       => 'present',
        :public_url   => platform_params[:public_url],
        :admin_url    => platform_params[:admin_url],
        :internal_url => platform_params[:internal_url]
      )}
    end

    context 'when setting auth name' do
      before do
        params.merge!( :auth_name => 'foo' )
      end

      it { is_expected.to contain_keystone_user('foo').with(
        :ensure   => 'present',
        :password => 'placement_password'
      )}

      it { is_expected.to contain_keystone_user_role('foo@services').with(
        :ensure => 'present',
        :roles  => ['admin']
      )}

      it { is_expected.to contain_keystone_service('placement::placement').with(
        :ensure      => 'present',
        :description => 'Openstack Placement Service'
      )}
    end

    context 'when overriding endpoint parameters' do
      before do
        params.merge!(
          :region       => 'RegionTwo',
          :public_url   => 'https://10.0.0.1:9778',
          :internal_url => 'https://10.0.0.3:9778',
          :admin_url    => 'https://10.0.0.2:9778',
        )
      end

      it { is_expected.to contain_keystone_endpoint('RegionTwo/placement::placement').with(
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

      it { is_expected.to_not contain_keystone_endpoint('RegionOne/placement::placement') }
    end

    describe 'when disabling user configuration' do
      before do
        params.merge!( :configure_user => false )
      end

      it { is_expected.to_not contain_keystone_user('placement') }
      it { is_expected.to contain_keystone_user_role('placement@services') }
      it { is_expected.to contain_keystone_service('placement::placement').with(
        :ensure      => 'present',
        :description => 'Openstack Placement Service'
      )}
    end

    describe 'when disabling user and user role configuration' do
      let :params do
        {
          :configure_user      => false,
          :configure_user_role => false,
          :password            => 'placement_password'
        }
      end

      it { is_expected.to_not contain_keystone_user('placement') }
      it { is_expected.to_not contain_keystone_user_role('placement@services') }
      it { is_expected.to contain_keystone_service('placement::placement').with(
        :ensure      => 'present',
        :description => 'Openstack Placement Service'
      )}
    end

    describe 'when configuring nova-placement and the keystone endpoint' do
      let :pre_condition do
        "class { '::nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::api':}
         include nova"
      end

      let :facts do
        facts.merge({ :osfamily => "Debian"})
      end

      let :params do
        {
          :password => 'test'
        }
      end
    end

    describe 'when overriding service names' do
      let :params do
        {
          :service_name => 'nova_service',
          :password     => 'placement_password'
        }
      end

      it { is_expected.to contain_keystone_user('placement') }
      it { is_expected.to contain_keystone_user_role('placement@services') }
      it { is_expected.to contain_keystone_service('nova_service::placement') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/nova_service::placement') }
    end
  end

  shared_examples 'nova::keystone::auth_placement on Debian' do
    before do
      facts.merge!( :os_package_type => 'debian' )
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/placement::placement').with(
      :ensure       => 'present',
      :public_url   => platform_params[:public_url],
      :admin_url    => platform_params[:admin_url],
      :internal_url => platform_params[:internal_url]
    )}
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        if facts[:os_package_type] == 'debian'
          { :public_url   => 'http://127.0.0.1',
            :internal_url => 'http://127.0.0.1',
            :admin_url    => 'http://127.0.0.1' }
        else
          { :public_url   => 'http://127.0.0.1/placement',
            :internal_url => 'http://127.0.0.1/placement',
            :admin_url    => 'http://127.0.0.1/placement' }
        end
      end

      it_behaves_like 'nova::keystone::auth_placement'

      if facts[:operatingsystem] == 'Debian'
        it_behaves_like 'nova::keystone::auth_placement on Debian'
      end
    end
  end

end
