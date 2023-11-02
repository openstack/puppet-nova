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
#   Defaults to $facts['os_service_default']
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
# [*mkisofs_cmd*]
#   (optional) Name or path of the tool used for ISO image creation.
#   Defaults to $facts['os_service_default']
#
# [*instance_usage_audit*]
#   (optional) Generate periodic compute.instance.exists notifications.
#   Defaults to false
#
# [*instance_usage_audit_period*]
#   (optional) Time period to generate instance usages for.
#   Time period must be hour, day, month or year with/without offset.
#   Defaults to $facts['os_service_default']
#
# [*use_cow_images*]
#   (optional) Enable use of copy-on-write (cow) images.
#   Defaults to $facts['os_service_default']
#
# [*force_raw_images*]
#   (optional) Force backing images to raw format.
#   Defaults to $facts['os_service_default']
#
# [*virt_mkfs*]
#   (optional) Name of the mkfs commands for ephemeral device.
#   The format is <os_type>=<mkfs command>
#   Defaults to $facts['os_service_default']
#
# [*reserved_host_cpus*]
#   (optional) Number of host CPUs reserved for the host.
#   Defaults to $facts['os_service_default']
#
# [*reserved_host_memory*]
#   (optional) The amount of memory in MB reserved for the host.
#   Defaults to $facts['os_service_default']
#
# [*reserved_host_disk*]
#   (optional) The amount of disk in MB reserved for the host.
#   Defaults to $facts['os_service_default']
#
# [*update_resources_interval*]
#   (optional) Interval for updating compute resources.
#   This option specifies how often the update_available_resources periodic
#   task should run. A number less than 0 means to disable the task completely
#   Leaving this at the default of 0 will cause this to run at the default
#   periodic interval. Setting it to any positive value will cause it to run
#   at approximately that number of seconds.
#   Defaults to $facts['os_service_default']
#
# [*reboot_timeout*]
#   (optional) Time interval after which an instance is hard rebooted
#   automatically. Setting this option to a time period in seconds will
#   automatically hard reboot an instance if it has been stuck in a rebooting
#   state longer than N seconds.
#   Defaults to $facts['os_service_default']
#
# [*instance_build_timeout*]
#   (optional) Maximum time in seconds that an instance can take to build.
#   If this timer expires, instance status will be changed to ERROR.
#   Enabling this option will make sure an instance will not be stuck
#   in BUILD state for a longer period.
#   Defaults to $facts['os_service_default']
#
# [*rescue_timeout*]
#   (optional) Interval to wait before un-rescuing an instance stuck in RESCUE.
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*shutdown_timeout*]
#   (optional) Total time to wait in seconds for an instance to perform a clean
#   shutdown. It determines the overall period (in seconds) a VM is allowed to
#   perform a clean shutdown. While performing stop, rescue and shelve, rebuild
#   operations, configuring this option gives the VM a chance to perform a
#   controlled shutdown before the instance is powered off.
#   Defaults to $facts['os_service_default']
#
# [*cpu_shared_set*]
#   (optional) Mask of host CPUs that can be used for ``VCPU`` resources and
#   offloaded emulator threads.
#   Defaults to $facts['os_service_default']
#
# [*cpu_dedicated_set*]
#   (optional) A list or range of host CPU cores to which processes for pinned
#   instance CPUs (PCPUs) can be scheduled.
#   Defaults to $facts['os_service_default']
#
# [*resume_guests_state_on_host_boot*]
#   (optional) This option specifies whether to start guests that were running before the
#   host rebooted. It ensures that all of the instances on a Nova compute node
#   resume their state each time the compute node boots or restarts.
#   Defaults to $facts['os_service_default']
#
# [*max_concurrent_builds*]
#   (optional) Maximum number of instance builds to run concurrently
#   Defaults to $facts['os_service_default']
#
# [*max_concurrent_live_migrations*]
#   (optional) Maximum number of live migrations to run in parallel.
#   Defaults to $facts['os_service_default']
#
# [*sync_power_state_pool_size*]
#   (optional) Maximum number of greenthreads to use when syncing power states.
#   Defaults to $facts['os_service_default']
#
# [*sync_power_state_interval*]
#   (optional) Interval to sync power states between the database and the hypervisor. Set
#   to -1 to disable. Setting this to 0 will run at the default rate.
#   Defaults to $facts['os_service_default']
#
# [*consecutive_build_service_disable_threshold*]
#   (optional) Max number of consecutive build failures before the nova-compute
#   will disable itself.
#   Defaults to $facts['os_service_default']
#
# [*reserved_huge_pages*]
#   (optional) Number of huge memory pages to reserved per NUMA host cell.
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*max_disk_devices_to_attach*]
#   (optional) specifies max number of devices that can be attached
#   to a single server.
#   Note that the number of disks supported by an server depends
#   on the bus used. For example, the ide disk bus is limited
#   to 4 attached devices. The configured maximum is enforced
#   during server create, rebuild, evacuate, unshelve, live migrate,
#   and attach volume.
#   Defaults to $facts['os_service_default']
#
# [*default_access_ip_network_name*]
#   (optional) Name of the network to be used to set access IPs for
#   instances. If there are multiple IPs to choose from, an arbitrary
#   one will be chosen.
#   Defaults to $facts['os_service_default']
#
# [*running_deleted_instance_action*]
#   (optional) The compute service periodically checks for instances that
#   have been deleted in the database but remain running on the compute node.
#   This option enables action to be taken when such instances are identified
#   Defaults to $facts['os_service_default']
#
# [*running_deleted_instance_poll_interval*]
#   (optional) Time interval in seconds to wait between runs for the clean up
#   action. If set to 0, deleted instances check will be disabled.
#   Defaults to $facts['os_service_default']
#
# [*running_deleted_instance_timeout*]
#   (optional) Time interval in seconds to wait for the instances that have
#   been marked as deleted in database to be eligible for cleanup.
#   Defaults to $facts['os_service_default']
#
# [*compute_monitors*]
#   (optional) A comma-separated list of monitors that can be used for getting
#   compute metrics. Only one monitor per namespace (For example: cpu) can be
#   loaded at a time.
#   Defaults to $facts['os_service_default']
#
# [*default_ephemeral_format*]
#   (optional) The default format an ephemeral_volume will be formatted with
#   on creation.
#   Defaults to $facts['os_service_default']
#
# [*image_type_exclude_list*]
#   (optional) List of image formats that should not be advertised as supported
#   by the compute service.
#
# [*block_device_allocate_retries*]
#   (optional) Number of times to retry block device allocation on failures
#   Defaults to $facts['os_service_default']
#
# [*block_device_allocate_retries_interval*]
#   (optional) Waiting time interval (seconds) between block device allocation
#   retries on failures
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
# [*config_drive_format*]
#   (optional) Config drive format. One of iso9660 (default) or vfat
#   Defaults to undef
#
class nova::compute (
  Boolean $enabled                             = true,
  Boolean $manage_service                      = true,
  $ensure_package                              = 'present',
  Boolean $vnc_enabled                         = true,
  Boolean $spice_enabled                       = false,
  $vncserver_proxyclient_address               = '127.0.0.1',
  $vncproxy_host                               = false,
  $vncproxy_protocol                           = 'http',
  $vncproxy_port                               = '6080',
  $vncproxy_path                               = '/vnc_auto.html',
  Boolean $force_config_drive                  = false,
  Boolean $instance_usage_audit                = false,
  $instance_usage_audit_period                 = $facts['os_service_default'],
  $mkisofs_cmd                                 = $facts['os_service_default'],
  $use_cow_images                              = $facts['os_service_default'],
  $force_raw_images                            = $facts['os_service_default'],
  $virt_mkfs                                   = $facts['os_service_default'],
  $reserved_host_cpus                          = $facts['os_service_default'],
  $reserved_host_memory                        = $facts['os_service_default'],
  $reserved_host_disk                          = $facts['os_service_default'],
  $heal_instance_info_cache_interval           = $facts['os_service_default'],
  $update_resources_interval                   = $facts['os_service_default'],
  $reboot_timeout                              = $facts['os_service_default'],
  $instance_build_timeout                      = $facts['os_service_default'],
  $rescue_timeout                              = $facts['os_service_default'],
  $resize_confirm_window                       = $facts['os_service_default'],
  $shutdown_timeout                            = $facts['os_service_default'],
  $cpu_shared_set                              = $facts['os_service_default'],
  $cpu_dedicated_set                           = $facts['os_service_default'],
  $resume_guests_state_on_host_boot            = $facts['os_service_default'],
  $max_concurrent_builds                       = $facts['os_service_default'],
  $max_concurrent_live_migrations              = $facts['os_service_default'],
  $sync_power_state_pool_size                  = $facts['os_service_default'],
  $sync_power_state_interval                   = $facts['os_service_default'],
  $consecutive_build_service_disable_threshold = $facts['os_service_default'],
  $reserved_huge_pages                         = $facts['os_service_default'],
  Hash $neutron_physnets_numa_nodes_mapping    = {},
  $neutron_tunnel_numa_nodes                   = [],
  $live_migration_wait_for_vif_plug            = $facts['os_service_default'],
  $max_disk_devices_to_attach                  = $facts['os_service_default'],
  $default_access_ip_network_name              = $facts['os_service_default'],
  $running_deleted_instance_action             = $facts['os_service_default'],
  $running_deleted_instance_poll_interval      = $facts['os_service_default'],
  $running_deleted_instance_timeout            = $facts['os_service_default'],
  $compute_monitors                            = $facts['os_service_default'],
  $default_ephemeral_format                    = $facts['os_service_default'],
  $image_type_exclude_list                     = $facts['os_service_default'],
  $block_device_allocate_retries               = $facts['os_service_default'],
  $block_device_allocate_retries_interval      = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $config_drive_format                         = undef,
) {

  include nova::deps
  include nova::params

  if $config_drive_format != undef {
    warning('The config_drive_format parameter is deprecated.')
  }

  $image_type_exclude_list_real = pick(join(any2array($image_type_exclude_list), ','), $facts['os_service_default'])

  include nova::policy

  include nova::pci
  include nova::compute::pci
  include nova::compute::mdev

  if ($vnc_enabled and $spice_enabled) {
    fail('vnc_enabled and spice_enabled is mutually exclusive')
  }

  nova_config {
    'compute/cpu_shared_set':    value  => join(any2array($cpu_shared_set), ',');
    'compute/cpu_dedicated_set': value  => join(any2array($cpu_dedicated_set), ',');
  }

  if !empty($neutron_physnets_numa_nodes_mapping) {
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

  $reserved_huge_pages_real = $reserved_huge_pages ? {
    String  => $reserved_huge_pages,
    Array   => $reserved_huge_pages,
    default => fail("Invalid reserved_huge_pages parameter value: ${reserved_huge_pages}")
  }

  include nova::availability_zone

  # NOTE(tkajinam): In some distros like CentOS9, the genisoimage command
  #                 is no longer available and we should override
  #                 the mkisofs_cmd parameter to use the available command
  #                 instead of genisoimage. This can be removed once default
  #                 in nova is updated.
  if $::nova::params::mkisofs_cmd and is_service_default($mkisofs_cmd) {
    $mkisofs_cmd_real = $::nova::params::mkisofs_cmd
  } else {
    $mkisofs_cmd_real = $mkisofs_cmd
  }

  nova_config {
    'DEFAULT/use_cow_images':                    value => $use_cow_images;
    'DEFAULT/mkisofs_cmd':                       value => $mkisofs_cmd_real;
    'DEFAULT/force_raw_images':                  value => $force_raw_images;
    'DEFAULT/virt_mkfs':                         value => $virt_mkfs;
    'DEFAULT/reserved_host_cpus':                value => $reserved_host_cpus;
    'DEFAULT/reserved_host_memory_mb':           value => $reserved_host_memory;
    'DEFAULT/reserved_host_disk_mb':             value => $reserved_host_disk;
    'DEFAULT/reserved_huge_pages':               value => $reserved_huge_pages_real;
    'DEFAULT/heal_instance_info_cache_interval': value => $heal_instance_info_cache_interval;
    'DEFAULT/update_resources_interval':         value => $update_resources_interval;
    'DEFAULT/reboot_timeout':                    value => $reboot_timeout;
    'DEFAULT/instance_build_timeout':            value => $instance_build_timeout;
    'DEFAULT/rescue_timeout':                    value => $rescue_timeout;
    'DEFAULT/resize_confirm_window':             value => $resize_confirm_window;
    'DEFAULT/shutdown_timeout':                  value => $shutdown_timeout;
    'DEFAULT/resume_guests_state_on_host_boot':  value => $resume_guests_state_on_host_boot;
    'DEFAULT/max_concurrent_builds':             value => $max_concurrent_builds;
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
    'DEFAULT/default_ephemeral_format':          value => $default_ephemeral_format;
    'compute/image_type_exclude_list':           value => $image_type_exclude_list_real;
    'DEFAULT/block_device_allocate_retries':     value => $block_device_allocate_retries;
    'DEFAULT/block_device_allocate_retries_interval':
      value => $block_device_allocate_retries_interval;
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
  }

  if $force_config_drive {
    nova_config { 'DEFAULT/force_config_drive': value => true }
  } else {
    nova_config { 'DEFAULT/force_config_drive': ensure => absent }
  }

  if $instance_usage_audit {
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

  $config_drive_format_real = pick($config_drive_format, $facts['os_service_default'])
  if is_service_default($config_drive_format_real) or $config_drive_format_real == 'iso9660' {
    ensure_packages($::nova::params::mkisofs_package_name, {
      tag => ['openstack', 'nova-support-package'],
    })
  }
  nova_config {
    'DEFAULT/config_drive_format': value => $config_drive_format_real;
  }

}
