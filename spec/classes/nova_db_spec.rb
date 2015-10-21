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
          :database_connection   => 'mysql://user:pass@db/db',
          :slave_connection      => 'mysql://user:pass@slave/db',
        )
      end

      it { is_expected.to contain_nova_config('database/connection').with_value('mysql://user:pass@db/db').with_secret(true) }
      it { is_expected.to contain_nova_config('database/slave_connection').with_value('mysql://user:pass@slave/db').with_secret(true) }
      it { is_expected.to contain_nova_config('database/idle_timeout').with_value('3600') }
      it { is_expected.to contain_nova_config('database/min_pool_size').with_value('1') }
      it { is_expected.to contain_nova_config('database/max_retries').with_value('10') }
      it { is_expected.to contain_nova_config('database/retry_interval').with_value('10') }
    end


    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://nova:nova@localhost/nova', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'redis://nova:nova@localhost/nova', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie',
      }
    end

    it_configures 'nova::db'

    context 'with sqlite backend' do
      let :params do
        { :database_connection     => 'sqlite:///var/lib/nova/nova.sqlite', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('nova-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => 'openstack'
        )
      end

    end
  end

  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'RedHat',
        :operatingsystemrelease => '7.1',
      }
    end

    it_configures 'nova::db'
  end

end
