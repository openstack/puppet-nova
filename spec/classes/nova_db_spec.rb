require 'spec_helper'

describe 'nova::db' do

  let :params do
    {}
  end

  shared_examples 'nova::db' do

    context 'with default parameters' do
      it { is_expected.to_not contain_nova_config('database/connection') }
      it { is_expected.to_not contain_nova_config('database/slave_connection') }
      it { is_expected.to_not contain_nova_config('database/idle_timeout') }
      it { is_expected.to_not contain_nova_config('database/min_pool_size') }
      it { is_expected.to_not contain_nova_config('database/max_retries') }
      it { is_expected.to_not contain_nova_config('database/retry_interval') }
    end

    context 'with overriden parameters' do
      before :each do
        params.merge!(
          :database_connection   => 'mysql+pymysql://user:pass@db/db',
          :slave_connection      => 'mysql+pymysql://user:pass@slave/db',
        )
      end

      it { is_expected.to contain_nova_config('database/connection').with_value('mysql+pymysql://user:pass@db/db').with_secret(true) }
      it { is_expected.to contain_nova_config('database/slave_connection').with_value('mysql+pymysql://user:pass@slave/db').with_secret(true) }
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

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie',
      })
    end

    it_configures 'nova::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection   => 'mysql+pymysql://user:pass@db/db', }
      end
      it 'install the proper backend package' do
        is_expected.to contain_package('nova-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => ['openstack', 'nova-package'],
        )
      end
    end

    context 'with sqlite backend' do
      let :params do
        { :database_connection     => 'sqlite:///var/lib/nova/nova.sqlite', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('nova-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => ['openstack', 'nova-package'],
        )
      end

    end
  end

  context 'on Redhat platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'RedHat',
        :operatingsystemrelease => '7.1',
      })
    end

    it_configures 'nova::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection   => 'mysql+pymysql://user:pass@db/db', }
      end

      it { is_expected.not_to contain_package('nova-backend-package') }
    end
  end

end
