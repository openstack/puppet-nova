require 'spec_helper'

describe 'nova::compute::xenserver' do

  let :params do
    { :connection_url      => 'https://127.0.0.1',
      :connection_username => 'root',
      :connection_password => 'passw0rd' }
  end

  let :optional_params do
    { :ovs_integration_bridge                => 'xapi1',
      :agent_timeout                         => '30',
      :agent_version_timeout                 => '300',
      :agent_resetnetwork_timeout            => '60',
      :agent_path                            => '/usr/sbin/xe-update-guest-attrs',
      :disable_agent                         => 'false',
      :use_agent_default                     => 'false',
      :login_timeout                         => '10',
      :connection_concurrent                 => '5',
      :vhd_coalesce_poll_interval            => '5.0',
      :check_host                            => 'true',
      :vhd_coalesce_max_attempts             => '20',
      :sr_base_path                          => '/var/run/sr-mount',
      :target_host                           => '127.0.0.1',
      :target_port                           => '3260',
      :iqn_prefix                            => 'iqn.2010-10.org.openstack',
      :remap_vbd_dev                         => 'false',
      :remap_vbd_dev_prefix                  => 'sd',
      :torrent_base_url                      => 'http://127.0.0.1/',
      :torrent_seed_chance                   => '1.0',
      :torrent_seed_duration                 => '3600',
      :torrent_max_last_accessed             => '86400',
      :torrent_listen_port_start             => '6881',
      :torrent_listen_port_end               => '6891',
      :torrent_download_stall_cutoff         => '600',
      :torrent_max_seeder_processes_per_host => '1',
      :use_join_force                        => 'true',
      :cache_images                          => 'all',
      :image_compression_level               => '1',
      :default_os_type                       => 'linux',
      :block_device_creation_timeout         => '10',
      :max_kernel_ramdisk_size               => '16777216',
      :sr_matching_filter                    => 'default-sr:true',
      :sparse_copy                           => 'true',
      :num_vbd_unplug_retries                => '10',
      :torrent_images                        => 'none',
      :ipxe_network_name                     => 'public',
      :ipxe_boot_menu_url                    => 'http://127.0.0.1/',
      :ipxe_mkisofs_cmd                      => 'mkisofs',
      :running_timeout                       => '10',
      :vif_driver                            => 'nova.virt.xenapi.vif.XenAPIBridgeDriver',	
      :image_upload_handler                  => 'nova.virt.xenapi.image.glance.GlanceStore',
      :introduce_vdi_retry_wait              => '20' }
  end

  context 'with required parameters' do

    it 'configures xenapi in nova.conf' do
      is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('xenapi.XenAPIDriver')
      is_expected.to contain_nova_config('xenserver/connection_url').with_value(params[:connection_url])
      is_expected.to contain_nova_config('xenserver/connection_username').with_value(params[:connection_username])
      is_expected.to contain_nova_config('xenserver/connection_password').with_value(params[:connection_password])
    end

    it 'installs xenapi with pip' do
      is_expected.to contain_package('xenapi').with(
        :ensure   => 'present',
        :provider => 'pip'
      )
    end
  end

  context 'with overridden parameters' do
    before do
      params.merge!({:compute_driver => 'xenapi.FoobarDriver'})
    end

    it 'configures xenapi in nova.conf' do
      is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('xenapi.FoobarDriver')
    end
  end

  context 'with optional parameters' do
    before :each do
      params.merge!(optional_params)
    end

    it 'configures xenapi in nova.conf' do
      is_expected.to contain_nova_config('xenserver/ovs_integration_bridge').with_value(params[:ovs_integration_bridge])
      is_expected.to contain_nova_config('xenserver/agent_timeout').with_value(params[:agent_timeout])
      is_expected.to contain_nova_config('xenserver/agent_version_timeout').with_value(params[:agent_version_timeout])
      is_expected.to contain_nova_config('xenserver/agent_resetnetwork_timeout').with_value(params[:agent_resetnetwork_timeout])
      is_expected.to contain_nova_config('xenserver/agent_path').with_value(params[:agent_path])
      is_expected.to contain_nova_config('xenserver/disable_agent').with_value(params[:disable_agent])
      is_expected.to contain_nova_config('xenserver/use_agent_default').with_value(params[:use_agent_default])
      is_expected.to contain_nova_config('xenserver/login_timeout').with_value(params[:login_timeout])
      is_expected.to contain_nova_config('xenserver/connection_concurrent').with_value(params[:connection_concurrent])
      is_expected.to contain_nova_config('xenserver/vhd_coalesce_poll_interval').with_value(params[:vhd_coalesce_poll_interval])
      is_expected.to contain_nova_config('xenserver/check_host').with_value(params[:check_host])
      is_expected.to contain_nova_config('xenserver/vhd_coalesce_max_attempts').with_value(params[:vhd_coalesce_max_attempts])
      is_expected.to contain_nova_config('xenserver/sr_base_path').with_value(params[:sr_base_path])
      is_expected.to contain_nova_config('xenserver/target_host').with_value(params[:target_host])
      is_expected.to contain_nova_config('xenserver/target_port').with_value(params[:target_port])
      is_expected.to contain_nova_config('xenserver/iqn_prefix').with_value(params[:iqn_prefix])
      is_expected.to contain_nova_config('xenserver/remap_vbd_dev').with_value(params[:remap_vbd_dev])
      is_expected.to contain_nova_config('xenserver/remap_vbd_dev_prefix').with_value(params[:remap_vbd_dev_prefix])
      is_expected.to contain_nova_config('xenserver/torrent_base_url').with_value(params[:torrent_base_url])
      is_expected.to contain_nova_config('xenserver/torrent_seed_chance').with_value(params[:torrent_seed_chance])
      is_expected.to contain_nova_config('xenserver/torrent_seed_duration').with_value(params[:torrent_seed_duration])
      is_expected.to contain_nova_config('xenserver/torrent_max_last_accessed').with_value(params[:torrent_max_last_accessed])
      is_expected.to contain_nova_config('xenserver/torrent_listen_port_start').with_value(params[:torrent_listen_port_start])
      is_expected.to contain_nova_config('xenserver/torrent_listen_port_end').with_value(params[:torrent_listen_port_end])
      is_expected.to contain_nova_config('xenserver/torrent_download_stall_cutoff').with_value(params[:torrent_download_stall_cutoff])
      is_expected.to contain_nova_config('xenserver/torrent_max_seeder_processes_per_host').with_value(params[:torrent_max_seeder_processes_per_host])
      is_expected.to contain_nova_config('xenserver/use_join_force').with_value(params[:use_join_force])
      is_expected.to contain_nova_config('xenserver/cache_images').with_value(params[:cache_images])
      is_expected.to contain_nova_config('xenserver/image_compression_level').with_value(params[:image_compression_level])
      is_expected.to contain_nova_config('xenserver/default_os_type').with_value(params[:default_os_type])
      is_expected.to contain_nova_config('xenserver/block_device_creation_timeout').with_value(params[:block_device_creation_timeout])
      is_expected.to contain_nova_config('xenserver/max_kernel_ramdisk_size').with_value(params[:max_kernel_ramdisk_size])
      is_expected.to contain_nova_config('xenserver/sr_matching_filter').with_value(params[:sr_matching_filter])
      is_expected.to contain_nova_config('xenserver/sparse_copy').with_value(params[:sparse_copy])
      is_expected.to contain_nova_config('xenserver/num_vbd_unplug_retries').with_value(params[:num_vbd_unplug_retries])
      is_expected.to contain_nova_config('xenserver/torrent_images').with_value(params[:torrent_images])
      is_expected.to contain_nova_config('xenserver/ipxe_network_name').with_value(params[:ipxe_network_name])
      is_expected.to contain_nova_config('xenserver/ipxe_boot_menu_url').with_value(params[:ipxe_boot_menu_url])
      is_expected.to contain_nova_config('xenserver/ipxe_mkisofs_cmd').with_value(params[:ipxe_mkisofs_cmd])
      is_expected.to contain_nova_config('xenserver/running_timeout').with_value(params[:running_timeout])
      is_expected.to contain_nova_config('xenserver/vif_driver').with_value(params[:vif_driver])
      is_expected.to contain_nova_config('xenserver/image_upload_handler').with_value(params[:image_upload_handler])
      is_expected.to contain_nova_config('xenserver/introduce_vdi_retry_wait').with_value(params[:introduce_vdi_retry_wait])
    end
  end
end
