require 'spec_helper'

describe 'nova::api' do

  let :pre_condition do
    "include nova
     class { 'nova::keystone::authtoken':
       password => 'passw0rd',
       params => { 'username' => 'novae' },
     }"
  end

  let :params do
    {}
  end

  shared_examples 'nova-api' do

    context 'with default parameters' do

      it { is_expected.to contain_class('nova::keystone::authtoken') }

      it 'installs nova-api package and service' do
        is_expected.to contain_service('nova-api').with(
          :name      => platform_params[:nova_api_service],
          :ensure    => 'running',
          :hasstatus => true,
          :enable    => true,
          :tag       => 'nova-service',
        )
        is_expected.to contain_package('nova-api').with(
          :name   => platform_params[:nova_api_package],
          :ensure => 'present',
          :tag    => ['openstack', 'nova-package'],
        )
        is_expected.to contain_package('nova-api').that_requires('Anchor[nova::install::begin]')
        is_expected.to contain_package('nova-api').that_notifies('Anchor[nova::install::end]')
      end

      it 'enable metadata in evenlet configuration' do
        is_expected.to contain_nova_config('DEFAULT/enabled_apis').with_value('osapi_compute,metadata')
      end


      it { is_expected.to contain_class('nova::availability_zone') }

      it 'configures various stuff' do
        is_expected.to contain_nova_config('wsgi/api_paste_config').with_value('api-paste.ini')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen_port').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen_port').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_workers').with_value('5')
        is_expected.to contain_nova_config('DEFAULT/metadata_workers').with_value('5')
        is_expected.to contain_oslo__middleware('nova_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
          :max_request_body_size        => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_nova_config('api/max_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/compute_link_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/glance_link_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/hide_server_address_states').with_ensure('absent')
        is_expected.to contain_nova_config('api/allow_instance_snapshots').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/enable_network_quota').with_ensure('absent')
        is_expected.to contain_nova_config('api/enable_instance_password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/password_length').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/allow_resize_to_same_host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/instance_list_per_project_cells').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/instance_list_cells_batch_strategy').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/instance_list_cells_batch_fixed_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/list_records_by_skipping_down_cells').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      before do
        params.merge!({
          :enabled                              => false,
          :ensure_package                       => '2012.1-2',
          :api_bind_address                     => '192.168.56.210',
          :metadata_listen                      => '127.0.0.1',
          :metadata_listen_port                 => 8875,
          :osapi_compute_listen_port            => 8874,
          :osapi_compute_workers                => 1,
          :metadata_workers                     => 2,
          :enable_proxy_headers_parsing         => true,
          :max_request_body_size                => '102400',
          :max_limit                            => 1000,
          :compute_link_prefix                  => 'https://10.0.0.1:7777/',
          :glance_link_prefix                   => 'https://10.0.0.1:6666/',
          :enable_instance_password             => true,
          :password_length                      => 12,
          :allow_resize_to_same_host            => true,
          :instance_list_per_project_cells      => false,
          :instance_list_cells_batch_strategy   => 'distributed',
          :instance_list_cells_batch_fixed_size => 100,
          :list_records_by_skipping_down_cells  => true,
        })
      end

      it 'installs nova-api package and service' do
        is_expected.to contain_package('nova-api').with(
          :name   => platform_params[:nova_api_package],
          :ensure => '2012.1-2',
          :tag    => ['openstack', 'nova-package'],
        )
        is_expected.to contain_service('nova-api').with(
          :name      => platform_params[:nova_api_service],
          :ensure    => 'stopped',
          :hasstatus => true,
          :enable    => false,
          :tag       => 'nova-service',
        )
      end

      it 'configures various stuff' do
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen').with_value('192.168.56.210')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen_port').with_value('8874')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen').with_value('127.0.0.1')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen_port').with_value('8875')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_workers').with_value('1')
        is_expected.to contain_nova_config('DEFAULT/metadata_workers').with_value('2')
        is_expected.to contain_nova_config('api/max_limit').with_value('1000')
        is_expected.to contain_nova_config('api/compute_link_prefix').with_value('https://10.0.0.1:7777/')
        is_expected.to contain_nova_config('api/glance_link_prefix').with_value('https://10.0.0.1:6666/')
        is_expected.to contain_oslo__middleware('nova_config').with(
          :enable_proxy_headers_parsing => true,
          :max_request_body_size        => '102400',
        )
        is_expected.to contain_nova_config('api/enable_instance_password').with_value(true)
        is_expected.to contain_nova_config('DEFAULT/password_length').with_value('12')
        is_expected.to contain_nova_config('DEFAULT/allow_resize_to_same_host').with_value(true)
        is_expected.to contain_nova_config('api/instance_list_per_project_cells').with_value(false)
        is_expected.to contain_nova_config('api/instance_list_cells_batch_strategy').with_value('distributed')
        is_expected.to contain_nova_config('api/instance_list_cells_batch_fixed_size').with_value(100)
        is_expected.to contain_nova_config('api/list_records_by_skipping_down_cells').with_value(true)
      end
    end

    context 'while not managing service state' do
      before do
        params.merge!({
          :manage_service => false,
        })
      end

      it { is_expected.to_not contain_service('nova-api') }
    end

    context 'when running nova API in wsgi for compute' do
      before do
        params.merge!({
          :service_name => 'httpd',
        })
      end

      let :pre_condition do
        "include apache
         include nova
         class { 'nova::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it 'disable nova API service' do
        is_expected.to contain_service('nova-api').with(
          :ensure => 'stopped',
          :name   => platform_params[:nova_api_service],
          :enable => false,
          :tag    => 'nova-service',
        )
        is_expected.to contain_nova_config('DEFAULT/enabled_apis').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_workers').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen_port').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/metadata_workers').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen_port').with_ensure('absent')
      end

    end

    context 'when service_name is not valid' do
      before do
        params.merge!({ :service_name   => 'foobar' })
      end

      let :pre_condition do
        "include apache
         include nova
         class { 'nova::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

  end

  shared_examples 'nova-api on Debian' do
    context 'with default parameters' do
      it { is_expected.to contain_service('nova-api-metadata').with(
        :name      => 'nova-api-metadata',
        :ensure    => 'running',
        :hasstatus => true,
        :enable    => true,
        :tag       => 'nova-service',
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
        case facts[:os]['family']
        when 'Debian'
          { :nova_api_package => 'nova-api',
            :nova_api_service => 'nova-api' }
        when 'RedHat'
          { :nova_api_package => 'openstack-nova-api',
            :nova_api_service => 'openstack-nova-api' }
        end
      end
      it_behaves_like 'nova-api'
      if facts[:os]['name'] == 'Debian'
        it_behaves_like 'nova-api on Debian'
      end
    end
  end
end
