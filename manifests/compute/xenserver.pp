# == Class: nova::compute::xenserver
#
# Configures nova-compute to manage xen guests
#
# === Parameters:
#
# [*connection_url*]
#   (required) URL for connection to XenServer/Xen Cloud Platform.
#
# [*connection_username*]
#   (required) Username for connection to XenServer/Xen Cloud Platform
#
# [*connection_password*]
#   (required) Password for connection to XenServer/Xen Cloud Platform
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'xenapi.XenAPIDriver'
#
# [*ovs_integration_bridge*]
#   (optional) Name of Integration Bridge used by Open vSwitch (string value)
#   Defaults to $::os_service_default
#
# [*agent_timeout*]
#   (optional) Number of seconds to wait for agent reply (integer value)
#   Defaults to $::os_service_default
#
# [*agent_version_timeout*]
#   (optional) Number of seconds to wait for agent to be fully operational (integer value)
#   Defaults to $::os_service_default
#
# [*agent_resetnetwork_timeout*]
#   (optional) Number of seconds to wait for agent reply to resetnetwork request (integer value)
#   Defaults to $::os_service_default
#
# [*agent_path*]
#   (optional) Specifies the path in which the XenAPI guest agent should be located. If the
#   agent is present, network configuration is not injected into the image. Used
#   if compute_driver=xenapi.XenAPIDriver and flat_injected=True (string value)
#   Defaults to $::os_service_default
#
# [*disable_agent*]
#   (optional) Disables the use of the XenAPI agent in any image regardless of what image
#   properties are present (boolean value).
#   Defaults to $::os_service_default
#
# [*use_agent_default*]
#   (optional) Determines if the XenAPI agent should be used when the image used does not
#   contain a hint to declare if the agent is present or not. The hint is a
#   glance property "xenapi_use_agent" that has the value "True" or "False". Note
#   that waiting for the agent when it is not present will significantly increase
#   server boot times. (boolean value)
#   Defaults to $::os_service_default
#
# [*login_timeout*]
#   (optional) Timeout in seconds for XenAPI login. (integer value)
#   Defaults to $::os_service_default
#
# [*connection_concurrent*]
#   {optional} Maximum number of concurrent XenAPI connections.
#   Defaults to $::os_service_default
#
# [*vhd_coalesce_poll_interval*]
#   (optional) The interval used for polling of coalescing vhds. (floating point value)
#   Defaults to $::os_service_default
#
# [*check_host*]
#   (optional) Ensure compute service is running on host XenAPI connects to. (boolean value)
#   Defaults to $::os_service_default
#
# [*vhd_coalesce_max_attempts*]
#   (optional) Max number of times to poll for VHD to coalesce.
#   Defaults to $::os_service_default
#
# [*sr_base_path*]
#   (optional) Base path to the storage repository (string value)
#   Defaults to $::os_service_default
#
# [*target_host*]
#   (optional) The iSCSI Target Host (string value)
#   Defaults to $::os_service_default
#
# [*target_port*]
#   (optional) The iSCSI Target Port, default is port 3260 (string value)
#   Defaults to $::os_service_default
#
# [*iqn_prefix*]
#   (optional) IQN Prefix (string value)
#   Defaults to $::os_service_default
#
# [*remap_vbd_dev*]
#   (optional) Used to enable the remapping of VBD dev (Works around an issue in Ubuntu
#   Maverick) (boolean value)
#   Defaults to $::os_service_default
#
# [*remap_vbd_dev_prefix*]
#   (optional) Specify prefix to remap VBD dev to (ex. /dev/xvdb -> /dev/sdb) (string value)
#   Defaults to $::os_service_default
#
# [*torrent_base_url*]
#   (optional) Base URL for torrent files; must contain a slash character (see RFC 1808,
#   step 6) (string value)
#   Defaults to $::os_service_default
#
# [*torrent_seed_chance*]
#   (optional) Probability that peer will become a seeder. (1.0 = 100%) (floating point value)
#   Defaults to $::os_service_default
#
# [*torrent_seed_duration*]
#   (optional) Number of seconds after downloading an image via BitTorrent that it should be
#   seeded for other peers. (integer value)
#   Defaults to $::os_service_default
#
# [*torrent_max_last_accessed*]
#   (optional) Cached torrent files not accessed within this number of seconds can be reaped
#   (integer value)
#   Defaults to $::os_service_default
#
# [*torrent_listen_port_start*]
#   (optional) Beginning of port range to listen on (integer value)
#   Minimum value: 1
#   Maximum value: 65535
#   Defaults to $::os_service_default
#
# [*torrent_listen_port_end*]
#   (optional) End of port range to listen on (integer value)
#   Minimum value: 1
#   Maximum value: 65535
#   Defaults to $::os_service_default
#
# [*torrent_download_stall_cutoff*]
#   (optional) Number of seconds a download can remain at the same progress percentage w/o
#   being considered a stall (integer value)
#   Defaults to $::os_service_default
#
# [*torrent_max_seeder_processes_per_host*]
#   (optional) Maximum number of seeder processes to run concurrently within a given dom0.
#   (-1 = no limit) (integer value)
#   Defaults to $::os_service_default
#
# [*use_join_force*]
#   (optional) To use for hosts with different CPUs (boolean value)
#   Defaults to $::os_service_default
#
# [*cache_images*]
#   (optional) Cache glance images locally. `all` will cache all images, `some` will only
#   cache images that have the image_property `cache_in_nova=True`, and `none`
#   turns off caching entirely (string value)
#   Allowed values: all, some, none
#   Defaults to $::os_service_default
#
# [*image_compression_level*]
#   (optional) Compression level for images, e.g., 9 for gzip -9. Range is 1-9, 9 being most
#   compressed but most CPU intensive on dom0. (integer value)
#   Minimum value: 1
#   Maximum value: 9
#   Defaults to $::os_service_default
#
# [*default_os_type*]
#   (optional) Default OS type (string value)
#   Defaults to $::os_service_default
#
# [*block_device_creation_timeout*]
#  (optional) Time to wait for a block device to be created (integer value)
#   Defaults to $::os_service_default
#
# [*max_kernel_ramdisk_size*]
#   (optional) Maximum size in bytes of kernel or ramdisk images (integer value)
#   Defaults to $::os_service_default
#
# [*sr_matching_filter*]
#   (optional) Filter for finding the SR to be used to install guest instances on. To use
#   the Local Storage in default XenServer/XCP installations set this flag to
#   other-config:i18n-key=local-storage. To select an SR with a different
#   matching criteria, you could set it to other-config:my_favorite_sr=true. On
#   the other hand, to fall back on the Default SR, as displayed by XenCenter,
#   set this flag to: default-sr:true (string value)
#   Defaults to $::os_service_default
#
# [*sparse_copy*]
#   (optional) Whether to use sparse_copy for copying data on a resize down (False will use
#   standard dd). This speeds up resizes down considerably since large runs of
#   zeros won't have to be rsynced (boolean value)
#   Defaults to $::os_service_default
#
# [*num_vbd_unplug_retries*]
#   (optional) Maximum number of retries to unplug VBD. if <=0, should try once and no retry
#   (integer value)
#   Defaults to $::os_service_default
#
# [*torrent_images*]
#   (optional) Whether or not to download images via Bit Torrent. (string value)
#   Allowed values: all, some, none
#   Defaults to $::os_service_default
#
# [*ipxe_network_name*]
#   (optional) Name of network to use for booting iPXE ISOs (string value)
#   Defaults to $::os_service_default
#
# [*ipxe_boot_menu_url*]
#   (optional) URL to the iPXE boot menu (string value)
#   Defaults to $::os_service_default
#
# [*ipxe_mkisofs_cmd*]
#   (optional) Name and optionally path of the tool used for ISO image creation (string
#   value)
#   Defaults to $::os_service_default
#
# [*running_timeout*]
#   (optional) Number of seconds to wait for instance to go to running state (integer value)
#   Defaults to $::os_service_default
#
# [*vif_driver*]
#   (optional) The XenAPI VIF driver using XenServer Network APIs. (string value)
#   Defaults to $::os_service_default
#
# [*image_upload_handler*]
#   (optional) Dom0 plugin driver used to handle image uploads. (string value)
#   Defaults to $::os_service_default
#
# [*introduce_vdi_retry_wait*]
#   (optional) Number of seconds to wait for an SR to settle if the VDI does not exist when
#   first introduced (integer value)
#   Defaults to $::os_service_default
#
class nova::compute::xenserver(
  $connection_url,
  $connection_username,
  $connection_password,
  $compute_driver                        = 'xenapi.XenAPIDriver',
  $ovs_integration_bridge                = $::os_service_default,
  $agent_timeout                         = $::os_service_default,
  $agent_version_timeout                 = $::os_service_default,
  $agent_resetnetwork_timeout            = $::os_service_default,
  $agent_path                            = $::os_service_default,
  $disable_agent                         = $::os_service_default,
  $use_agent_default                     = $::os_service_default,
  $login_timeout                         = $::os_service_default,
  $connection_concurrent                 = $::os_service_default,
  $vhd_coalesce_poll_interval            = $::os_service_default,
  $check_host                            = $::os_service_default,
  $vhd_coalesce_max_attempts             = $::os_service_default,
  $sr_base_path                          = $::os_service_default,
  $target_host                           = $::os_service_default,
  $target_port                           = $::os_service_default,
  $iqn_prefix                            = $::os_service_default,
  $remap_vbd_dev                         = $::os_service_default,
  $remap_vbd_dev_prefix                  = $::os_service_default,
  $torrent_base_url                      = $::os_service_default,
  $torrent_seed_chance                   = $::os_service_default,
  $torrent_seed_duration                 = $::os_service_default,
  $torrent_max_last_accessed             = $::os_service_default,
  $torrent_listen_port_start             = $::os_service_default,
  $torrent_listen_port_end               = $::os_service_default,
  $torrent_download_stall_cutoff         = $::os_service_default,
  $torrent_max_seeder_processes_per_host = $::os_service_default,
  $use_join_force                        = $::os_service_default,
  $cache_images                          = $::os_service_default,
  $image_compression_level               = $::os_service_default,
  $default_os_type                       = $::os_service_default,
  $block_device_creation_timeout         = $::os_service_default,
  $max_kernel_ramdisk_size               = $::os_service_default,
  $sr_matching_filter                    = $::os_service_default,
  $sparse_copy                           = $::os_service_default,
  $num_vbd_unplug_retries                = $::os_service_default,
  $torrent_images                        = $::os_service_default,
  $ipxe_network_name                     = $::os_service_default,
  $ipxe_boot_menu_url                    = $::os_service_default,
  $ipxe_mkisofs_cmd                      = $::os_service_default,
  $running_timeout                       = $::os_service_default,
  $vif_driver                            = 'nova.virt.xenapi.vif.XenAPIOpenVswitchDriver',
  $image_upload_handler                  = $::os_service_default,
  $introduce_vdi_retry_wait              = $::os_service_default,
) {

  include ::nova::deps

  nova_config {
    'DEFAULT/compute_driver':                          value => $compute_driver;
    'xenserver/connection_url':                        value => $connection_url;
    'xenserver/connection_username':                   value => $connection_username;
    'xenserver/connection_password':                   value => $connection_password;
    'xenserver/ovs_integration_bridge':                value => $ovs_integration_bridge;
    'xenserver/agent_timeout':                         value => $agent_timeout;
    'xenserver/agent_version_timeout':                 value => $agent_version_timeout;
    'xenserver/agent_resetnetwork_timeout':            value => $agent_resetnetwork_timeout;
    'xenserver/agent_path':                            value => $agent_path;
    'xenserver/disable_agent':                         value => $disable_agent;
    'xenserver/use_agent_default':                     value => $use_agent_default;
    'xenserver/login_timeout':                         value => $login_timeout;
    'xenserver/connection_concurrent':                 value => $connection_concurrent;
    'xenserver/vhd_coalesce_poll_interval':            value => $vhd_coalesce_poll_interval;
    'xenserver/check_host':                            value => $check_host;
    'xenserver/vhd_coalesce_max_attempts':             value => $vhd_coalesce_max_attempts;
    'xenserver/sr_base_path':                          value => $sr_base_path;
    'xenserver/target_host':                           value => $target_host;
    'xenserver/target_port':                           value => $target_port;
    'xenserver/iqn_prefix':                            value => $iqn_prefix;
    'xenserver/remap_vbd_dev':                         value => $remap_vbd_dev;
    'xenserver/remap_vbd_dev_prefix':                  value => $remap_vbd_dev_prefix;
    'xenserver/torrent_base_url':                      value => $torrent_base_url;
    'xenserver/torrent_seed_chance':                   value => $torrent_seed_chance;
    'xenserver/torrent_seed_duration':                 value => $torrent_seed_duration;
    'xenserver/torrent_max_last_accessed':             value => $torrent_max_last_accessed;
    'xenserver/torrent_listen_port_start':             value => $torrent_listen_port_start;
    'xenserver/torrent_listen_port_end':               value => $torrent_listen_port_end;
    'xenserver/torrent_download_stall_cutoff':         value => $torrent_download_stall_cutoff;
    'xenserver/torrent_max_seeder_processes_per_host': value => $torrent_max_seeder_processes_per_host;
    'xenserver/use_join_force':                        value => $use_join_force;
    'xenserver/cache_images':                          value => $cache_images;
    'xenserver/image_compression_level':               value => $image_compression_level;
    'xenserver/default_os_type':                       value => $default_os_type;
    'xenserver/block_device_creation_timeout':         value => $block_device_creation_timeout;
    'xenserver/max_kernel_ramdisk_size':               value => $max_kernel_ramdisk_size;
    'xenserver/sr_matching_filter':                    value => $sr_matching_filter;
    'xenserver/sparse_copy':                           value => $sparse_copy;
    'xenserver/num_vbd_unplug_retries':                value => $num_vbd_unplug_retries;
    'xenserver/torrent_images':                        value => $torrent_images;
    'xenserver/ipxe_network_name':                     value => $ipxe_network_name;
    'xenserver/ipxe_boot_menu_url':                    value => $ipxe_boot_menu_url;
    'xenserver/ipxe_mkisofs_cmd':                      value => $ipxe_mkisofs_cmd;
    'xenserver/running_timeout':                       value => $running_timeout;
    'xenserver/vif_driver':                            value => $vif_driver;
    'xenserver/image_upload_handler':                  value => $image_upload_handler;
    'xenserver/introduce_vdi_retry_wait':              value => $introduce_vdi_retry_wait;
  }

  ensure_packages(['python-pip'])

  package { 'xenapi':
    ensure   => present,
    provider => pip,
    tag      => ['openstack', 'nova-support-package'],
  }

  Package['python-pip'] -> Package['xenapi']
}
