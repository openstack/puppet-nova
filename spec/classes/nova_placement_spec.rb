require 'spec_helper'

describe 'nova::placement' do

  let :default_params do
    { :auth_type           => 'password',
      :project_name        => 'services',
      :project_domain_name => 'Default',
      :os_region_name      => 'RegionOne',
      :username            => 'placement',
      :user_domain_name    => 'Default',
      :auth_url            => 'http://127.0.0.1:35357/v3',
    }
  end

  let :params do
    { :password => 's3cr3t' }
  end

  context 'with required parameters' do
    it 'configures [placement] parameters in nova.conf' do
      is_expected.to contain_nova_config('placement/password').with_value(params[:password]).with_secret(true)
      is_expected.to contain_nova_config('placement/auth_type').with_value(default_params[:auth_type])
      is_expected.to contain_nova_config('placement/project_name').with_value(default_params[:project_name])
      is_expected.to contain_nova_config('placement/project_domain_name').with_value(default_params[:project_domain_name])
      is_expected.to contain_nova_config('placement/os_region_name').with_value(default_params[:os_region_name])
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
        :os_region_name      => 'RegionTwo',
        :username            => 'placement2',
        :user_domain_name    => 'default',
        :auth_url            => 'https://127.0.0.1:35357/v3',
      )
    end

    it 'configures [placement] parameters in nova.conf' do
      is_expected.to contain_nova_config('placement/password').with_value(params[:password]).with_secret(true)
      is_expected.to contain_nova_config('placement/auth_type').with_value(params[:auth_type])
      is_expected.to contain_nova_config('placement/project_name').with_value(params[:project_name])
      is_expected.to contain_nova_config('placement/project_domain_name').with_value(params[:project_domain_name])
      is_expected.to contain_nova_config('placement/os_region_name').with_value(params[:os_region_name])
      is_expected.to contain_nova_config('placement/username').with_value(params[:username])
      is_expected.to contain_nova_config('placement/user_domain_name').with_value(params[:user_domain_name])
      is_expected.to contain_nova_config('placement/auth_url').with_value(params[:auth_url])
    end
  end

end
