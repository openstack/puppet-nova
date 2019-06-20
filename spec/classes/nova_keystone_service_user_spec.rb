require 'spec_helper'

describe 'nova::keystone::service_user' do

  let :params do
    { :password => 'nova_password', }
  end

  shared_examples 'nova service_user' do

    context 'with default parameters' do

      it 'configure service_user' do
        is_expected.to contain_nova_config('service_user/username').with_value('nova')
        is_expected.to contain_nova_config('service_user/password').with_value('nova_password')
        is_expected.to contain_nova_config('service_user/auth_url').with_value('http://127.0.0.1:5000/')
        is_expected.to contain_nova_config('service_user/project_name').with_value('services')
        is_expected.to contain_nova_config('service_user/user_domain_name').with_value('Default')
        is_expected.to contain_nova_config('service_user/project_domain_name').with_value('Default')
        is_expected.to contain_nova_config('service_user/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('service_user/send_service_user_token').with_value(false)
        is_expected.to contain_nova_config('service_user/auth_type').with_value('password')
        is_expected.to contain_nova_config('service_user/auth_version').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('service_user/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('service_user/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('service_user/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('service_user/region_name').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :username                             => 'myuser',
          :password                             => 'mypasswd',
          :auth_url                             => 'http://:127.0.0.1:5000',
          :project_name                         => 'service_project',
          :user_domain_name                     => 'domainX',
          :project_domain_name                  => 'domainX',
          :send_service_user_token              => true,
          :insecure                             => false,
          :auth_type                            => 'password',
          :auth_version                         => 'v3',
          :cafile                               => '/opt/stack/data/cafile.pem',
          :certfile                             => 'certfile.crt',
          :keyfile                              => 'keyfile',
          :region_name                          => 'region2',
        })
      end

      it 'configure service_user' do
        is_expected.to contain_nova_config('service_user/username').with_value(params[:username])
        is_expected.to contain_nova_config('service_user/password').with_value(params[:password]).with_secret(true)
        is_expected.to contain_nova_config('service_user/auth_url').with_value(params[:auth_url])
        is_expected.to contain_nova_config('service_user/project_name').with_value(params[:project_name])
        is_expected.to contain_nova_config('service_user/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_nova_config('service_user/project_domain_name').with_value(params[:project_domain_name])
        is_expected.to contain_nova_config('service_user/send_service_user_token').with_value(params[:send_service_user_token])
        is_expected.to contain_nova_config('service_user/insecure').with_value(params[:insecure])
        is_expected.to contain_nova_config('service_user/auth_type').with_value(params[:auth_type])
        is_expected.to contain_nova_config('service_user/auth_version').with_value(params[:auth_version])
        is_expected.to contain_nova_config('service_user/cafile').with_value(params[:cafile])
        is_expected.to contain_nova_config('service_user/certfile').with_value(params[:certfile])
        is_expected.to contain_nova_config('service_user/keyfile').with_value(params[:keyfile])
        is_expected.to contain_nova_config('service_user/region_name').with_value(params[:region_name])
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

      it_behaves_like 'nova service_user'
    end
  end

end
