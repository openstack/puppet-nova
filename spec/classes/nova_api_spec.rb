require 'spec_helper'

describe 'nova::api' do

  let :pre_condition do
    'include nova'
  end

  let :params do
    { :admin_password => 'passw0rd' }
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

      it 'configures keystone_authtoken middleware' do
       is_expected.to contain_nova_config(
          'keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/')
       is_expected.to contain_nova_config(
          'keystone_authtoken/auth_url').with_value('http://127.0.0.1:35357/')
        is_expected.to contain_nova_config(
          'keystone_authtoken/project_name').with_value('services')
        is_expected.to contain_nova_config(
          'keystone_authtoken/username').with_value('nova')
        is_expected.to contain_nova_config(
          'keystone_authtoken/password').with_value('passw0rd').with_secret(true)
      end

      it 'enable metadata in evenlet configuration' do
        is_expected.to contain_nova_config('DEFAULT/enabled_apis').with_value('osapi_compute,metadata')
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_name_template').with_ensure('absent')}

      it 'configures various stuff' do
        is_expected.to contain_nova_config('wsgi/api_paste_config').with('value' => 'api-paste.ini')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen').with('value' => '0.0.0.0')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen_port').with('value' => '8774')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen').with('value' => '0.0.0.0')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen_port').with('value' => '8775')
        is_expected.to contain_nova_config('DEFAULT/osapi_volume_listen').with('value' => '0.0.0.0')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_workers').with('value' => '5')
        is_expected.to contain_nova_config('DEFAULT/metadata_workers').with('value' => '5')
        is_expected.to contain_nova_config('DEFAULT/default_floating_pool').with('value' => 'nova')
        is_expected.to contain_nova_config('DEFAULT/fping_path').with('value' => '/usr/sbin/fping')
        is_expected.to contain_nova_config('oslo_middleware/enable_proxy_headers_parsing').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/metadata_cache_expiration').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/vendordata_jsonfile_path').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/vendordata_providers').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/vendordata_dynamic_targets').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/vendordata_dynamic_connect_timeout').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/vendordata_dynamic_read_timeout').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/osapi_max_limit').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_link_prefix').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/osapi_glance_link_prefix').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/osapi_hide_server_address_states').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/allow_instance_snapshots').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/enable_network_quota').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/enable_instance_password').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/password_length').with('value' => '<SERVICE DEFAULT>')
      end

      it 'unconfigures neutron_metadata proxy' do
        is_expected.to contain_nova_config('neutron/service_metadata_proxy').with(:value => false)
        is_expected.to contain_nova_config('neutron/metadata_proxy_shared_secret').with(:ensure => 'absent')
      end
    end

    context 'with overridden parameters' do
      before do
        params.merge!({
          :enabled                              => false,
          :ensure_package                       => '2012.1-2',
          :auth_uri                             => 'https://10.0.0.1:9999/',
          :identity_uri                         => 'https://10.0.0.1:8888/',
          :admin_tenant_name                    => 'service2',
          :admin_user                           => 'nova2',
          :admin_password                       => 'passw0rd2',
          :api_bind_address                     => '192.168.56.210',
          :metadata_listen                      => '127.0.0.1',
          :metadata_listen_port                 => 8875,
          :osapi_compute_listen_port            => 8874,
          :volume_api_class                     => 'nova.volume.cinder.API',
          :use_forwarded_for                    => false,
          :ratelimits                           => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)',
          :neutron_metadata_proxy_shared_secret => 'secrete',
          :osapi_compute_workers                => 1,
          :metadata_workers                     => 2,
          :default_floating_pool                => 'public',
          :enable_proxy_headers_parsing         => true,
          :metadata_cache_expiration            => 15,
          :vendordata_jsonfile_path             => '/tmp',
          :vendordata_providers                 => ['StaticJSON', 'DynamicJSON'],
          :vendordata_dynamic_targets           => ['join@http://127.0.0.1:9999/v1/'],
          :vendordata_dynamic_connect_timeout   => 30,
          :vendordata_dynamic_read_timeout      => 30,
          :osapi_max_limit                      => 1000,
          :osapi_compute_link_prefix            => 'https://10.0.0.1:7777/',
          :osapi_glance_link_prefix             => 'https://10.0.0.1:6666/',
          :osapi_hide_server_address_states     => 'building',
          :allow_instance_snapshots             => true,
          :enable_network_quota                 => false,
          :enable_instance_password             => true,
          :password_length                      => 12,
          :pci_alias                            => "[{\"vendor_id\":\"8086\",\"product_id\":\"0126\",\"name\":\"graphic_card\"},{\"vendor_id\":\"9096\",\"product_id\":\"1520\",\"name\":\"network_card\"}]"
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

      it 'configures keystone_authtoken middleware' do
        is_expected.to contain_nova_config(
          'keystone_authtoken/auth_uri').with_value('https://10.0.0.1:9999/')
        is_expected.to contain_nova_config(
          'keystone_authtoken/auth_url').with_value('https://10.0.0.1:8888/')
        is_expected.to contain_nova_config(
          'keystone_authtoken/project_name').with_value('service2')
        is_expected.to contain_nova_config(
          'keystone_authtoken/username').with_value('nova2')
        is_expected.to contain_nova_config(
          'keystone_authtoken/password').with_value('passw0rd2').with_secret(true)
        is_expected.to contain_nova_paste_api_ini(
          'filter:ratelimit/limits').with_value('(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)')
      end

      it 'configures various stuff' do
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen').with('value' => '192.168.56.210')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_listen_port').with('value' => '8874')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen').with('value' => '127.0.0.1')
        is_expected.to contain_nova_config('DEFAULT/metadata_listen_port').with('value' => '8875')
        is_expected.to contain_nova_config('DEFAULT/osapi_volume_listen').with('value' => '192.168.56.210')
        is_expected.to contain_nova_config('DEFAULT/use_forwarded_for').with('value' => false)
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_workers').with('value' => '1')
        is_expected.to contain_nova_config('DEFAULT/metadata_workers').with('value' => '2')
        is_expected.to contain_nova_config('DEFAULT/default_floating_pool').with('value' => 'public')
        is_expected.to contain_nova_config('DEFAULT/metadata_cache_expiration').with('value' => '15')
        is_expected.to contain_nova_config('DEFAULT/vendordata_jsonfile_path').with('value' => '/tmp')
        is_expected.to contain_nova_config('DEFAULT/vendordata_providers').with('value' => 'StaticJSON,DynamicJSON')
        is_expected.to contain_nova_config('DEFAULT/vendordata_dynamic_targets').with('value' => 'join@http://127.0.0.1:9999/v1/')
        is_expected.to contain_nova_config('DEFAULT/vendordata_dynamic_connect_timeout').with('value' => '30')
        is_expected.to contain_nova_config('DEFAULT/vendordata_dynamic_read_timeout').with('value' => '30')
        is_expected.to contain_nova_config('DEFAULT/osapi_max_limit').with('value' => '1000')
        is_expected.to contain_nova_config('DEFAULT/osapi_compute_link_prefix').with('value' => 'https://10.0.0.1:7777/')
        is_expected.to contain_nova_config('DEFAULT/osapi_glance_link_prefix').with('value' => 'https://10.0.0.1:6666/')
        is_expected.to contain_nova_config('neutron/service_metadata_proxy').with('value' => true)
        is_expected.to contain_nova_config('neutron/metadata_proxy_shared_secret').with('value' => 'secrete')
        is_expected.to contain_nova_config('oslo_middleware/enable_proxy_headers_parsing').with('value' => true)
        is_expected.to contain_nova_config('DEFAULT/osapi_hide_server_address_states').with('value' => 'building')
        is_expected.to contain_nova_config('DEFAULT/allow_instance_snapshots').with('value' => true)
        is_expected.to contain_nova_config('DEFAULT/enable_network_quota').with('value' => false)
        is_expected.to contain_nova_config('DEFAULT/enable_instance_password').with('value' => true)
        is_expected.to contain_nova_config('DEFAULT/password_length').with('value' => '12')
      end

      it 'configures nova pci_alias entries' do
        is_expected.to contain_nova_config('DEFAULT/pci_alias').with(
          'value' => "[{\"vendor_id\":\"8086\",\"product_id\":\"0126\",\"name\":\"graphic_card\"},{\"vendor_id\":\"9096\",\"product_id\":\"1520\",\"name\":\"network_card\"}]"
        )
      end
    end

    context 'while validating the service with default command' do
      before do
        params.merge!({
          :validate => true,
        })
      end
      it { is_expected.to contain_exec('execute nova-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'nova --os-auth-url http://127.0.0.1:5000/ --os-project-name services --os-username nova --os-password passw0rd flavor-list',
      )}

      it { is_expected.to contain_anchor('create nova-api anchor').with(
        :require => 'Exec[execute nova-api validation]',
      )}
    end

    context 'while validating the service with custom command' do
      before do
        params.merge!({
          :validate            => true,
          :validation_options  => { 'nova-api' => { 'command' => 'my-script' } }
        })
      end
      it { is_expected.to contain_exec('execute nova-api validation').with(
        :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        :provider    => 'shell',
        :tries       => '10',
        :try_sleep   => '2',
        :command     => 'my-script',
      )}

      it { is_expected.to contain_anchor('create nova-api anchor').with(
        :require => 'Exec[execute nova-api validation]',
      )}
    end

    context 'while not managing service state' do
      before do
        params.merge!({
          :enabled           => false,
          :manage_service    => false,
        })
      end

      it { is_expected.to contain_service('nova-api').without_ensure }
    end

    context 'with default database parameters' do
      let :pre_condition do
        "include nova"
      end

      it { is_expected.to_not contain_nova_config('database/connection') }
      it { is_expected.to_not contain_nova_config('database/slave_connection') }
      it { is_expected.to_not contain_nova_config('api_database/connection') }
      it { is_expected.to_not contain_nova_config('api_database/slave_connection') }
      it { is_expected.to_not contain_nova_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
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
        "
      end

      it { is_expected.to contain_nova_config('database/connection').with_value('mysql://user:pass@db/db1').with_secret(true) }
      it { is_expected.to contain_nova_config('database/slave_connection').with_value('mysql://user:pass@slave/db1').with_secret(true) }
      it { is_expected.to contain_nova_config('api_database/connection').with_value('mysql://user:pass@db/db2').with_secret(true) }
      it { is_expected.to contain_nova_config('api_database/slave_connection').with_value('mysql://user:pass@slave/db2').with_secret(true) }
      it { is_expected.to contain_nova_config('database/idle_timeout').with_value('30') }
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
        "include ::apache
         include ::nova"
      end

      it 'enable nova API service' do
        is_expected.to contain_service('nova-api').with(
          :ensure     => 'running',
          :name       => platform_params[:nova_api_service],
          :enable     => true,
          :tag        => 'nova-service',
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
        "include ::apache
         include ::nova"
      end

      it 'disable nova API service' do
        is_expected.to contain_service('nova-api').with(
          :ensure     => 'stopped',
          :name       => platform_params[:nova_api_service],
          :enable     => false,
          :tag        => 'nova-service',
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
        "include ::apache
         include ::nova"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :processorcount => 5 }))
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
    end
  end
end
