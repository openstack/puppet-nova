require 'spec_helper'

describe 'nova::db' do

  let :params do
    {}
  end

  shared_examples 'nova::db' do

    context 'with default parameters' do
      it { is_expected.to_not contain_nova_config('database/db_max_retries') }
      it { is_expected.to_not contain_nova_config('database/connection') }
      it { is_expected.to_not contain_nova_config('database/slave_connection') }
      it { is_expected.to_not contain_nova_config('api_database/connection') }
      it { is_expected.to_not contain_nova_config('api_database/slave_connection') }
      it { is_expected.to_not contain_nova_config('database/idle_timeout') }
      it { is_expected.to_not contain_nova_config('database/min_pool_size') }
      it { is_expected.to_not contain_nova_config('database/max_retries') }
      it { is_expected.to_not contain_nova_config('database/retry_interval') }
    end

    context 'with overriden parameters' do
      before :each do
        params.merge!(
          :database_connection     => 'mysql+pymysql://user:pass@db/db1',
          :slave_connection        => 'mysql+pymysql://user:pass@slave/db1',
          :api_database_connection => 'mysql+pymysql://user:pass@db/db2',
          :api_slave_connection    => 'mysql+pymysql://user:pass@slave/db2',
        )
      end

      it { is_expected.to contain_nova_config('database/db_max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('database/connection').with_value('mysql+pymysql://user:pass@db/db1').with_secret(true) }
      it { is_expected.to contain_nova_config('database/slave_connection').with_value('mysql+pymysql://user:pass@slave/db1').with_secret(true) }
      it { is_expected.to contain_nova_config('api_database/connection').with_value('mysql+pymysql://user:pass@db/db2').with_secret(true) }
      it { is_expected.to contain_nova_config('api_database/slave_connection').with_value('mysql+pymysql://user:pass@slave/db2').with_secret(true) }
      it { is_expected.to contain_nova_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }
    end


    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://nova:nova@localhost/nova', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection     => 'mysql://user:pass@db/db', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'redis://nova:nova@localhost/nova', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection     => 'foo+pymysql://user:pass@db/db', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end
  end

  shared_examples_for 'nova::db RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection   => 'mysql+pymysql://user:pass@db/db', }
      end

      it { is_expected.not_to contain_package('db_backend_package') }
    end
  end

  shared_examples_for 'nova::db Debian' do

    context 'using pymysql driver' do
      let :params do
        { :database_connection   => 'mysql+pymysql://user:pass@db/db', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('db_backend_package').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => ['openstack'],
        )
      end
    end

    context 'with sqlite backend' do
      let :params do
        { :database_connection => 'sqlite:///var/lib/nova/nova.sqlite', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('db_backend_package').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => ['openstack'],
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

      it_configures 'nova::db'
      it_configures "nova::db #{facts[:osfamily]}"
    end
  end

end
