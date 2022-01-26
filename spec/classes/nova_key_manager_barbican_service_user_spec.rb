require 'spec_helper'

describe 'nova::key_manager::barbican::service_user' do
  shared_examples 'nova::key_manager::barbican::service_user' do

    let :params do
      { :password => 'secret' }
    end

    context 'with default parameters' do
      it {
        is_expected.to contain_oslo__key_manager__barbican__service_user('nova_config').with(
          :username            => 'nova',
          :password            => 'secret',
          :auth_url            => 'http://localhost:5000',
          :project_name        => 'services',
          :user_domain_name    => 'Default',
          :project_domain_name => 'Default',
          :system_scope        => '<SERVICE DEFAULT>',
          :insecure            => '<SERVICE DEFAULT>',
          :auth_type           => 'password',
          :auth_version        => '<SERVICE DEFAULT>',
          :cafile              => '<SERVICE DEFAULT>',
          :certfile            => '<SERVICE DEFAULT>',
          :keyfile             => '<SERVICE DEFAULT>',
          :region_name         => '<SERVICE DEFAULT>',
        )
      }
    end

    context 'with specified parameters' do
      before :each do
        params.merge!({
          :username            => 'alt_nova',
          :auth_url            => 'http://127.0.0.1:5000',
          :project_name        => 'alt_services',
          :user_domain_name    => 'Domain1',
          :project_domain_name => 'Domain2',
          :system_scope        => 'all',
          :insecure            => false,
          :auth_type           => 'v3password',
          :auth_version        => 'v3',
          :cafile              => '/opt/stack/data/cafile.pem',
          :certfile            => 'certfile.crt',
          :keyfile             => 'keyfile',
          :region_name         => 'regionOne',
        })
      end

      it {
        is_expected.to contain_oslo__key_manager__barbican__service_user('nova_config').with(
          :username            => 'alt_nova',
          :password            => 'secret',
          :auth_url            => 'http://127.0.0.1:5000',
          :project_name        => 'alt_services',
          :user_domain_name    => 'Domain1',
          :project_domain_name => 'Domain2',
          :system_scope        => 'all',
          :insecure            => false,
          :auth_type           => 'v3password',
          :auth_version        => 'v3',
          :cafile              => '/opt/stack/data/cafile.pem',
          :certfile            => 'certfile.crt',
          :keyfile             => 'keyfile',
          :region_name         => 'regionOne',
        )
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::key_manager::barbican::service_user'
    end
  end
end
