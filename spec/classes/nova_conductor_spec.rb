require 'spec_helper'

describe 'nova::conductor' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova-conductor' do


    it { is_expected.to contain_package('nova-conductor').with(
      :name   => platform_params[:conductor_package_name],
      :ensure => 'present'
    ) }

    it { is_expected.to contain_service('nova-conductor').with(
      :name      => platform_params[:conductor_service_name],
      :hasstatus => 'true',
      :ensure    => 'running'
    )}

    context 'with manage_service as false' do
      let :params do
        { :enabled        => true,
          :manage_service => false
        }
      end
      it { is_expected.to contain_service('nova-conductor').without_ensure }
    end

    context 'with package version' do
      let :params do
        { :ensure_package => '2012.1-2' }
      end

      it { is_expected.to contain_package('nova-conductor').with(
        :ensure => params[:ensure_package]
      )}
    end

    context 'with overriden workers parameter' do
      let :params do
        {:workers => '5' }
      end
      it { is_expected.to contain_nova_config('conductor/workers').with_value('5') }
    end

    context 'with default database parameters' do
      let :pre_condition do
        "include nova"
      end

      it { is_expected.to_not contain_nova_config('database/connection') }
      it { is_expected.to_not contain_nova_config('database/slave_connection') }
      it { is_expected.to_not contain_nova_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
    end

    context 'with overridden database parameters' do
      let :pre_condition do
        "class { 'nova':
           database_connection   => 'mysql://user:pass@db/db',
           slave_connection      => 'mysql://user:pass@slave/db',
           database_idle_timeout => '30',
         }
        "
      end

      it { is_expected.to contain_nova_config('database/connection').with_value('mysql://user:pass@db/db').with_secret(true) }
      it { is_expected.to contain_nova_config('database/slave_connection').with_value('mysql://user:pass@slave/db').with_secret(true) }
      it { is_expected.to contain_nova_config('database/idle_timeout').with_value('30') }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :conductor_package_name => 'nova-conductor',
            :conductor_service_name => 'nova-conductor' }
        when 'RedHat'
          { :conductor_package_name => 'openstack-nova-conductor',
            :conductor_service_name => 'openstack-nova-conductor' }
        end
      end
      it_configures 'nova-conductor'
    end
  end

end
