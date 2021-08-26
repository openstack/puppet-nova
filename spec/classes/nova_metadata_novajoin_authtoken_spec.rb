require 'spec_helper'

describe 'nova::metadata::novajoin::authtoken' do

  let :params do
    { :password => 'novajoin_password', }
  end

  shared_examples 'nova::metadata::novajoin::authtoken' do

    context 'with default parameters' do

      it 'configure keystone_authtoken' do
        is_expected.to contain_keystone__resource__authtoken('novajoin_config').with(
          :username                       => 'novajoin',
          :password                       => 'novajoin_password',
          :auth_url                       => 'http://127.0.0.1:5000/',
          :project_name                   => 'services',
          :user_domain_name               => 'Default',
          :project_domain_name            => 'Default',
          :insecure                       => '<SERVICE DEFAULT>',
          :auth_section                   => '<SERVICE DEFAULT>',
          :auth_type                      => 'password',
          :www_authenticate_uri           => 'http://127.0.0.1:5000/',
          :auth_version                   => '<SERVICE DEFAULT>',
          :cache                          => '<SERVICE DEFAULT>',
          :cafile                         => '<SERVICE DEFAULT>',
          :certfile                       => '<SERVICE DEFAULT>',
          :delay_auth_decision            => '<SERVICE DEFAULT>',
          :enforce_token_bind             => '<SERVICE DEFAULT>',
          :http_connect_timeout           => '<SERVICE DEFAULT>',
          :http_request_max_retries       => '<SERVICE DEFAULT>',
          :include_service_catalog        => '<SERVICE DEFAULT>',
          :keyfile                        => '<SERVICE DEFAULT>',
          :memcache_pool_conn_get_timeout => '<SERVICE DEFAULT>',
          :memcache_pool_dead_retry       => '<SERVICE DEFAULT>',
          :memcache_pool_maxsize          => '<SERVICE DEFAULT>',
          :memcache_pool_socket_timeout   => '<SERVICE DEFAULT>',
          :memcache_pool_unused_timeout   => '<SERVICE DEFAULT>',
          :memcache_secret_key            => '<SERVICE DEFAULT>',
          :memcache_security_strategy     => '<SERVICE DEFAULT>',
          :memcache_use_advanced_pool     => '<SERVICE DEFAULT>',
          :memcached_servers              => '<SERVICE DEFAULT>',
          :manage_memcache_package        => false,
          :region_name                    => '<SERVICE DEFAULT>',
          :token_cache_time               => '<SERVICE DEFAULT>',
          :service_token_roles            => '<SERVICE DEFAULT>',
          :service_token_roles_required   => '<SERVICE DEFAULT>',
          :service_type                   => '<SERVICE DEFAULT>',
          :interface                      => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :www_authenticate_uri           => 'https://10.0.0.1:9999/',
          :username                       => 'myuser',
          :password                       => 'mypasswd',
          :auth_url                       => 'http://127.0.0.1:5000',
          :project_name                   => 'service_project',
          :user_domain_name               => 'domainX',
          :project_domain_name            => 'domainX',
          :insecure                       => false,
          :auth_section                   => 'new_section',
          :auth_type                      => 'password',
          :auth_version                   => 'v3',
          :cache                          => 'somevalue',
          :cafile                         => '/opt/stack/data/cafile.pem',
          :certfile                       => 'certfile.crt',
          :delay_auth_decision            => false,
          :enforce_token_bind             => 'permissive',
          :http_connect_timeout           => '300',
          :http_request_max_retries       => '3',
          :include_service_catalog        => true,
          :keyfile                        => 'keyfile',
          :memcache_pool_conn_get_timeout => '9',
          :memcache_pool_dead_retry       => '302',
          :memcache_pool_maxsize          => '11',
          :memcache_pool_socket_timeout   => '2',
          :memcache_pool_unused_timeout   => '61',
          :memcache_secret_key            => 'secret_key',
          :memcache_security_strategy     => 'ENCRYPT',
          :memcache_use_advanced_pool     => true,
          :memcached_servers              => ['memcached01:11211','memcached02:11211'],
          :manage_memcache_package        => true,
          :region_name                    => 'region2',
          :token_cache_time               => '301',
          :service_token_roles            => ['service'],
          :service_token_roles_required   => false,
          :service_type                   => 'identity',
          :interface                      => 'internal',
        })
      end

      it 'configure keystone_authtoken' do
        is_expected.to contain_keystone__resource__authtoken('novajoin_config').with(
          :www_authenticate_uri           => 'https://10.0.0.1:9999/',
          :username                       => 'myuser',
          :password                       => 'mypasswd',
          :auth_url                       => 'http://127.0.0.1:5000',
          :project_name                   => 'service_project',
          :user_domain_name               => 'domainX',
          :project_domain_name            => 'domainX',
          :insecure                       => false,
          :auth_section                   => 'new_section',
          :auth_type                      => 'password',
          :auth_version                   => 'v3',
          :cache                          => 'somevalue',
          :cafile                         => '/opt/stack/data/cafile.pem',
          :certfile                       => 'certfile.crt',
          :delay_auth_decision            => false,
          :enforce_token_bind             => 'permissive',
          :http_connect_timeout           => '300',
          :http_request_max_retries       => '3',
          :include_service_catalog        => true,
          :keyfile                        => 'keyfile',
          :memcache_pool_conn_get_timeout => '9',
          :memcache_pool_dead_retry       => '302',
          :memcache_pool_maxsize          => '11',
          :memcache_pool_socket_timeout   => '2',
          :memcache_pool_unused_timeout   => '61',
          :memcache_secret_key            => 'secret_key',
          :memcache_security_strategy     => 'ENCRYPT',
          :memcache_use_advanced_pool     => true,
          :memcached_servers              => ['memcached01:11211','memcached02:11211'],
          :manage_memcache_package        => true,
          :region_name                    => 'region2',
          :token_cache_time               => '301',
          :service_token_roles            => ['service'],
          :service_token_roles_required   => false,
          :service_type                   => 'identity',
          :interface                      => 'internal',
        )
      end
    end

    context 'when overriding parameters via params hash' do
      before do
        params.merge!({
          :username => 'myuser',
          :params   => { 'username' => 'myotheruser' },
        })
      end

      it 'configure keystone_authtoken' do
        is_expected.to contain_keystone__resource__authtoken('novajoin_config').with(
          :username => 'myotheruser',
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

      it_configures 'nova::metadata::novajoin::authtoken'
    end
  end

end
