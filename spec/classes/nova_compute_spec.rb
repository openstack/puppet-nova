require 'spec_helper'

describe 'nova::compute' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova-compute' do

    context 'with default parameters' do

      it 'installs nova-compute package and service' do
        is_expected.to contain_service('nova-compute').with({
          :name      => platform_params[:nova_compute_service],
          :ensure    => 'running',
          :hasstatus => true,
          :enable    => true,
          :tag       => 'nova-service'
        })
        is_expected.to contain_package('nova-compute').with({
          :name => platform_params[:nova_compute_package],
          :tag  => ['openstack', 'nova-package']
        })
      end

      it { is_expected.to contain_nova_config('DEFAULT/use_cow_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/virt_mkfs').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/update_resources_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/reboot_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/instance_build_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/rescue_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/resize_confirm_window').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/shutdown_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/resume_guests_state_on_host_boot').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to_not contain_nova_config('vnc/novncproxy_base_url') }
      it { is_expected.to contain_nova_config('key_manager/backend').with_value('nova.keymgr.conf_key_mgr.ConfKeyManager') }
      it { is_expected.to contain_nova_config('barbican/barbican_endpoint').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('barbican/barbican_api_version').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('barbican/auth_endpoint').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('glance/verify_glance_signatures').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/max_concurrent_live_migrations').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/sync_power_state_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/sync_power_state_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('compute/consecutive_build_service_disable_threshold').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/reserved_huge_pages').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('compute/live_migration_wait_for_vif_plug').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('compute/max_disk_devices_to_attach').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/default_access_ip_network_name').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/running_deleted_instance_action').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/running_deleted_instance_poll_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/running_deleted_instance_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/compute_monitors').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/default_ephemeral_format').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to_not contain_package('cryptsetup').with( :ensure => 'present' )}

      it { is_expected.to_not contain_package('bridge-utils').with(
        :ensure => 'present',
      ) }

      it { is_expected.to contain_nova_config('DEFAULT/force_raw_images').with(:value => true) }

      it { is_expected.to contain_class('nova::availability_zone') }

      it 'configures vendordata' do
        is_expected.to contain_nova_config('api/vendordata_jsonfile_path').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_providers').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_targets').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_connect_timeout').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_read_timeout').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('api/vendordata_dynamic_failure_fatal').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_type').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/auth_url').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/os_region_name').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/password').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_domain_name').with('value' => 'Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/project_name').with('value' => '<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/user_domain_name').with('value' => 'Default')
        is_expected.to contain_nova_config('vendordata_dynamic_auth/username').with('value' => '<SERVICE DEFAULT>')
      end

      it { is_expected.to contain_nova_config('DEFAULT/heal_instance_info_cache_interval').with_value('60') }

      it 'installs genisoimage package and sets config_drive_format' do
        is_expected.to contain_nova_config('DEFAULT/config_drive_format').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_package('genisoimage').with(
          :ensure => 'present',
        )
        is_expected.to contain_package('genisoimage').that_requires('Anchor[nova::install::begin]')
        is_expected.to contain_package('genisoimage').that_comes_before('Anchor[nova::install::end]')
      end
    end

    context 'with overridden parameters' do
      let :params do
        { :enabled                            => false,
          :ensure_package                     => '2012.1-2',
          :vncproxy_host                      => '127.0.0.1',
          :use_cow_images                     => false,
          :force_raw_images                   => false,
          :virt_mkfs                          => 'windows=mkfs.ntfs --force --fast %(target)s',
          :reserved_host_memory               => '0',
          :heal_instance_info_cache_interval  => '120',
          :config_drive_format                => 'vfat',
          :update_resources_interval          => '300',
          :reboot_timeout                     => '180',
          :instance_build_timeout             => '300',
          :rescue_timeout                     => '120',
          :resize_confirm_window              => '3',
          :shutdown_timeout                   => '100',
          :resume_guests_state_on_host_boot   => true,
          :keymgr_backend                     => 'castellan.key_manager.barbican_key_manager.BarbicanKeyManager',
          :barbican_endpoint                  => 'http://localhost',
          :barbican_api_version               => 'v1',
          :barbican_auth_endpoint             => 'http://127.0.0.1:5000/v3',
          :max_concurrent_live_migrations     => '4',
          :sync_power_state_pool_size         => '10',
          :sync_power_state_interval          => '0',
          :verify_glance_signatures           => true,
          :consecutive_build_service_disable_threshold => '9',
          :live_migration_wait_for_vif_plug   => true,
          :max_disk_devices_to_attach         => 20,
          :default_access_ip_network_name     => 'public',
          :running_deleted_instance_action    => 'shutdown',
          :running_deleted_instance_poll_interval => '900',
          :running_deleted_instance_timeout   => '200',
          :compute_monitors                   => ['cpu.virt_driver','fake'],
          :default_ephemeral_format           => 'ext4',
        }
      end

      it 'installs nova-compute package and service' do
        is_expected.to contain_service('nova-compute').with({
          :name      => platform_params[:nova_compute_service],
          :ensure    => 'stopped',
          :hasstatus => true,
          :enable    => false,
          :tag       => 'nova-service'
        })
        is_expected.to contain_package('nova-compute').with({
          :name   => platform_params[:nova_compute_package],
          :ensure => '2012.1-2',
          :tag    => ['openstack', 'nova-package']
        })
      end

      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/reserved_host_memory_mb').with_value('0')
      end

      it 'configures barbican service' do
        is_expected.to contain_nova_config('key_manager/backend').with_value('castellan.key_manager.barbican_key_manager.BarbicanKeyManager')
        is_expected.to contain_nova_config('barbican/barbican_endpoint').with_value('http://localhost')
        is_expected.to contain_nova_config('barbican/barbican_api_version').with_value('v1')
        is_expected.to contain_nova_config('barbican/auth_endpoint').with_value('http://127.0.0.1:5000/v3')
        is_expected.to contain_package('cryptsetup').with( :ensure => 'present' )
      end

      it 'configures vnc in nova.conf' do
        is_expected.to contain_nova_config('vnc/enabled').with_value(true)
        is_expected.to contain_nova_config('vnc/server_proxyclient_address').with_value('127.0.0.1')
        is_expected.to contain_nova_config('vnc/novncproxy_base_url').with_value(
          'http://127.0.0.1:6080/vnc_auto.html'
        )
      end

      it 'should have spice disabled' do
        is_expected.to contain_nova_config('spice/enabled').with_value(false)
      end

      it { is_expected.to contain_nova_config('DEFAULT/heal_instance_info_cache_interval').with_value('120') }
      it { is_expected.to contain_nova_config('DEFAULT/use_cow_images').with_value(false) }
      it { is_expected.to contain_nova_config('DEFAULT/force_raw_images').with(:value => false) }
      it { is_expected.to contain_nova_config('DEFAULT/virt_mkfs').with_value('windows=mkfs.ntfs --force --fast %(target)s') }
      it { is_expected.to contain_nova_config('DEFAULT/update_resources_interval').with_value('300') }
      it { is_expected.to contain_nova_config('DEFAULT/reboot_timeout').with_value('180') }
      it { is_expected.to contain_nova_config('DEFAULT/instance_build_timeout').with_value('300') }
      it { is_expected.to contain_nova_config('DEFAULT/rescue_timeout').with_value('120') }
      it { is_expected.to contain_nova_config('DEFAULT/resize_confirm_window').with_value('3') }
      it { is_expected.to contain_nova_config('DEFAULT/shutdown_timeout').with_value('100') }
      it { is_expected.to contain_nova_config('DEFAULT/max_concurrent_live_migrations').with_value('4') }

      it { is_expected.to contain_nova_config('DEFAULT/sync_power_state_pool_size').with_value('10') }

      it { is_expected.to contain_nova_config('DEFAULT/sync_power_state_interval').with_value('0') }

      it { is_expected.to contain_nova_config('compute/consecutive_build_service_disable_threshold').with_value('9') }

      it { is_expected.to contain_nova_config('DEFAULT/resume_guests_state_on_host_boot').with_value(true) }
      it { is_expected.to contain_nova_config('glance/verify_glance_signatures').with_value(true) }

      it { is_expected.to contain_nova_config('compute/live_migration_wait_for_vif_plug').with_value(true) }

      it { is_expected.to contain_nova_config('compute/max_disk_devices_to_attach').with_value(20) }
      it { is_expected.to contain_nova_config('DEFAULT/default_access_ip_network_name').with_value('public') }
      it { is_expected.to contain_nova_config('DEFAULT/running_deleted_instance_action').with_value('shutdown') }
      it { is_expected.to contain_nova_config('DEFAULT/running_deleted_instance_poll_interval').with_value('900') }
      it { is_expected.to contain_nova_config('DEFAULT/running_deleted_instance_timeout').with_value('200') }
      it { is_expected.to contain_nova_config('DEFAULT/compute_monitors').with_value('cpu.virt_driver,fake') }
      it { is_expected.to contain_nova_config('DEFAULT/default_ephemeral_format').with_value('ext4') }

      it 'configures nova config_drive_format to vfat' do
        is_expected.to contain_nova_config('DEFAULT/config_drive_format').with_value('vfat')
        is_expected.to_not contain_package('genisoimage').with(
          :ensure => 'present',
        )
      end
    end

    context 'with reserved_huge_pages string' do
      let :params do
        {
            :reserved_huge_pages => "foo"
        }
      end
      it 'configures nova reserved_huge_pages entries' do
        is_expected.to contain_nova_config('DEFAULT/reserved_huge_pages').with(
          'value' => 'foo'
        )
      end
    end

    context 'with reserved_huge_pages array' do
      let :params do
        {
            :reserved_huge_pages => ["foo", "bar"]
        }
      end
      it 'configures nova reserved_huge_pages entries' do
        is_expected.to contain_nova_config('DEFAULT/reserved_huge_pages').with(
          'value' => ['foo','bar']
        )
      end
    end

    context 'should raise an error, when cpu_dedicated_set and vcpu_pin_set both are defined' do
      let :params do
        { :vcpu_pin_set      => ['4-12','^8','15'],
          :cpu_dedicated_set => ['4-12','^8','15'], }
      end

      it { should raise_error(Puppet::Error, /vcpu_pin_set is deprecated. vcpu_pin_set and cpu_dedicated_set are mutually exclusive./) }
    end

    context 'when cpu_shared_set and cpu_dedicated_set both are set, but not vcpu_pin_set' do
      let :params do
        { :cpu_shared_set    => ['4-12','^8','15'],
          :cpu_dedicated_set => ['2-10','^5','14'], }
      end

      it { is_expected.to contain_nova_config('compute/cpu_shared_set').with(:value => '4-12,^8,15') }
      it { is_expected.to contain_nova_config('compute/cpu_dedicated_set').with(:value => '2-10,^5,14') }
      it { is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:ensure => 'absent') }
    end

    context 'when cpu_dedicated_set is defined but cpu_shared_set is not' do
      let :params do
        { :cpu_dedicated_set => ['4-12','^8','15'] }
      end

      it { is_expected.to contain_nova_config('compute/cpu_dedicated_set').with(:value => '4-12,^8,15') }
      it { is_expected.to contain_nova_config('compute/cpu_shared_set').with(:value => '<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:ensure => 'absent') }
    end

    context 'when cpu_shared_set is defined, but cpu_dedicated_set and vcpu_pin_set are not' do
      let :params do
        { :cpu_shared_set => ['4-12', '^8', '15'] }
      end

      it { is_expected.to contain_nova_config('compute/cpu_shared_set').with(:value => '4-12,^8,15') }
      it { is_expected.to contain_nova_config('compute/cpu_dedicated_set').with(:value => '<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:ensure => 'absent') }
    end

    context 'when cpu_shared_set and vcpu_pin_set are defined, but cpu_dedicated_set is not' do
      let :params do
        { :cpu_shared_set => ['4-12','^8','15'],
          :vcpu_pin_set   => ['2-10','^5','14'], }
      end

      it { is_expected.to contain_nova_config('compute/cpu_shared_set').with(:value => '4-12,^8,15') }
      it { is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:value => '2-10,^5,14') }
      it { is_expected.to contain_nova_config('compute/cpu_dedicated_set').with(:value => '<SERVICE DEFAULT>') }
    end

    context 'when vcpu_pin_set is set, but cpu_shared_set and cpu_dedicated_set are not' do
      let :params do
         { :vcpu_pin_set => ['4-12','^8','15'] }
      end

      it { is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:value => '4-12,^8,15') }
      it { is_expected.to contain_nova_config('compute/cpu_shared_set').with(:value => '<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('compute/cpu_dedicated_set').with(:value => '<SERVICE DEFAULT>') }
    end

    context 'when neutron_physnets_numa_nodes_mapping and neutron_tunnel_numa_nodes are empty' do
      let :params do
        { :neutron_physnets_numa_nodes_mapping => {},
          :neutron_tunnel_numa_nodes           => [], }
      end

      it { is_expected.to contain_nova_config('neutron/physnets').with(:ensure => 'absent') }
      it { is_expected.to contain_nova_config('neutron_tunnel/numa_nodes').with(:ensure => 'absent') }
    end

    context 'when neutron_physnets_numa_nodes_mapping and neutron_tunnel_numa_nodes are set to valid values' do
      let :params do
        { :neutron_physnets_numa_nodes_mapping => { 'foo' => [0, 1], 'bar' => [0] },
          :neutron_tunnel_numa_nodes           => 1, }
      end

      it { is_expected.to contain_nova_config('neutron/physnets').with(:value => 'foo,bar') }
      it { is_expected.to contain_nova_config('neutron_physnet_foo/numa_nodes').with(:value => '0,1') }
      it { is_expected.to contain_nova_config('neutron_physnet_bar/numa_nodes').with(:value => '0') }
      it { is_expected.to contain_nova_config('neutron_tunnel/numa_nodes').with(:value => '1') }
    end

    context 'with vnc_enabled set to false and spice_enabled set to true' do
      let :params do
        { :vnc_enabled => false,
          :spice_enabled => true, }
      end

      it 'disables vnc in nova.conf' do
        is_expected.to contain_nova_config('vnc/enabled').with_value(false)
        is_expected.to contain_nova_config('vnc/server_proxyclient_address').with_ensure('absent')
        is_expected.to_not contain_nova_config('vnc/novncproxy_base_url')
      end

      it 'enables spice' do
        is_expected.to contain_nova_config('spice/enabled').with_value(true)
      end
    end

    context 'with vnc_enabled and spice_enabled set to true' do
      let :params do
        { :vnc_enabled   => true,
          :spice_enabled => true, }
      end

      it { should raise_error(Puppet::Error, /vnc_enabled and spice_enabled is mutually exclusive/) }
    end

    context 'with force_config_drive parameter set to true' do
      let :params do
        { :force_config_drive => true }
      end

      it { is_expected.to contain_nova_config('DEFAULT/force_config_drive').with_value(true) }
    end

    context 'while not managing service state' do
      let :params do
        { :enabled           => false,
          :manage_service    => false,
        }
      end

      it { is_expected.to contain_service('nova-compute').without_ensure }
    end

    context 'with instance_usage_audit parameter set to false' do
      let :params do
        { :instance_usage_audit => false, }
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit').with_ensure('absent') }
      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit_period').with_ensure('absent') }
    end

    context 'with instance_usage_audit parameter and wrong period' do
      let :params do
        { :instance_usage_audit        => true,
          :instance_usage_audit_period => 'fake', }
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit').with_ensure('absent') }
      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit_period').with_ensure('absent') }
    end

    context 'with instance_usage_audit parameter and period' do
      let :params do
        { :instance_usage_audit        => true,
          :instance_usage_audit_period => 'year', }
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit').with_value(true) }
      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit_period').with_value('year') }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :nova_compute_package => 'nova-compute',
            :nova_compute_service => 'nova-compute' }
        when 'RedHat'
          { :nova_compute_package => 'openstack-nova-compute',
            :nova_compute_service => 'openstack-nova-compute' }
        end
      end
      it_behaves_like 'nova-compute'
    end
  end

end
