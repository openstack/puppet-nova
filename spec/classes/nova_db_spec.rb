require 'spec_helper'

describe 'nova::db' do
  let :params do
    {}
  end

  shared_examples 'nova::db' do
    context 'with default parameters' do
      it { should_not contain_nova_config('database/db_max_retries') }
      it { should_not contain_nova_config('database/connection') }
      it { should_not contain_nova_config('database/slave_connection') }
      it { should_not contain_nova_config('api_database/connection') }
      it { should_not contain_nova_config('api_database/slave_connection') }
      it { should_not contain_nova_config('database/connection_recycle_time') }
      it { should_not contain_nova_config('database/max_pool_size') }
      it { should_not contain_nova_config('database/max_retries') }
      it { should_not contain_nova_config('database/retry_interval') }
      it { should_not contain_nova_config('database/max_overflow') }
      it { should_not contain_nova_config('database/pool_timeout') }
    end

    context 'with overridden parameters' do
      before :each do
        params.merge!(
          :database_connection           => 'mysql+pymysql://user:pass@db/db1',
          :slave_connection              => 'mysql+pymysql://user:pass@slave/db1',
          :api_database_connection       => 'mysql+pymysql://user:pass@db/db2',
          :api_slave_connection          => 'mysql+pymysql://user:pass@slave/db2',
        )
      end

      it { should contain_oslo__db('nova_config').with(
        :connection              => 'mysql+pymysql://user:pass@db/db1',
        :slave_connection        => 'mysql+pymysql://user:pass@slave/db1',
        :db_max_retries          => '<SERVICE DEFAULT>',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
      )}

      it { should contain_nova_config('api_database/connection').with_value('mysql+pymysql://user:pass@db/db2').with_secret(true) }
      it { should contain_nova_config('api_database/slave_connection').with_value('mysql+pymysql://user:pass@slave/db2').with_secret(true) }
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
