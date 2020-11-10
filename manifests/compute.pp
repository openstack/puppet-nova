# == Class: nova::compute
#
# Installs the nova-compute service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the nova-compute service
#   Defaults to true
#
# [*heal_instance_info_cache_interval*]
#   (optional) Controls how often the instance info should be updated.
#   Defaults to $::os_service_default
#   To disable you can set the value to zero.
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) The state for the nova-compute package
#   Defaults to 'present'
#
# [*vnc_enabled*]
#   (optional) Whether to use a VNC proxy
#   Defaults to true
#
# [*spice_enabled*]
#   (optional) Whether to use a SPICE html5 proxy
#   Mutually exclusive with vnc_enabled.
#   Defaults to false.
#
# [*vncserver_proxyclient_address*]
#   (optional) The IP address of the server running the VNC proxy client
#   Defaults to '127.0.0.1'
#
# [*vncproxy_host*]
#   (optional) The host of the VNC proxy server
#   Defaults to false
#
# [*vncproxy_protocol*]
#   (optional) The protocol to communicate with the VNC proxy server
#   Defaults to 'http'
#
# [*vncproxy_port*]
#   (optional) The port to communicate with the VNC proxy server
#   Defaults to '6080'
#
# [*vncproxy_path*]
#   (optional) The path at the end of the uri for communication with the VNC proxy server
#   Defaults to '/vnc_auto.html'
#
# [*force_config_drive*]
#   (optional) Whether to force the config drive to be attached to all VMs
#   Defaults to false
#
# [*virtio_nic*]
#   (optional) Whether to use virtio for the nic driver of VMs
#   Defaults to false
#
# [*instance_usage_audit*]
#   (optional) Generate periodic compute.instance.exists notifications.
#   Defaults to false
#
# [*instance_usage_audit_period*]
#   (optional) Time period to generate instance usages for.
#   Time period must be hour, day, month or year
#   Defaults to 'month'
#
# [*use_cow_images*]
#   (optional) Enable use of copy-on-write (cow) images.
#   Defaults to $::os_service_default
#
# [*force_raw_images*]
#   (optional) Force backing images to raw format.
#   Defaults to $::os_service_default
#
# [*virt_mkfs*]
#   (optional) Name of the mkfs commands for ephemeral device.
#   The format is <os_type>=<mkfs command>
#   Defaults to $::os_service_default
#
# [*reserved_host_memory*]
#   Reserved host memory
#   The amount of memory in MB reserved for the host.
#   Defaults to $::os_service_default
#
# [*reserved_host_disk*]
#   Reserved host disk
#   The amount of disk in MB reserved for the host.
#   Defaults to $::os_service_default
#
# [*config_drive_format*]
#   (optional) Config drive format. One of iso9660 (default) or vfat
#   Defaults to undef
#
# [*reboot_timeout*]
#   (optioanl) Time interval after which an instance is hard rebooted
#   automatically. Setting this option to a time period in seconds will
#   automatically hard reboot an instance if it has been stuck in a rebooting
#   state longer than N seconds.
#   Defaults to $::os_service_default
#
# [*instance_build_timeout*]
#   (optional) Maximum time in seconds that an instance can take to build.
#   If this timer expires, instance status will be changed to ERROR.
#   Enabling this option will make sure an instance will not be stuck
#   in BUILD state for a longer period.
#   Defaults to $::os_service_default
#
# [*rescue_timeout*]
#   (optional) Interval to wait before un-rescuing an instance stuck in RESCUE.
#   Defaults to $::os_service_default
#
# [*resize_confirm_window*]
#   (optional) Automatically confirm resizes after N seconds.
#   Resize functionality will save the existing server before resizing.
#   After the resize completes, user is requested to confirm the resize.
#   The user has the opportunity to either confirm or revert all
#   changes. Confirm resize removes the original server and changes
#   server status from resized to active. Setting this option to a time
#   period (in seconds) will automatically confirm the resize if the
#   server is in resized state longer than that time.
#   Defaults to $::os_service_default
#
# [*shutdown_timeout*]
#   (optional) Total time to wait in seconds for an instance to perform a clean
#   shutdown. It determines the overall period (in seconds) a VM is allowed to
#   perform a clean shutdown. While performing stop, rescue and shelve, rebuild
#   operations, configuring this option gives the VM a chance to perform a
#   controlled shutdown before the instance is powered off.
#   Defaults to $::os_service_default
#
# [*cpu_shared_set*]
#   (optional) A list or range of host CPU cores to which emulator threads can be
#   scheduled, if vcpu_pin_set is set, or to which both emulator threads and processes
#   for unpinned instance CPUs (VCPUs) can be scheduled, if vcpu_pin_set is unset.
#   Defaults to $::os_service_default
#
# [*cpu_dedicated_set*]
#   (optional) A list or range of host CPU cores to which processes for pinned
#   instance CPUs (PCPUs) can be scheduled.
#   Defaults to $::os_service_default
#
# [*resume_guests_state_on_host_boot*]
#   (optional) This option specifies whether to start guests that were running before the
#   host rebooted. It ensures that all of the instances on a Nova compute node
#   resume their state each time the compute node boots or restarts.
#   Defaults to $::os_service_default
#
# [*barbican_auth_endpoint*]
#   (optional) Keystone v3 API URL.
#   Example: http://localhost:5000/v3
#   Defaults to $::os_service_default
#
# [*barbican_endpoint*]
#   (optional) Barbican URL.
#   Defaults to $::os_service_default
#
# [*barbican_api_version*]
#   (optional) Barbican API version.
#   Defaults to $::os_service_default
#
# [*max_concurrent_builds*]
#   (optional) Maximum number of instance builds to run concurrently
#   Defaults to $::os_service_default
#
# [*max_concurrent_live_migrations*]
#   (optional) Maximum number of live migrations to run in parallel.
#   Defaults to $::os_service_default
#
# [*sync_power_state_pool_size*]
#   (optional) Maximum number of greenthreads to use when syncing power states.
#   Defaults to $::os_service_default
#
# [*sync_power_state_interval*]
#   (optional) Interval to sync power states between the database and the hypervisor. Set
#   to -1 to disable. Setting this to 0 will run at the default rate.
#   Defaults to $::os_service_default
#
# [*consecutive_build_service_disable_threshold*]
#   (optional) Max number of consecutive build failures before the nova-compute
#   will disable itself.
#   Defaults to $::os_service_default
#
# [*keymgr_backend*]
#   (optional) Key Manager service class.
#   Example of valid value: castellan.key_manager.barbican_key_manager.BarbicanKeyManager
#   Defaults to 'nova.keymgr.conf_key_mgr.ConfKeyManager'.
#
# [*verify_glance_signatures*]
#   (optional) Whether to verify image signatures. (boolean value)
#   Defaults to $::os_service_default
#
# [*reserved_huge_pages*]
#   (optional) Number of huge memory pages to reserved per NUMA host cell.
#   Defaults to $::os_service_default
#   Accepts a string e.g "node:0,size:1GB,count:4" or a list of strings e.g:
#   ["node:0,size:1GB,count:4", "node:1,size:1GB,count:4"]
#
# [*neutron_physnets_numa_nodes_mapping*]
#   (optional) Map of physnet name as key and list of NUMA nodes as value.
#   Defaults to {}
#
# [*neutron_tunnel_numa_nodes*]
#   (optional) List of NUMA nodes to configure NUMA affinity for all
#   tunneled networks.
#   Defaults to []
#
# [*live_migration_wait_for_vif_plug*]
#   (optional) whether to wait for ``network-vif-plugged`` events before starting guest transfer
#   Defaults to $::os_service_default
#
# [*max_disk_devices_to_attach*]
#   (optional) specifies max number of devices that can be attached
#   to a single server.
#   Note that the number of disks supported by an server depends
#   on the bus used. For example, the ide disk bus is limited
#   to 4 attached devices. The configured maximum is enforced
#   during server create, rebuild, evacuate, unshelve, live migrate,
#   and attach volume.
#   Defaults to $::os_service_default
#
# [*default_access_ip_network_name*]
#   (optioanal) Name of the network to be used to set access IPs for
#   instances. If there are multiple IPs to choose from, an arbitrary
#   one will be chosen.
#   Defaults to $::os_service_default
#
# [*running_deleted_instance_action*]
#   (optional) The compute service periodically checks for instances that
#   have been deleted in the database but remain running on the compute node.
#   This option enables action to be taken when such instances are identified
#   Defaults to $::os_service_default
#
# [*running_deleted_instance_poll_interval*]
#   (optional) Time interval in seconds to wait between runs for the clean up
#   action. If set to 0, deleted instances check will be disabled.
#   Defaults to $::os_service_default
#
# [*running_deleted_instance_timeout*]
#   (optional) Time interval in seconds to wait for the instances that have
#   been marked as deleted in database to be eligible for cleanup.
#   Defaults to $::os_service_default
#
# [*compute_monitors*]
#   (optional) A comma-separated list of monitors that can be used for getting
#   compute metrics. Only one monitor per namespace (For example: cpu) can be
#   loaded at a time.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*neutron_enabled*]
#   (optional) Whether to use Neutron for networking of VMs
#   Defaults to undef
#
# [*install_bridge_utils*]
#   (optional) Whether to install the bridge-utils package or not.
#   Applicable only for cases when Neutron was disabled
#   Defaults to undef
#
# [*vcpu_pin_set*]
#   (optional) A list or range of host CPU cores to which processes for
#   unpinned instance CPUs (VCPUs) can be scheduled, if cpu_shared_set is set,
#   or to which both emulator threads and processes for unpinned instance CPUs
#   (VCPUs) can be scheduled, if cpu_shared_set is unset.
#   This option has been superseded by the ``cpu_shared_set`` and
#   ``cpu_dedicated_set`` options, which allows co-existence of
#   pinned and unpinned instances on the same host.
#   Defaults to undef
#
# [*allow_resize_to_same_host*]
#   (optional) Allow destination machine to match source for resize.
#   Useful when testing in single-host environments. Note that generally
#   this should be set in the api.pp class instead.
#   Defaults to undef
#
class nova::compute (
  $enabled                                     = true,
  $manage_service                              = true,
  $ensure_package                              = 'present',
  $vnc_enabled                                 = true,
  $spice_enabled                               = false,
  $vncserver_proxyclient_address               = '127.0.0.1',
  $vncproxy_host                               = false,
  $vncproxy_protocol                           = 'http',
  $vncproxy_port                               = '6080',
  $vncproxy_path                               = '/vnc_auto.html',
  $force_config_drive                          = false,
  $virtio_nic                                  = false,
  $instance_usage_audit                        = false,
  $instance_usage_audit_period                 = 'month',
  $use_cow_images                              = $::os_service_default,
  $force_raw_images                            = $::os_service_default,
  $virt_mkfs                                   = $::os_service_default,
  $reserved_host_memory                        = $::os_service_default,
  $reserved_host_disk                          = $::os_service_default,
  $heal_instance_info_cache_interval           = $::os_service_default,
  $config_drive_format                         = $::os_service_default,
  $reboot_timeout                              = $::os_service_default,
  $instance_build_timeout                      = $::os_service_default,
  $rescue_timeout                              = $::os_service_default,
  $resize_confirm_window                       = $::os_service_default,
  $shutdown_timeout                            = $::os_service_default,
  $cpu_shared_set                              = $::os_service_default,
  $cpu_dedicated_set                           = $::os_service_default,
  $resume_guests_state_on_host_boot            = $::os_service_default,
  $barbican_auth_endpoint                      = $::os_service_default,
  $barbican_endpoint                           = $::os_service_default,
  $barbican_api_version                        = $::os_service_default,
  $max_concurrent_builds                       = $::os_service_default,
  $max_concurrent_live_migrations              = $::os_service_default,
  $sync_power_state_pool_size                  = $::os_service_default,
  $sync_power_state_interval                   = $::os_service_default,
  $consecutive_build_service_disable_threshold = $::os_service_default,
  $keymgr_backend                              = 'nova.keymgr.conf_key_mgr.ConfKeyManager',
  $verify_glance_signatures                    = $::os_service_default,
  $reserved_huge_pages                         = $::os_service_default,
  $neutron_physnets_numa_nodes_mapping         = {},
  $neutron_tunnel_numa_nodes                   = [],
  $live_migration_wait_for_vif_plug            = $::os_service_default,
  $max_disk_devices_to_attach                  = $::os_service_default,
  $default_access_ip_network_name              = $::os_service_default,
  $running_deleted_instance_action             = $::os_service_default,
  $running_deleted_instance_poll_interval      = $::os_service_default,
  $running_deleted_instance_timeout            = $::os_service_default,
  $compute_monitors                            = $::os_service_default,
  # DEPRECATED PARAMETERS
  $neutron_enabled                             = undef,
  $install_bridge_utils                        = undef,
  $vcpu_pin_set                                = undef,
  $allow_resize_to_same_host                   = undef,
) {

  include nova::deps
  include nova::params
  include nova::workarounds

  $cpu_shared_set_real = pick(join(any2array($cpu_shared_set), ','), $::os_service_default)
  $cpu_dedicated_set_real = pick(join(any2array($cpu_dedicated_set), ','), $::os_service_default)

  $max_concurrent_builds_real = pick(
    $::nova::compute::ironic::max_concurrent_builds,
    $max_concurrent_builds)

  include nova::pci
  include nova::compute::vgpu

  if $neutron_enabled {
    warning('neutron_enabled is deprecated and has no effect, was only used for install_bridge_utils')
  }

  if $install_bridge_utils {
    warning('install_bridge_utils is deprecated and has no effect')
  }

  if ($vnc_enabled and $spice_enabled) {
    fail('vnc_enabled and spice_enabled is mutually exclusive')
  }

  if $vcpu_pin_set {
    warning('vcpu_pin_set is deprecated, instead use cpu_dedicated_set or cpu_shared_set.')
  }

  if $allow_resize_to_same_host != undef {
    warning('allow_resize_to_same_host is deprecated, and has no effect. \
Use the same parameter in nova::api class.')
  }

  if empty($vcpu_pin_set) {
    $vcpu_pin_set_real = undef
  } else {
    $vcpu_pin_set_real = join(any2array($vcpu_pin_set), ',')
  }

  if $vcpu_pin_set_real  and !is_service_default($cpu_dedicated_set_real) {
    fail('vcpu_pin_set is deprecated. vcpu_pin_set and cpu_dedicated_set are mutually exclusive.')
  }

  if $vcpu_pin_set_real != undef {
    # handle the following conditions:
    #
    # 1. if vcpu_pin_set is set but cpu_shared_set is not set.
    # 2. if cpu_shared_set and vcpu_pin_set both are set, but cpu_dedicated_set is not set.
    nova_config {
      'compute/cpu_shared_set':    value => $cpu_shared_set_real;
      'compute/cpu_dedicated_set': value => $cpu_dedicated_set_real;
      'DEFAULT/vcpu_pin_set':      value => $vcpu_pin_set_real;
    }
  } else {
    # handle the following conditions:
    #
    # 3. if cpu_dedicated_set is set but cpu_shared_set is not set.
    # 4. if cpu_shared_set is set but vcpu_pin_set and cpu_dedicated_set are not set.
    # 5. if cpu_shared_set and cpu_dedicated_set both are set, then ignore vcpu_pin_set.
    nova_config {
      'compute/cpu_shared_set':    value  => $cpu_shared_set_real;
      'compute/cpu_dedicated_set': value  => $cpu_dedicated_set_real;
      'DEFAULT/vcpu_pin_set':      ensure => absent; # when undef, don't include in conf.
    }
  }

  # cryptsetup is required when Barbican is encrypting volumes
  if $keymgr_backend =~ /barbican/ {
    ensure_packages('cryptsetup', {
      ensure => present,
      tag    => 'openstack',
    })
  }

  if !empty($neutron_physnets_numa_nodes_mapping) {
    validate_legacy(Hash, 'validate_hash', $neutron_physnets_numa_nodes_mapping)
    $neutron_physnets_real = keys($neutron_physnets_numa_nodes_mapping)
    nova_config {
      'neutron/physnets': value => join(any2array($neutron_physnets_real), ',');
    }

    $neutron_physnets_numa_nodes_mapping.each |$physnet, $numa_nodes| {
      nova_config {
        "neutron_physnet_${physnet}/numa_nodes": value => join(any2array($numa_nodes), ',');
      }
    }
  } else {
    nova_config {
      'neutron/physnets': ensure => absent;
    }
  }

  if !empty($neutron_tunnel_numa_nodes) {
    nova_config {
      'neutron_tunnel/numa_nodes': value => join(any2array($neutron_tunnel_numa_nodes), ',');
    }
  } else {
    nova_config {
      'neutron_tunnel/numa_nodes': ensure => absent;
    }
  }

  if !is_service_default($reserved_huge_pages) and !empty($reserved_huge_pages) {
    if is_array($reserved_huge_pages) or is_string($reserved_huge_pages) {
      $reserved_huge_pages_real = $reserved_huge_pages
    } else {
      fail("Invalid reserved_huge_pages parameter value: ${reserved_huge_pages}")
    }
  } else {
    $reserved_huge_pages_real = $::os_service_default
  }

  include nova::availability_zone

  nova_config {
    'DEFAULT/use_cow_images':                    value => $use_cow_images;
    'DEFAULT/force_raw_images':                  value => $force_raw_images;
    'DEFAULT/virt_mkfs':                         value => $virt_mkfs;
    'DEFAULT/reserved_host_memory_mb':           value => $reserved_host_memory;
    'DEFAULT/reserved_host_disk_mb':             value => $reserved_host_disk;
    'DEFAULT/reserved_huge_pages':               value => $reserved_huge_pages_real;
    'DEFAULT/heal_instance_info_cache_interval': value => $heal_instance_info_cache_interval;
    'DEFAULT/reboot_timeout':                    value => $reboot_timeout;
    'DEFAULT/instance_build_timeout':            value => $instance_build_timeout;
    'DEFAULT/rescue_timeout':                    value => $rescue_timeout;
    'DEFAULT/resize_confirm_window':             value => $resize_confirm_window;
    'DEFAULT/shutdown_timeout':                  value => $shutdown_timeout;
    'DEFAULT/resume_guests_state_on_host_boot':  value => $resume_guests_state_on_host_boot;
    'key_manager/backend':                       value => $keymgr_backend;
    'barbican/auth_endpoint':                    value => $barbican_auth_endpoint;
    'barbican/barbican_endpoint':                value => $barbican_endpoint;
    'barbican/barbican_api_version':             value => $barbican_api_version;
    'DEFAULT/max_concurrent_builds':             value => $max_concurrent_builds_real;
    'DEFAULT/max_concurrent_live_migrations':    value => $max_concurrent_live_migrations;
    'DEFAULT/sync_power_state_pool_size':        value => $sync_power_state_pool_size;
    'DEFAULT/sync_power_state_interval':         value => $sync_power_state_interval;
    'compute/consecutive_build_service_disable_threshold':
      value => $consecutive_build_service_disable_threshold;
    'compute/live_migration_wait_for_vif_plug':  value => $live_migration_wait_for_vif_plug;
    'compute/max_disk_devices_to_attach':        value => $max_disk_devices_to_attach;
    'DEFAULT/default_access_ip_network_name':    value => $default_access_ip_network_name;
    'DEFAULT/running_deleted_instance_action':   value => $running_deleted_instance_action;
    'DEFAULT/running_deleted_instance_poll_interval':
      value => $running_deleted_instance_poll_interval;
    'DEFAULT/running_deleted_instance_timeout':  value => $running_deleted_instance_timeout;
    'DEFAULT/compute_monitors':                  value => join(any2array($compute_monitors), ',');
  }

  if ($vnc_enabled) {
    include nova::vncproxy::common

    nova_config {
      'vnc/server_proxyclient_address': value => $vncserver_proxyclient_address;
    }
  } else {
    nova_config {
      'vnc/server_proxyclient_address': ensure => absent;
    }
  }

  nova_config {
    'vnc/enabled':   value => $vnc_enabled;
    'spice/enabled': value => $spice_enabled;
  }

  nova::generic_service { 'compute':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::compute_package_name,
    service_name   => $::nova::params::compute_service_name,
    ensure_package => $ensure_package,
    before         => Exec['networking-refresh']
  }

  if $force_config_drive {
    nova_config { 'DEFAULT/force_config_drive': value => true }
  } else {
    nova_config { 'DEFAULT/force_config_drive': ensure => absent }
  }

  if $virtio_nic {
    # Enable the virtio network card for instances
    nova_config { 'DEFAULT/libvirt_use_virtio_for_bridges': value => true }
  }

  if $instance_usage_audit and $instance_usage_audit_period in ['hour', 'day', 'month', 'year'] {
    nova_config {
      'DEFAULT/instance_usage_audit':        value => $instance_usage_audit;
      'DEFAULT/instance_usage_audit_period': value => $instance_usage_audit_period;
    }
  } else {
    nova_config {
      'DEFAULT/instance_usage_audit':        ensure => absent;
      'DEFAULT/instance_usage_audit_period': ensure => absent;
    }
  }

  if is_service_default($config_drive_format) or $config_drive_format == 'iso9660' {
    ensure_packages($::nova::params::genisoimage_package_name, {
      tag => ['openstack', 'nova-support-package'],
    })
  }

  nova_config {
    'DEFAULT/config_drive_format':     value => $config_drive_format;
    'glance/verify_glance_signatures': value => $verify_glance_signatures;
  }

}
