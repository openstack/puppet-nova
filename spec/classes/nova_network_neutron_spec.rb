require 'spec_helper'

describe 'nova::network::neutron' do
  let :default_params do
    {
      :auth_type               => 'v3password',
      :timeout                 => '30',
      :project_name            => 'services',
      :project_domain_name     => 'Default',
      :region_name             => 'RegionOne',
      :username                => 'neutron',
      :user_domain_name        => 'Default',
      :auth_url                => 'http://127.0.0.1:5000/v3',
      :valid_interfaces        => '<SERVICE DEFAULT>',
      :endpoint_override       => '<SERVICE DEFAULT>',
      :ovs_bridge              => 'br-int',
      :extension_sync_interval => '600',
      :vif_plugging_is_fatal   => true,
      :vif_plugging_timeout    => '300',
      :default_floating_pool   => 'nova',
    }
  end

  let :params do
    {
      :password => 's3cr3t'
    }
  end

  shared_examples 'nova::network::neutron' do
    context 'with required parameters' do
      it 'configures neutron endpoint in nova.conf' do
        should contain_nova_config('neutron/password').with_value(params[:password]).with_secret(true)
        should contain_nova_config('neutron/default_floating_pool').with_value(default_params[:default_floating_pool])
        should contain_nova_config('neutron/auth_type').with_value(default_params[:auth_type])
        should contain_nova_config('neutron/timeout').with_value(default_params[:timeout])
        should contain_nova_config('neutron/project_name').with_value(default_params[:project_name])
        should contain_nova_config('neutron/project_domain_name').with_value(default_params[:project_domain_name])
        should contain_nova_config('neutron/region_name').with_value(default_params[:region_name])
        should contain_nova_config('neutron/username').with_value(default_params[:username])
        should contain_nova_config('neutron/user_domain_name').with_value(default_params[:user_domain_name])
        should contain_nova_config('neutron/auth_url').with_value(default_params[:auth_url])
        should contain_nova_config('neutron/valid_interfaces').with_value(default_params[:valid_interfaces])
        should contain_nova_config('neutron/endpoint_override').with_value(default_params[:endpoint_override])
        should contain_nova_config('neutron/extension_sync_interval').with_value(default_params[:extension_sync_interval])
        should contain_nova_config('neutron/ovs_bridge').with_value(default_params[:ovs_bridge])
      end

      it 'configures neutron vif plugging events in nova.conf' do
        should contain_nova_config('DEFAULT/vif_plugging_is_fatal').with_value(default_params[:vif_plugging_is_fatal])
        should contain_nova_config('DEFAULT/vif_plugging_timeout').with_value(default_params[:vif_plugging_timeout])
      end
    end

    context 'when overriding class parameters' do
      before do
        params.merge!(
          :timeout                 => '30',
          :project_name            => 'openstack',
          :project_domain_name     => 'openstack_domain',
          :region_name             => 'RegionTwo',
          :username                => 'neutron2',
          :user_domain_name        => 'neutron_domain',
          :auth_url                => 'http://10.0.0.1:5000/v2',
          :valid_interfaces        => 'public',
          :endpoint_override       => 'http://127.0.0.1:9696',
          :ovs_bridge              => 'br-int',
          :extension_sync_interval => '600',
          :vif_plugging_is_fatal   => false,
          :vif_plugging_timeout    => '0',
          :default_floating_pool   => 'public'
        )
      end

      it 'configures neutron endpoint in nova.conf' do
        should contain_nova_config('neutron/password').with_value(params[:password]).with_secret(true)
        should contain_nova_config('neutron/default_floating_pool').with_value(params[:default_floating_pool])
        should contain_nova_config('neutron/timeout').with_value(params[:timeout])
        should contain_nova_config('neutron/project_name').with_value(params[:project_name])
        should contain_nova_config('neutron/project_domain_name').with_value(params[:project_domain_name])
        should contain_nova_config('neutron/region_name').with_value(params[:region_name])
        should contain_nova_config('neutron/username').with_value(params[:username])
        should contain_nova_config('neutron/user_domain_name').with_value(params[:user_domain_name])
        should contain_nova_config('neutron/auth_url').with_value(params[:auth_url])
        should contain_nova_config('neutron/valid_interfaces').with_value(params[:valid_interfaces])
        should contain_nova_config('neutron/endpoint_override').with_value(params[:endpoint_override])
        should contain_nova_config('neutron/extension_sync_interval').with_value(params[:extension_sync_interval])
        should contain_nova_config('neutron/ovs_bridge').with_value(params[:ovs_bridge])
      end

      it 'configures neutron vif plugging events in nova.conf' do
        should contain_nova_config('DEFAULT/vif_plugging_is_fatal').with_value(params[:vif_plugging_is_fatal])
        should contain_nova_config('DEFAULT/vif_plugging_timeout').with_value(params[:vif_plugging_timeout])
      end
    end

    context 'when overriding deprecated class parameters' do
      before do
        params.merge!(
          :password                        => false,
          :neutron_password                => 's3cr3t',
          :neutron_timeout                 => '30',
          :neutron_project_name            => 'openstack',
          :neutron_project_domain_name     => 'openstack_domain',
          :neutron_region_name             => 'RegionTwo',
          :neutron_username                => 'neutron2',
          :neutron_user_domain_name        => 'neutron_domain',
          :neutron_auth_url                => 'http://10.0.0.1:5000/v2',
          :neutron_valid_interfaces        => 'public',
          :neutron_endpoint_override       => 'http://127.0.0.1:9696',
          :neutron_ovs_bridge              => 'br-int',
          :neutron_extension_sync_interval => '600',
        )
      end

      it 'configures neutron endpoint in nova.conf' do
        should contain_nova_config('neutron/password').with_value(params[:neutron_password]).with_secret(true)
        should contain_nova_config('neutron/timeout').with_value(params[:neutron_timeout])
        should contain_nova_config('neutron/project_name').with_value(params[:neutron_project_name])
        should contain_nova_config('neutron/project_domain_name').with_value(params[:neutron_project_domain_name])
        should contain_nova_config('neutron/region_name').with_value(params[:neutron_region_name])
        should contain_nova_config('neutron/username').with_value(params[:neutron_username])
        should contain_nova_config('neutron/user_domain_name').with_value(params[:neutron_user_domain_name])
        should contain_nova_config('neutron/auth_url').with_value(params[:neutron_auth_url])
        should contain_nova_config('neutron/valid_interfaces').with_value(params[:neutron_valid_interfaces])
        should contain_nova_config('neutron/endpoint_override').with_value(params[:neutron_endpoint_override])
        should contain_nova_config('neutron/extension_sync_interval').with_value(params[:neutron_extension_sync_interval])
        should contain_nova_config('neutron/ovs_bridge').with_value(params[:neutron_ovs_bridge])
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::network::neutron'
    end
  end
end
