require 'spec_helper'

describe 'nova::vendordata' do

  let :pre_condition do
    'include nova'
  end

  let :params do
    {}
  end

  shared_examples 'nova-vendordata' do

    context 'with default parameters' do
      it 'configures various stuff' do
        is_expected.to contain_nova_config('api/vendordata_jsonfile_path').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_providers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_targets').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_connect_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_read_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_failure_fatal').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/os_region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_domain_name').with_value('Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/user_domain_name').with_value('Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/username').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      before do
        params.merge!({
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
        is_expected.to contain_nova_config('api/vendordata_jsonfile_path').with_value('/tmp')
        is_expected.to contain_nova_config('api/vendordata_providers').with_value('StaticJSON,DynamicJSON')
        is_expected.to contain_nova_config('api/vendordata_dynamic_targets').with_value('join@http://127.0.0.1:9999/v1/')
        is_expected.to contain_nova_config('api/vendordata_dynamic_connect_timeout').with_value('30')
        is_expected.to contain_nova_config('api/vendordata_dynamic_read_timeout').with_value('30')
        is_expected.to contain_nova_config('api/vendordata_dynamic_failure_fatal').with_value(false)
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_type').with_value('password')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/os_region_name').with_value('RegionOne')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/password').with_value('secrete').with_secret(true)
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_domain_name').with_value('Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_name').with_value('project')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/user_domain_name').with_value('Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/username').with_value('user')
      end
    end

    context 'when system_scope is set' do
      before do
        params.merge!({
          :vendordata_dynamic_auth_project_name => 'services',
          :vendordata_dynamic_auth_system_scope => 'all'
        })
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/system_scope').with_value('all')
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
      it_behaves_like 'nova-vendordata'
    end
  end
end
