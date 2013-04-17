require 'spec_helper'

describe 'nova::network::quantum' do

  let :default_params do
    { :quantum_auth_strategy     => 'keystone',
      :quantum_url               => 'http://127.0.0.1:9696',
      :quantum_admin_tenant_name => 'services',
      :quantum_admin_username    => 'quantum',
      :quantum_admin_auth_url    => 'http://127.0.0.1:35357/v2.0'
    }
  end

  let :params do
    { :quantum_admin_password => 's3cr3t' }
  end

  context 'with required parameters' do
    it 'configures quantum endpoint in nova.conf' do
      should contain_nova_config('DEFAULT/quantum_admin_password').with_value(params[:quantum_admin_password])
      should contain_nova_config('DEFAULT/network_api_class').with_value('nova.network.quantumv2.api.API')
      should contain_nova_config('DEFAULT/quantum_auth_strategy').with_value(default_params[:quantum_auth_strategy])
      should contain_nova_config('DEFAULT/quantum_url').with_value(default_params[:quantum_url])
      should contain_nova_config('DEFAULT/quantum_admin_tenant_name').with_value(default_params[:quantum_admin_tenant_name])
      should contain_nova_config('DEFAULT/quantum_admin_username').with_value(default_params[:quantum_admin_username])
      should contain_nova_config('DEFAULT/quantum_admin_auth_url').with_value(default_params[:quantum_admin_auth_url])
    end
  end

  context 'when overriding class parameters' do
    before do
      params.merge!(
        :quantum_url               => 'http://10.0.0.1:9696',
        :quantum_admin_tenant_name => 'openstack',
        :quantum_admin_username    => 'quantum2',
        :quantum_admin_auth_url    => 'http://10.0.0.1:35357/v2.0'
      )
    end

    it 'configures quantum endpoint in nova.conf' do
      should contain_nova_config('DEFAULT/quantum_auth_strategy').with_value(default_params[:quantum_auth_strategy])
      should contain_nova_config('DEFAULT/quantum_admin_password').with_value(params[:quantum_admin_password])
      should contain_nova_config('DEFAULT/network_api_class').with_value('nova.network.quantumv2.api.API')
      should contain_nova_config('DEFAULT/quantum_url').with_value(params[:quantum_url])
      should contain_nova_config('DEFAULT/quantum_admin_tenant_name').with_value(params[:quantum_admin_tenant_name])
      should contain_nova_config('DEFAULT/quantum_admin_username').with_value(params[:quantum_admin_username])
      should contain_nova_config('DEFAULT/quantum_admin_auth_url').with_value(params[:quantum_admin_auth_url])
    end
  end
end
