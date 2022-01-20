require 'spec_helper'

describe 'nova::keystone' do

  shared_examples 'nova::keystone' do

    let :params do
      {
        :password => 's3cr3t'
      }
    end

    context 'with required parameters' do
      it 'configures keystone in nova.conf' do
        should contain_nova_config('keystone/password').with_value('s3cr3t').with_secret(true)
        should contain_nova_config('keystone/auth_type').with_value('password')
        should contain_nova_config('keystone/auth_url').with_value('http://127.0.0.1:5000')
        should contain_nova_config('keystone/timeout').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('keystone/service_type').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('keystone/valid_interfaces').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('keystone/endpoint_override').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('keystone/region_name').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('keystone/project_name').with_value('services')
        should contain_nova_config('keystone/project_domain_name').with_value('Default')
        should contain_nova_config('keystone/username').with_value('nova')
        should contain_nova_config('keystone/user_domain_name').with_value('Default')
      end

    end

    context 'with parameters' do
      before do
        params.merge!({
          :auth_type           => 'v3password',
          :auth_url            => 'http://10.0.0.10:5000/',
          :timeout             => 60,
          :service_type        => 'identity',
          :valid_interfaces    => ['internal', 'public'],
          :endpoint_override   => 'http://10.0.0.11:5000/',
          :region_name         => 'RegionOne',
          :project_name        => 'alt_service',
          :project_domain_name => 'DomainX',
          :username            => 'alt_nova',
          :user_domain_name    => 'DomainY',
        })
      end

      it 'configures keystone in nova.conf' do
        should contain_nova_config('keystone/password').with_value('s3cr3t').with_secret(true)
        should contain_nova_config('keystone/auth_type').with_value('v3password')
        should contain_nova_config('keystone/auth_url').with_value('http://10.0.0.10:5000/')
        should contain_nova_config('keystone/timeout').with_value(60)
        should contain_nova_config('keystone/service_type').with_value('identity')
        should contain_nova_config('keystone/valid_interfaces').with_value('internal,public')
        should contain_nova_config('keystone/endpoint_override').with_value('http://10.0.0.11:5000/')
        should contain_nova_config('keystone/region_name').with_value('RegionOne')
        should contain_nova_config('keystone/project_name').with_value('alt_service')
        should contain_nova_config('keystone/project_domain_name').with_value('DomainX')
        should contain_nova_config('keystone/username').with_value('alt_nova')
        should contain_nova_config('keystone/user_domain_name').with_value('DomainY')
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

      it_behaves_like 'nova::keystone'
    end
  end
end
