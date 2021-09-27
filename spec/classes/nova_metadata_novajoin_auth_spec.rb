#
# Unit tests for nova::metadata::novajoin::auth
#

require 'spec_helper'

describe 'nova::metadata::novajoin::auth' do
  shared_examples_for 'nova::metadata::novajoin::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'novajoin_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('novajoin').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => false,
        :service_name        => 'novajoin',
        :service_type        => 'compute-vendordata-plugin',
        :service_description => 'Novajoin vendordata plugin',
        :region              => 'RegionOne',
        :auth_name           => 'novajoin',
        :password            => 'novajoin_password',
        :email               => 'novajoin@localhost',
        :tenant              => 'services',
        :public_url          => 'http://127.0.0.1:9090',
        :internal_url        => 'http://127.0.0.1:9090',
        :admin_url           => 'http://127.0.0.1:9090',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'novajoin_password',
          :auth_name           => 'alt_novajoin',
          :email               => 'alt_novajoin@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => true,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Novajoin vendordata plugin',
          :service_name        => 'alt_service',
          :service_type        => 'alt_compute-vendordata-plugin',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('novajoin').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => true,
        :service_name        => 'alt_service',
        :service_type        => 'alt_compute-vendordata-plugin',
        :service_description => 'Alternative Novajoin vendordata plugin',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_novajoin',
        :password            => 'novajoin_password',
        :email               => 'alt_novajoin@alt_localhost',
        :tenant              => 'alt_service',
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

      it_behaves_like 'nova::metadata::novajoin::auth'
    end
  end
end
