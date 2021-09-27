#
# Unit tests for nova::keystone::auth
#

require 'spec_helper'

describe 'nova::keystone::auth' do
  shared_examples_for 'nova::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'nova_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('nova').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'nova',
        :service_type        => 'compute',
        :service_description => 'Openstack Compute Service',
        :region              => 'RegionOne',
        :auth_name           => 'nova',
        :password            => 'nova_password',
        :email               => 'nova@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :public_url          => 'http://127.0.0.1:8774/v2.1',
        :internal_url        => 'http://127.0.0.1:8774/v2.1',
        :admin_url           => 'http://127.0.0.1:8774/v2.1',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'nova_password',
          :auth_name           => 'alt_nova',
          :email               => 'alt_nova@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Openstack Compute Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_compute',
          :region              => 'RegionTwo',
          :roles               => ['admin', 'service'],
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('nova').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_compute',
        :service_description => 'Alternative Openstack Compute Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_nova',
        :password            => 'nova_password',
        :email               => 'alt_nova@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
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
