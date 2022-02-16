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

    it { is_expected.to contain_class('nova::availability_zone') }

    context 'with manage_service as false' do
      let :params do
        {
          :manage_service => false
        }
      end
      it { is_expected.to_not contain_service('nova-conductor') }
    end

    context 'with package version' do
      let :params do
        { :ensure_package => '2012.1-2' }
      end

      it { is_expected.to contain_package('nova-conductor').with(
        :ensure => params[:ensure_package]
      )}
    end

    context 'with overridden workers parameter' do
      let :params do
        {:workers => '5' }
      end
      it { is_expected.to contain_nova_config('conductor/workers').with_value('5') }
    end

    context 'with default enable_new_services parameter' do
      it { is_expected.to contain_nova_config('DEFAULT/enable_new_services').with_value('<SERVICE DEFAULT>') }
    end

    context 'with enable_new_services parameter set to false' do
      let :params do
        { :enable_new_services => false }
      end

      it { is_expected.to contain_nova_config('DEFAULT/enable_new_services').with_value(false) }
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
