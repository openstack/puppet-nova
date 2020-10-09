require 'spec_helper'

describe 'nova::keystone::auth' do

  let :params do
    {
      :password => 'nova_password'
    }
  end

  let :default_params do
    {
      :auth_name    => 'nova',
      :service_name => 'nova',
      :region       => 'RegionOne',
      :tenant       => 'services',
      :email        => 'nova@localhost',
      :public_url   => 'http://127.0.0.1:8774/v2.1',
      :internal_url => 'http://127.0.0.1:8774/v2.1',
      :admin_url    => 'http://127.0.0.1:8774/v2.1'
    }
  end

  shared_examples 'nova::keystone::auth' do
    context 'with default parameters' do
      it { should contain_keystone_user('nova').with(
        :ensure   => 'present',
        :password => 'nova_password'
      )}

      it { should contain_keystone_user_role('nova@services').with(
        :ensure => 'present',
        :roles  => ['admin']
      )}

      it { should contain_keystone_service('nova::compute').with(
        :ensure      => 'present',
        :description => 'Openstack Compute Service'
      )}

      it { should contain_keystone_endpoint('RegionOne/nova::compute').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:8774/v2.1',
        :admin_url    => 'http://127.0.0.1:8774/v2.1',
        :internal_url => 'http://127.0.0.1:8774/v2.1'
      )}
    end

    context 'when overriding roles' do
      before do
        params.merge!( :roles => ['admin', 'service'] )
      end

      it { should contain_keystone_user_role('nova@services').with(
        :ensure => 'present',
        :roles  => ['admin', 'service']
      )}
    end

    context 'when setting auth name' do
      before do
        params.merge!( :auth_name => 'foo' )
      end

      it { should contain_keystone_user('foo').with(
        :ensure   => 'present',
        :password => 'nova_password'
      )}

      it { should contain_keystone_user_role('foo@services').with(
        :ensure => 'present',
        :roles  => ['admin']
      )}

      it { should contain_keystone_service('nova::compute').with(
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

      it { should contain_keystone_endpoint('RegionTwo/nova::compute').with(
        :ensure       => 'present',
        :public_url   => params[:public_url],
        :internal_url => params[:internal_url],
        :admin_url    => params[:admin_url]
      )}

    end

    context 'when disabling endpoint configuration' do
      before do
        params.merge!( :configure_endpoint => false )
      end

      it { should_not contain_keystone_endpoint('RegionOne/nova::compute') }
    end

    context 'when disabling user configuration' do
      before do
        params.merge!( :configure_user => false )
      end

      it { should_not contain_keystone_user('nova') }
      it { should contain_keystone_user_role('nova@services') }
      it { should contain_keystone_service('nova::compute').with(
        :ensure      => 'present',
        :description => 'Openstack Compute Service'
      )}
    end

    context 'when disabling user and user role configuration' do
      let :params do
        {
          :configure_user      => false,
          :configure_user_role => false,
          :password            => 'nova_password'
        }
      end

      it { should_not contain_keystone_user('nova') }
      it { should_not contain_keystone_user_role('nova@services') }

      it { should contain_keystone_service('nova::compute').with(
        :ensure      => 'present',
        :description => 'Openstack Compute Service'
      )}
    end

    context 'when overriding service names' do
      let :params do
        {
          :service_name => 'nova_service',
          :password     => 'nova_password'
        }
      end

      it { should contain_keystone_user('nova') }
      it { should contain_keystone_user_role('nova@services') }
      it { should contain_keystone_service('nova_service::compute') }
      it { should contain_keystone_endpoint('RegionOne/nova_service::compute') }
    end

    context 'when configuring nova-api and the keystone endpoint' do
      let :pre_condition do
        "class { '::nova::keystone::authtoken':
           password => 'secrete',
         }
         class { 'nova::api': }
         include nova"
      end

      let :params do
        {
          :password     => 'test',
          :service_name => 'nova',
        }
      end

      it { should contain_keystone_endpoint('RegionOne/nova::compute').with_before(['Anchor[nova::service::end]']) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::keystone::auth'
    end
  end
end
