require 'spec_helper'

describe 'nova::metadata' do

  let :pre_condition do
    "include nova
     class { 'nova::keystone::authtoken':
       password => 'passw0rd',
     }"
  end

  let :params do
    {}
  end

  shared_examples 'nova-metadata' do

    context 'with default parameters' do

      it { is_expected.to contain_class('nova::keystone::authtoken') }

      it 'configures various stuff' do
        is_expected.to contain_nova_config('api/metadata_cache_expiration').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/local_metadata_per_cell').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/dhcp_domain').with('value' => '<SERVICE DEFAULT>')
      end

      it 'unconfigures neutron_metadata proxy' do
        is_expected.to contain_nova_config('neutron/service_metadata_proxy').with(:value => false)
        is_expected.to contain_nova_config('neutron/metadata_proxy_shared_secret').with(:ensure => 'absent')
      end
    end

    context 'with overridden parameters' do
      before do
        params.merge!({
          :neutron_metadata_proxy_shared_secret        => 'secrete',
          :local_metadata_per_cell                     => true,
          :metadata_cache_expiration                   => 15,
          :dhcp_domain                                 => 'foo',
        })
      end

      it 'configures various stuff' do
        is_expected.to contain_nova_config('api/local_metadata_per_cell').with('value' => true)
        is_expected.to contain_nova_config('api/metadata_cache_expiration').with('value' => '15')
        is_expected.to contain_nova_config('api/dhcp_domain').with('value' => 'foo')
        is_expected.to contain_nova_config('neutron/service_metadata_proxy').with('value' => true)
        is_expected.to contain_nova_config('neutron/metadata_proxy_shared_secret').with('value' => 'secrete').with_secret(true)
      end
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 5 }))
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :nova_api_package => 'nova-api',
            :nova_api_service => 'nova-api' }
        when 'RedHat'
          { :nova_api_package => 'openstack-nova-api',
            :nova_api_service => 'openstack-nova-api' }
        end
      end
      it_behaves_like 'nova-metadata'
    end
  end
end
