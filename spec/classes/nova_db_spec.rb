require 'spec_helper'

describe 'nova::db' do
  let :params do
    {}
  end

  shared_examples 'nova::db' do
    context 'with default parameters' do
      it { should contain_oslo__db('nova_config').with(
        :connection              => '<SERVICE DEFAULT>',
        :slave_connection        => '<SERVICE DEFAULT>',
        :db_max_retries          => '<SERVICE DEFAULT>',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
        :mysql_enable_ndb        => '<SERVICE DEFAULT>',
      )}
      it { should contain_oslo__db('api_database').with(
        :config                  => 'nova_config',
        :config_group            => 'api_database',
        :connection              => '<SERVICE DEFAULT>',
        :slave_connection        => '<SERVICE DEFAULT>',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
      )}
    end

    context 'with overridden parameters' do
      before :each do
        params.merge!(
          :database_connection                  => 'mysql+pymysql://user:pass@db/db1',
          :slave_connection                     => 'mysql+pymysql://user:pass@slave/db1',
          :database_connection_recycle_time     => '1800',
          :database_max_pool_size               => '30',
          :database_max_retries                 => '20',
          :database_retry_interval              => '15',
          :database_max_overflow                => '5',
          :database_pool_timeout                => '20',
          :database_db_max_retries              => '10',
          :mysql_enable_ndb                     => 'true',
          :api_database_connection              => 'mysql+pymysql://user:pass@db/db2',
          :api_slave_connection                 => 'mysql+pymysql://user:pass@slave/db2',
          :api_database_connection_recycle_time => '600',
          :api_database_max_pool_size           => '20',
          :api_database_max_retries             => '10',
          :api_database_retry_interval          => '5',
          :api_database_max_overflow            => '0',
          :api_database_pool_timeout            => '30',
        )
      end

      it { should contain_oslo__db('nova_config').with(
        :connection              => 'mysql+pymysql://user:pass@db/db1',
        :slave_connection        => 'mysql+pymysql://user:pass@slave/db1',
        :connection_recycle_time => '1800',
        :max_pool_size           => '30',
        :max_retries             => '20',
        :retry_interval          => '15',
        :max_overflow            => '5',
        :pool_timeout            => '20',
        :db_max_retries          => '10',
        :mysql_enable_ndb        => 'true',
      )}

      it { should contain_oslo__db('api_database').with(
        :config                  => 'nova_config',
        :config_group            => 'api_database',
        :connection              => 'mysql+pymysql://user:pass@db/db2',
        :slave_connection        => 'mysql+pymysql://user:pass@slave/db2',
        :connection_recycle_time => '600',
        :max_pool_size           => '20',
        :max_retries             => '10',
        :retry_interval          => '5',
        :max_overflow            => '0',
        :pool_timeout            => '30',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::db'
    end
  end
end
