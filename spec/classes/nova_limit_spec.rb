require 'spec_helper'

describe 'nova::limit' do

  shared_examples_for 'nova::limit' do

    let :params do
      {
        :password => 'nova_password',
      }
    end

    context 'without endpoint_id' do
      it 'configure limit default params' do
        is_expected.to contain_oslo__limit('nova_config').with(
          :endpoint_id           => nil,
          :endpoint_service_name => 'nova',
          :endpoint_service_type => 'compute',
          :endpoint_region_name  => '<SERVICE DEFAULT>',
          :endpoint_interface    => '<SERVICE DEFAULT>',
          :username              => 'nova',
          :password              => 'nova_password',
          :auth_url              => 'http://localhost:5000',
          :project_name          => 'services',
          :user_domain_name      => 'Default',
          :project_domain_name   => 'Default',
          :system_scope          => '<SERVICE DEFAULT>',
          :auth_type             => 'password',
          :service_type          => '<SERVICE DEFAULT>',
          :valid_interfaces      => '<SERVICE DEFAULT>',
          :region_name           => '<SERVICE DEFAULT>',
          :endpoint_override     => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with endpoint_id' do
      before :each do
        params.merge!({
          :endpoint_id => 'b41eeaed-d2ae-4add-9bfd-9ea8ac912d64',
        })
      end

      it 'configure limit default params' do
        is_expected.to contain_oslo__limit('nova_config').with(
          :endpoint_id           => 'b41eeaed-d2ae-4add-9bfd-9ea8ac912d64',
          :endpoint_service_name => nil,
          :endpoint_service_type => nil,
          :endpoint_region_name  => '<SERVICE DEFAULT>',
          :endpoint_interface    => '<SERVICE DEFAULT>',
          :username              => 'nova',
          :password              => 'nova_password',
          :auth_url              => 'http://localhost:5000',
          :project_name          => 'services',
          :user_domain_name      => 'Default',
          :project_domain_name   => 'Default',
          :system_scope          => '<SERVICE DEFAULT>',
          :auth_type             => 'password',
          :service_type          => '<SERVICE DEFAULT>',
          :valid_interfaces      => '<SERVICE DEFAULT>',
          :region_name           => '<SERVICE DEFAULT>',
          :endpoint_override     => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with specific parameters' do
      before :each do
        params.merge!({
          :endpoint_service_name => 'alt_nova',
          :endpoint_service_type => 'alt_compute',
          :endpoint_region_name  => 'regionOne',
          :endpoint_interface    => 'public',
          :username              => 'alt_nova',
          :auth_url              => 'http://192.168.0.1:5000',
          :project_name          => 'alt_services',
          :user_domain_name      => 'domainX',
          :project_domain_name   => 'domainX',
          :system_scope          => 'all',
          :auth_type             => 'v3password',
          :service_type          => 'identity',
          :valid_interfaces      => 'public',
          :region_name           => 'regionOne',
          :endpoint_override     => 'http://192.168.0.2:5000',
        })
      end

      it 'configure limit params' do
        is_expected.to contain_oslo__limit('nova_config').with(
          :endpoint_id           => nil,
          :endpoint_service_name => 'alt_nova',
          :endpoint_service_type => 'alt_compute',
          :endpoint_region_name  => 'regionOne',
          :endpoint_interface    => 'public',
          :username              => 'alt_nova',
          :password              => 'nova_password',
          :auth_url              => 'http://192.168.0.1:5000',
          :project_name          => 'alt_services',
          :user_domain_name      => 'domainX',
          :project_domain_name   => 'domainX',
          :system_scope          => 'all',
          :auth_type             => 'v3password',
          :service_type          => 'identity',
          :valid_interfaces      => 'public',
          :region_name           => 'regionOne',
          :endpoint_override     => 'http://192.168.0.2:5000',
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::limit'
    end
  end

end
