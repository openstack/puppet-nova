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
      it { is_expected.to contain_class('cinder::client').that_notifies('Nova::Generic_service[api]') }

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
        is_expected.to_not contain_exec('validate_nova_api')
      end

      it 'enable metadata in evenlet configuration' do
        is_expected.to contain_nova_config('DEFAULT/enabled_apis').with_value('osapi_compute,metadata')
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_name_template').with_ensure('absent')}

      it { is_expected.to contain_class('nova::availability_zone') }

      it 'configures various stuff' do
        is_expected.to contain_nova_config('wsgi/api_paste_config').with('value' => 'api-paste.ini')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen').with('value' => '0.0.0.0')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen_port').with('value' => '8774')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen').with('value' => '0.0.0.0')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen_port').with('value' => '8775')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_workers').with('value' => '5')
        is_expected.to contain_nova_config('DEFAULT/metadata_workers').with('value' => '5')
        is_expected.to contain_oslo__middleware('nova_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
          :max_request_body_size        => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_nova_config('api/max_limit').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/compute_link_prefix').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/glance_link_prefix').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/hide_server_address_states').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/allow_instance_snapshots').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/enable_network_quota').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/enable_instance_password').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/password_length').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/allow_resize_to_same_host').with('value' => false)
      end
    end

    context 'with overridden parameters' do
      before do
        params.merge!({
          :enabled                      => false,
          :ensure_package               => '2012.1-2',
          :api_bind_address             => '192.168.56.210',
          :metadata_listen              => '127.0.0.1',
          :metadata_listen_port         => 8875,
          :osapi_compute_listen_port    => 8874,
          :use_forwarded_for            => false,
          :ratelimits                   => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)',
          :osapi_compute_workers        => 1,
          :metadata_workers             => 2,
          :enable_proxy_headers_parsing => true,
          :max_request_body_size        => '102400',
          :max_limit                    => 1000,
          :compute_link_prefix          => 'https://10.0.0.1:7777/',
          :glance_link_prefix           => 'https://10.0.0.1:6666/',
          :hide_server_address_states   => 'building',
          :allow_instance_snapshots     => true,
          :enable_network_quota         => false,
          :enable_instance_password     => true,
          :password_length              => 12,
          :allow_resize_to_same_host    => true,
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
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen').with('value' => '192.168.56.210')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen_port').with('value' => '8874')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen').with('value' => '127.0.0.1')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen_port').with('value' => '8875')
        is_expected.to contain_nova_config('api/use_forwarded_for').with('value' => false)
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_workers').with('value' => '1')
        is_expected.to contain_nova_config('DEFAULT/metadata_workers').with('value' => '2')
        is_expected.to contain_nova_config('api/max_limit').with('value' => '1000')
        is_expected.to contain_nova_config('api/compute_link_prefix').with('value' => 'https://10.0.0.1:7777/')
        is_expected.to contain_nova_config('api/glance_link_prefix').with('value' => 'https://10.0.0.1:6666/')
        is_expected.to contain_oslo__middleware('nova_config').with(
          :enable_proxy_headers_parsing => true,
          :max_request_body_size        => '102400',
        )
        is_expected.to contain_nova_config('api/hide_server_address_states').with('value' => 'building')
        is_expected.to contain_nova_config('api/allow_instance_snapshots').with('value' => true)
        is_expected.to contain_nova_config('DEFAULT/enable_network_quota').with('value' => false)
        is_expected.to contain_nova_config('api/enable_instance_password').with('value' => true)
        is_expected.to contain_nova_config('DEFAULT/password_length').with('value' => '12')
        is_expected.to contain_nova_config('DEFAULT/allow_resize_to_same_host').with('value' => true)
      end
    end

    context 'while validating the service with default command' do
      before do
        params.merge!({
          :validate => true,
        })
      end
      it { is_expected.to contain_openstacklib__service_validation('nova-api').with(
        :command   => 'nova --os-auth-url http://127.0.0.1:5000/ --os-project-name services --os-username novae --os-password passw0rd flavor-list',
        :subscribe => 'Service[nova-api]',
      )}

    end

    context 'while validating the service with custom command' do
      before do
        params.merge!({
          :validate            => true,
          :validation_options  => { 'nova-api' => { 'command' => 'my-script' } }
        })
      end
      it { is_expected.to contain_openstacklib__service_validation('nova-api').with(
        :command   => 'my-script',
        :subscribe => 'Service[nova-api]',
      )}
    end

    context 'while not managing service state' do
      before do
        params.merge!({
          :enabled        => false,
          :manage_service => false,
        })
      end

      it { is_expected.to contain_service('nova-api').without_ensure }
    end

    context 'with default database parameters' do
      let :pre_condition do
        "include nova
         class { 'nova::keystone::authtoken':
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
         class { 'nova::keystone::authtoken':
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

    context 'with custom instance_name_template' do
      before do
        params.merge!({
          :instance_name_template => 'instance-%08x',
        })
      end
      it 'configures instance_name_template' do
        is_expected.to contain_nova_config('DEFAULT/instance_name_template').with_value('instance-%08x');
      end
    end

    context 'when running nova API in wsgi compute, and enabling metadata' do
      before do
        params.merge!({ :service_name => 'httpd' })
      end

      let :pre_condition do
        "include apache
         include nova
         class { 'nova::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it 'enable nova API service' do
        is_expected.to contain_service('nova-api').with(
          :ensure => 'running',
          :name   => platform_params[:nova_api_service],
          :enable => true,
          :tag    => 'nova-service',
        )
      end
      it 'enable metadata in evenlet configuration' do
        is_expected.to contain_nova_config('DEFAULT/enabled_apis').with_value('metadata')
      end
    end

    context 'when running nova API in wsgi for compute, and disabling metadata' do
      before do
        params.merge!({
          :service_name => 'httpd',
          :enabled_apis => ['osapi_compute'] })
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
      end
    end

    context 'when running nova API in wsgi for compute, and metadata in wsgi' do
      before do
        params.merge!({
          :service_name => 'httpd',
          :nova_metadata_wsgi_enabled => true })
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
      end

    end

    context 'when disabling cinder client installation' do
      before do
        params.merge!({ :install_cinder_client => false })
      end

      it { is_expected.to_not contain_class('cinder::client') }
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
      it { is_expected.to contain_service('nova-api- metadata').with(
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
        case facts[:osfamily]
        when 'Debian'
          { :nova_api_package => 'nova-api',
            :nova_api_service => 'nova-api' }
        when 'RedHat'
          { :nova_api_package => 'openstack-nova-api',
            :nova_api_service => 'openstack-nova-api' }
        end
      end
      it_behaves_like 'nova-api'
      if facts[:os_package_type] == 'debian'
        it_behaves_like 'nova-api on Debian'
      end
    end
  end
end
