require 'spec_helper'

describe 'nova::placement' do

  let :default_params do
    { :auth_type           => 'password',
      :project_name        => 'services',
      :project_domain_name => 'Default',
      :region_name         => 'RegionOne',
      :username            => 'placement',
      :user_domain_name    => 'Default',
      :auth_url            => 'http://127.0.0.1:5000/v3',
    }
  end

  let :params do
    { :password => 's3cr3t' }
  end

  shared_examples 'nova::placement' do

    context 'with required parameters' do
      it 'configures [placement] parameters in nova.conf' do
        is_expected.to contain_nova_config('placement/password').with_value(params[:password]).with_secret(true)
        is_expected.to contain_nova_config('placement/auth_type').with_value(default_params[:auth_type])
        is_expected.to contain_nova_config('placement/project_name').with_value(default_params[:project_name])
        is_expected.to contain_nova_config('placement/project_domain_name').with_value(default_params[:project_domain_name])
        is_expected.to contain_nova_config('placement/region_name').with_value(default_params[:region_name])
        is_expected.to contain_nova_config('placement/valid_interfaces').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('placement/username').with_value(default_params[:username])
        is_expected.to contain_nova_config('placement/user_domain_name').with_value(default_params[:user_domain_name])
        is_expected.to contain_nova_config('placement/auth_url').with_value(default_params[:auth_url])
      end
    end

    context 'when overriding class parameters' do
      before do
        params.merge!(
          :auth_type           => 'password',
          :project_name        => 'service',
          :project_domain_name => 'default',
          :region_name         => 'RegionTwo',
          :valid_interfaces    => 'internal,public',
          :username            => 'placement2',
          :user_domain_name    => 'default',
          :auth_url            => 'https://127.0.0.1:5000/v3',
        )
      end

      it 'configures [placement] parameters in nova.conf' do
        is_expected.to contain_nova_config('placement/password').with_value(params[:password]).with_secret(true)
        is_expected.to contain_nova_config('placement/auth_type').with_value(params[:auth_type])
        is_expected.to contain_nova_config('placement/project_name').with_value(params[:project_name])
        is_expected.to contain_nova_config('placement/project_domain_name').with_value(params[:project_domain_name])
        is_expected.to contain_nova_config('placement/region_name').with_value(params[:region_name])
        is_expected.to contain_nova_config('placement/valid_interfaces').with_value(params[:valid_interfaces])
        is_expected.to contain_nova_config('placement/username').with_value(params[:username])
        is_expected.to contain_nova_config('placement/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_nova_config('placement/auth_url').with_value(params[:auth_url])
      end
    end

    context 'when valid_interfaces is an array' do
      before do
        params.merge!(
          :valid_interfaces => ['internal', 'public']
        )
      end

      it 'configures the valid_interfaces parameter with a commma-separated string' do
        is_expected.to contain_nova_config('placement/valid_interfaces').with_value('internal,public')
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
      it_behaves_like 'nova::placement'
    end
  end
end
