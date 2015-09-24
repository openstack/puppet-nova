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

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'nova::db'
  end

  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'nova::db'
  end

end
