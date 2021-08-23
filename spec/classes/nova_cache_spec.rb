require 'spec_helper'

describe 'nova::cache' do

  let :params do
    {}
  end

  shared_examples_for 'nova::cache' do

    context 'with default parameters' do
      it 'configures cache' do
        is_expected.to contain_oslo__cache('nova_config').with(
          :config_prefix                        => '<SERVICE DEFAULT>',
          :expiration_time                      => '<SERVICE DEFAULT>',
          :backend                              => '<SERVICE DEFAULT>',
          :backend_argument                     => '<SERVICE DEFAULT>',
          :proxies                              => '<SERVICE DEFAULT>',
          :enabled                              => '<SERVICE DEFAULT>',
          :debug_cache_backend                  => '<SERVICE DEFAULT>',
          :memcache_servers                     => '<SERVICE DEFAULT>',
          :memcache_dead_retry                  => '<SERVICE DEFAULT>',
          :memcache_socket_timeout              => '<SERVICE DEFAULT>',
          :memcache_pool_maxsize                => '<SERVICE DEFAULT>',
          :memcache_pool_unused_timeout         => '<SERVICE DEFAULT>',
          :memcache_pool_connection_get_timeout => '<SERVICE DEFAULT>',
          :tls_enabled                          => '<SERVICE DEFAULT>',
          :tls_cafile                           => '<SERVICE DEFAULT>',
          :tls_certfile                         => '<SERVICE DEFAULT>',
          :tls_keyfile                          => '<SERVICE DEFAULT>',
          :tls_allowed_ciphers                  => '<SERVICE DEFAULT>',
          :manage_backend_package               => true,
        )
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :config_prefix                        => 'prefix',
          :expiration_time                      => 3600,
          :backend                              => 'oslo_cache.memcache_pool',
          :proxies                              => ['proxy01:8888', 'proxy02:8888'],
          :enabled                              => true,
          :debug_cache_backend                  => false,
          :memcache_servers                     => ['memcached01:11211', 'memcached02:11211'],
          :memcache_dead_retry                  => '60',
          :memcache_socket_timeout              => '300.0',
          :memcache_pool_maxsize                => '10',
          :memcache_pool_unused_timeout         => '120',
          :memcache_pool_connection_get_timeout => '360',
          :tls_enabled                          => false,
          :manage_backend_package               => false,
        }
      end

      it 'configures cache' do
        is_expected.to contain_oslo__cache('nova_config').with(
          :config_prefix                        => 'prefix',
          :expiration_time                      => 3600,
          :backend                              => 'oslo_cache.memcache_pool',
          :backend_argument                     => '<SERVICE DEFAULT>',
          :proxies                              => ['proxy01:8888', 'proxy02:8888'],
          :enabled                              => true,
          :debug_cache_backend                  => false,
          :memcache_servers                     => ['memcached01:11211', 'memcached02:11211'],
          :memcache_dead_retry                  => '60',
          :memcache_socket_timeout              => '300.0',
          :memcache_pool_maxsize                => '10',
          :memcache_pool_unused_timeout         => '120',
          :memcache_pool_connection_get_timeout => '360',
          :tls_enabled                          => false,
          :tls_cafile                           => '<SERVICE DEFAULT>',
          :tls_certfile                         => '<SERVICE DEFAULT>',
          :tls_keyfile                          => '<SERVICE DEFAULT>',
          :tls_allowed_ciphers                  => '<SERVICE DEFAULT>',
          :manage_backend_package               => false,
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

      it_configures 'nova::cache'
    end
  end

end
