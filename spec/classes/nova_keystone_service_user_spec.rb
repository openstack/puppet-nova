require 'spec_helper'

describe 'nova::keystone::service_user' do

  let :params do
    {
      :password => 'nova_password',
    }
  end

  shared_examples 'nova service_user' do

    context 'with default parameters' do

      it 'configure service_user' do
        is_expected.to contain_keystone__resource__service_user('nova_config').with(
          :username                => 'nova',
          :password                => 'nova_password',
          :auth_url                => 'http://127.0.0.1:5000/',
          :project_name            => 'services',
          :user_domain_name        => 'Default',
          :project_domain_name     => 'Default',
          :system_scope            => '<SERVICE DEFAULT>',
          :insecure                => '<SERVICE DEFAULT>',
          :send_service_user_token => '<SERVICE DEFAULT>',
          :auth_type               => 'password',
          :auth_version            => '<SERVICE DEFAULT>',
          :cafile                  => '<SERVICE DEFAULT>',
          :certfile                => '<SERVICE DEFAULT>',
          :keyfile                 => '<SERVICE DEFAULT>',
          :region_name             => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :username                => 'myuser',
          :password                => 'mypasswd',
          :auth_url                => 'http://127.0.0.1:5000',
          :project_name            => 'service_project',
          :user_domain_name        => 'domainX',
          :project_domain_name     => 'domainX',
          :system_scope            => 'all',
          :send_service_user_token => true,
          :insecure                => false,
          :auth_type               => 'password',
          :auth_version            => 'v3',
          :cafile                  => '/opt/stack/data/cafile.pem',
          :certfile                => 'certfile.crt',
          :keyfile                 => 'keyfile',
          :region_name             => 'region2',
        })
      end

      it 'configure service_user' do
        is_expected.to contain_keystone__resource__service_user('nova_config').with(
          :username                => 'myuser',
          :password                => 'mypasswd',
          :auth_url                => 'http://127.0.0.1:5000',
          :project_name            => 'service_project',
          :user_domain_name        => 'domainX',
          :project_domain_name     => 'domainX',
          :system_scope            => 'all',
          :send_service_user_token => true,
          :insecure                => false,
          :auth_type               => 'password',
          :auth_version            => 'v3',
          :cafile                  => '/opt/stack/data/cafile.pem',
          :certfile                => 'certfile.crt',
          :keyfile                 => 'keyfile',
          :region_name             => 'region2',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova service_user'
    end
  end

end
