require 'spec_helper'

describe 'nova::metadata' do

  let :pre_condition do
    "include nova
     class { '::nova::keystone::authtoken':
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
        is_expected.to contain_nova_config('DEFAULT/enabled_apis').with('value' => 'metadata')
        is_expected.to contain_nova_config('api/metadata_cache_expiration').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_oslo__middleware('nova_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_nova_config('api/metadata_cache_expiration').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/local_metadata_per_cell').with('value' => '<SERVICE DEFAULT>')
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
          :enable_proxy_headers_parsing                => true,
          :local_metadata_per_cell                     => true,
          :metadata_cache_expiration                   => 15,
          :vendordata_jsonfile_path                    => '/tmp',
          :vendordata_providers                        => ['StaticJSON', 'DynamicJSON'],
          :vendordata_dynamic_targets                  => ['join@http://127.0.0.1:9999/v1/'],
          :vendordata_dynamic_connect_timeout          => 30,
          :vendordata_dynamic_read_timeout             => 30,
          :vendordata_dynamic_failure_fatal            => false,
          :vendordata_dynamic_auth_auth_type           => 'password',
          :vendordata_dynamic_auth_auth_url            => 'http://127.0.0.1:5000',
          :vendordata_dynamic_auth_os_region_name      => 'RegionOne',
          :vendordata_dynamic_auth_password            => 'secrete',
          :vendordata_dynamic_auth_project_domain_name => 'Default',
          :vendordata_dynamic_auth_project_name        => 'project',
          :vendordata_dynamic_auth_user_domain_name    => 'Default',
          :vendordata_dynamic_auth_username            => 'user',
        })
      end

      it 'configures various stuff' do
        is_expected.to contain_nova_config('api/local_metadata_per_cell').with('value' => true)
        is_expected.to contain_nova_config('api/metadata_cache_expiration').with('value' => '15')
        is_expected.to contain_nova_config('api/vendordata_jsonfile_path').with('value' => '/tmp')
        is_expected.to contain_nova_config('api/vendordata_providers').with('value' => 'StaticJSON,DynamicJSON')
        is_expected.to contain_nova_config('api/vendordata_dynamic_targets').with('value' => 'join@http://127.0.0.1:9999/v1/')
        is_expected.to contain_nova_config('api/vendordata_dynamic_connect_timeout').with('value' => '30')
        is_expected.to contain_nova_config('api/vendordata_dynamic_read_timeout').with('value' => '30')
        is_expected.to contain_nova_config('api/vendordata_dynamic_failure_fatal').with('value' => false)
        is_expected.to contain_nova_config('neutron/service_metadata_proxy').with('value' => true)
        is_expected.to contain_nova_config('neutron/metadata_proxy_shared_secret').with('value' => 'secrete').with_secret(true)
        is_expected.to contain_oslo__middleware('nova_config').with(
          :enable_proxy_headers_parsing => true,
        )
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_type').with('value' => 'password')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_url').with('value' => 'http://127.0.0.1:5000')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/os_region_name').with('value' => 'RegionOne')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/password').with('value' => 'secrete').with_secret(true)
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_domain_name').with('value' => 'Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_name').with('value' => 'project')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/user_domain_name').with('value' => 'Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/username').with('value' => 'user')
      end
    end

    context 'with default database parameters' do
      let :pre_condition do
        "include nova
         class { '::nova::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it { is_expected.to_not contain_nova_config('database/connection') }
      it { is_expected.to_not contain_nova_config('database/slave_connection') }
      it { is_expected.to_not contain_nova_config('api_database/connection') }
      it { is_expected.to_not contain_nova_config('api_database/slave_connection') }
      it { is_expected.to_not contain_nova_config('database/connection_recycle_time').with_value('<SERVICE DEFAULT>') }
    end

    context 'with overridden database parameters' do
      let :pre_condition do
        "class { 'nova':
           database_connection     => 'mysql://user:pass@db/db1',
           slave_connection        => 'mysql://user:pass@slave/db1',
           api_database_connection => 'mysql://user:pass@db/db2',
           api_slave_connection    => 'mysql://user:pass@slave/db2',
           database_idle_timeout   => '30',
         }
         class { '::nova::keystone::authtoken':
           password => 'passw0rd',
         }
        "
      end

      it { is_expected.to contain_nova_config('api_database/connection').with_value('mysql://user:pass@db/db2').with_secret(true) }
      it { is_expected.to contain_nova_config('api_database/slave_connection').with_value('mysql://user:pass@slave/db2').with_secret(true) }
      it { is_expected.to contain_oslo__db('nova_config').with(
        :connection              => 'mysql://user:pass@db/db1',
        :slave_connection        => 'mysql://user:pass@slave/db1',
        :connection_recycle_time => '30',
      )}
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
        case facts[:osfamily]
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
