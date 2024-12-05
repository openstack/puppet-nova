# == Class: nova::compute::libvirt
#
# Install and manage nova-compute guests managed
# by libvirt
#
# === Parameters:
#
# [*ensure_package*]
#   (optional) The state of nova packages
#   Defaults to 'present'
#
# [*virt_type*]
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, parallels
#   Defaults to 'kvm'
#
# [*vncserver_listen*]
#   (optional) IP address on which instance vncservers should listen
#   Defaults to '127.0.0.1'
#
# [*migration_support*]
#   (optional) Whether to support virtual machine migration
#   Defaults to false
#
# [*cpu_mode*]
#   (optional) The libvirt CPU mode to configure.  Possible values
#   include custom, host-model, none, host-passthrough.
#   Defaults to 'host-model' if virt_type is set to qemu or kvm,
#   otherwise defaults to 'none'.
#
# [*cpu_models*]
#   (optional) The named libvirt CPU models (see names listed in
#   /usr/share/libvirt/cpu_map.xml). This option requires
#   cpu_mode="custom" and virt_type="kvm|qemu".
#   Defaults to []
#
# [*cpu_model_extra_flags*]
#   (optional) This allows specifying granular CPU feature flags when
#   specifying CPU models. Only has effect if cpu_mode is not set
#   to 'none'.
#   Defaults to undef
#
# [*cpu_power_management*]
#   (optional) Use libvirt to manage CPU cores performance
#   Defaults to $::os_service_default
#
# [*cpu_power_management_strategy*]
#   (optional) Tuning strategy to reduce CPU power consumption when unused.
#   Defaults to $::os_service_default
#
# [*cpu_power_governor_low*]
#   (optional) Governor to use in order to reduce CPU power consumption.
#   Defaults to $::os_service_default
#
# [*cpu_power_governor_high*]
#   (optional) Goernor to use in order to have best CPU performance.
#   Defaults to $::os_service_default
#
# [*snapshot_image_format*]
#   (optional) Format to save snapshots to. Some filesystems
#   have a preference and only operate on raw or qcow2
#   Defaults to $facts['os_service_default']
#
# [*snapshots_directory*]
#   (optional) Location where libvirt driver will store snapshots before
#   uploading them to image service
#   Defaults to $facts['os_service_default']
#
# [*disk_cachemodes*]
#   (optional) A list of cachemodes for different disk types, e.g.
#   ["file=directsync", "block=none"]
#   Defaults to $facts['os_service_default']
#
# [*hw_disk_discard*]
#   (optional) Discard option for nova managed disks. Need Libvirt(1.0.6)
#   Qemu1.5 (raw format) Qemu1.6(qcow2 format).
#   Defaults to $facts['os_service_default']
#
# [*hw_machine_type*]
#   (optional) Option to specify a default machine type per host architecture.
#   Defaults to $facts['os_service_default']
#
# [*sysinfo_serial*]
#   (optional) Option to specify a serial number entry generation method.
#   Defaults to $facts['os_service_default']
#
# [*inject_password*]
#   (optional) Inject the admin password at boot time, without an agent.
#   Defaults to $facts['os_service_default']
#
# [*inject_key*]
#   (optional) Inject the ssh public key at boot time.
#   Defaults to $facts['os_service_default']
#
# [*inject_partition*]
#   (optional) The partition to inject to : -2 => disable, -1 => inspect
#   (libguestfs only), 0 => not partitioned, >0 => partition
#   number (integer value)
#   Defaults to $facts['os_service_default']
#
# [*enabled_perf_events*]
#   (optional) This is a performance event list which could be used as monitor.
#   A string list. For example: ``enabled_perf_events = cmt, mbml, mbmt``
#   The supported events list can be found in
#   https://libvirt.org/html/libvirt-libvirt-domain.html ,
#   which you may need to search key words ``VIR_PERF_PARAM_*``
#   Defaults to $facts['os_service_default']
#
# [*device_detach_attempts*]
#   (optional) Maximum number of attempts the driver tries to detach a device
#   in libvirt.
#   Defaults to $facts['os_service_default']
#
# [*device_detach_timeout*]
#   (optional) Maximum number of seconds the driver waits for the success or
#   the failure event from libvirt for a given device detach attempt before
#   it re-trigger the detach.
#   Defaults to $facts['os_service_default']
#
# [*libvirt_service_name*]
#   (optional) libvirt service name.
#   Defaults to $::nova::params::libvirt_service_name
#
# [*virtlock_service_name*]
#   (optional) virtlock service name.
#   Defaults to $::nova::params::virtlock_service_name
#
# [*virtlog_service_name*]
#   (optional) virtlog service name.
#   Defaults to $::nova::params::virtlog_service_name
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'libvirt.LibvirtDriver'
#
# [*preallocate_images*]
#   (optional) The image preallocation mode to use.
#   Valid values are 'none' or 'space'.
#   Defaults to $facts['os_service_default']
#
# [*manage_libvirt_services*]
#   (optional) Whether or not deploy Libvirt services.
#   In the case of micro-services, set it to False and use
#   nova::compute::libvirt::services + hiera to select what
#   you actually want to deploy.
#   Defaults to true for backward compatibility.
#
# [*rx_queue_size*]
#   (optional) virtio-net rx queue size
#   Valid values are 256, 512, 1024
#   Defaults to $facts['os_service_default']
#
# [*tx_queue_size*]
#   (optional) virtio-net tx queue size
#   Valid values are 256, 512, 1024
#   Defaults to $facts['os_service_default']
#
# [*file_backed_memory*]
#   (optional) Available capacity in MiB for file-backed memory.
#   Defaults to $facts['os_service_default']
#
# [*images_type*]
#   (optional) VM Images format.
#   Valid Values are raw, flat, qcow2, lvm, rbd, ploop, default
#   Defaults to $facts['os_service_default']
#
# [*volume_use_multipath*]
#   (optional) Use multipath connection of the
#   iSCSI or FC volume. Volumes can be connected in the
#   LibVirt as multipath devices.
#   Defaults to $facts['os_service_default']
#
# [*num_volume_scan_tries*]
#   (optional) Number of times to scan given storage protocol to find volume.
#   Defaults to $facts['os_service_default']
#
# [*nfs_mount_options*]
#   (optional) Mount options passed to the NFS client. See section of the
#   nfs man page for details.
#   Defaults to $facts['os_service_default']
#
# [*num_pcie_ports*]
#  (optional) The number of PCIe ports an instance will get.
#  Libvirt allows a custom number of PCIe ports (pcie-root-port controllers) a
#  target instance will get. Some will be used by default, rest will be available
#  for hotplug use.
#  Defaults to $facts['os_service_default']
#
# [*mem_stats_period_seconds*]
#   (optional) A number of seconds to memory usage statistics period,
#   zero or negative value mean to disable memory usage statistics.
#   Defaults to $facts['os_service_default']
#
# [*pmem_namespaces*]
#   (optional) Configure persistent memory(pmem) namespaces. These namespaces
#   must have been already created on the host. This config option is in the
#   following format: "$LABEL:$NSNAME[|$NSNAME][,$LABEL:$NSNAME[|$NSNAME]]"
#   $NSNAME is the name of the pmem namespace. $LABEL represents one resource
#   class, this is used to generate the resource class name as
#   CUSTOM_PMEM_NAMESPACE_$LABEL.
#   Defaults to $facts['os_service_default']
#
# [*swtpm_enabled*]
#   (optional) Enable emulated Trusted Platform Module (TPM) for guests.
#   Defaults to $facts['os_service_default']
#
# [*swtpm_user*]
#   (optional) Configure the user that the swtpm binary, used for emulated
#   Trusted Platform Module (TPM) functionality, runs as.
#   Defaults to $facts['os_service_default']
#
# [*swtpm_group*]
#   (optional) Configure the group that the swtpm binary, used for emulated
#   Trusted Platform Module (TPM) functionality, runs as.
#   Defaults to $facts['os_service_default']
#
# [*max_queues*]
#   (optional) The maximum number of virtio queue pairs that can be enabled
#   when creating a multiqueue guest. The number of virtio queues allocated
#   will be the lesser of the CPUs requested by the guest and the max value
#   defined. By default, this value is set to none meaning the legacy limits
#   based on the reported kernel major version will be used.
#   Defaults to $facts['os_service_default']
#
# [*num_memory_encrypted_guests*]
#   (optional) The maximum number of guests with encrypted memory which can
#   run concurrently on this compute host.
#   Defaults to $facts['os_service_default']
#
# [*wait_soft_reboot_seconds*]
#   (optional) Number of seconds to wait for instance to shut down after soft
#   reboot request is made.
#   Defaults to $facts['os_service_default']
#
# [*tb_cache_size*]
#   (optional) The tb-cache size (in MiB) of each guest VM.
#   Defaults to $facts['os_service_default']
#
class nova::compute::libvirt (
  $ensure_package                             = 'present',
  Nova::VirtType $virt_type                   = 'kvm',
  String[1] $vncserver_listen                 = '127.0.0.1',
  Boolean $migration_support                  = false,
  Optional[Nova::CpuMode] $cpu_mode           = undef,
  Array[String[1]] $cpu_models                = [],
  $cpu_model_extra_flags                      = undef,
  $cpu_power_management                       = $facts['os_service_default'],
  $cpu_power_management_strategy              = $facts['os_service_default'],
  $cpu_power_governor_low                     = $facts['os_service_default'],
  $cpu_power_governor_high                    = $facts['os_service_default'],
  $snapshot_image_format                      = $facts['os_service_default'],
  $snapshots_directory                        = $facts['os_service_default'],
  $disk_cachemodes                            = $facts['os_service_default'],
  $hw_disk_discard                            = $facts['os_service_default'],
  $hw_machine_type                            = $facts['os_service_default'],
  $sysinfo_serial                             = $facts['os_service_default'],
  $inject_password                            = $facts['os_service_default'],
  $inject_key                                 = $facts['os_service_default'],
  $inject_partition                           = $facts['os_service_default'],
  $enabled_perf_events                        = $facts['os_service_default'],
  $device_detach_attempts                     = $facts['os_service_default'],
  $device_detach_timeout                      = $facts['os_service_default'],
  $libvirt_service_name                       = $::nova::params::libvirt_service_name,
  $virtlock_service_name                      = $::nova::params::virtlock_service_name,
  $virtlog_service_name                       = $::nova::params::virtlog_service_name,
  $compute_driver                             = 'libvirt.LibvirtDriver',
  $preallocate_images                         = $facts['os_service_default'],
  Boolean $manage_libvirt_services            = true,
  $rx_queue_size                              = $facts['os_service_default'],
  $tx_queue_size                              = $facts['os_service_default'],
  $file_backed_memory                         = $facts['os_service_default'],
  $images_type                                = $facts['os_service_default'],
  $volume_use_multipath                       = $facts['os_service_default'],
  $num_volume_scan_tries                      = $facts['os_service_default'],
  $nfs_mount_options                          = $facts['os_service_default'],
  $num_pcie_ports                             = $facts['os_service_default'],
  $mem_stats_period_seconds                   = $facts['os_service_default'],
  $pmem_namespaces                            = $facts['os_service_default'],
  $swtpm_enabled                              = $facts['os_service_default'],
  $swtpm_user                                 = $facts['os_service_default'],
  $swtpm_group                                = $facts['os_service_default'],
  $max_queues                                 = $facts['os_service_default'],
  $num_memory_encrypted_guests                = $facts['os_service_default'],
  $wait_soft_reboot_seconds                   = $facts['os_service_default'],
  $tb_cache_size                              = $facts['os_service_default'],
) inherits nova::params {

  include nova::deps
  include nova::params

  # cpu_mode has different defaults depending on hypervisor.
  if !$cpu_mode {
    case $virt_type {
      'qemu', 'kvm': {
        $cpu_mode_real = 'host-model'
      }
      default: {
        $cpu_mode_real = 'none'
      }
    }
  } else {
    if $cpu_mode != 'none' and !($virt_type in ['qemu', 'kvm']) {
      fail("\$virt_type = \"${virt_type}\" supports only \$cpu_mode = \"none\"")
    }
    $cpu_mode_real = $cpu_mode
  }

  if($facts['os']['family'] == 'Debian') {
    package { "nova-compute-${virt_type}":
      ensure => $ensure_package,
      tag    => ['openstack', 'nova-package'],
    }
  }

  if $migration_support {
    include nova::migration::libvirt
  }

  unless $rx_queue_size == $facts['os_service_default'] or $rx_queue_size in [256, 512, 1024] {
    fail("Invalid rx_queue_size parameter: ${rx_queue_size}")
  }

  unless $tx_queue_size == $facts['os_service_default'] or $tx_queue_size in [256, 512, 1024] {
    fail("Invalid_tx_queue_size parameter: ${tx_queue_size}")
  }

  # manage_libvirt_services is here for backward compatibility to support
  # deployments that do not include nova::compute::libvirt::services
  #
  # If you're using hiera:
  #  - set nova::compute::libvirt::manage_libvirt_services to false
  #  - include nova::compute::libvirt::services in your composition layer
  #  - select which services you want to deploy with
  #    ::nova::compute::libvirt::services:* parameters.
  #
  # If you're not using hiera:
  #  - set nova::compute::libvirt::manage_libvirt_services to true (default).
  #  - select which services you want to deploy with
  #    ::nova::compute::libvirt::*_service_name parameters.
  if $manage_libvirt_services {
    class { 'nova::compute::libvirt::services':
      libvirt_service_name  => $libvirt_service_name,
      virtlock_service_name => $virtlock_service_name,
      virtlog_service_name  => $virtlog_service_name,
      libvirt_virt_type     => $virt_type,
    }
  }

  if defined('Class[nova::compute::rbd]') {
    if $::nova::compute::rbd::ephemeral_storage and $images_type != 'rbd' {
      fail('nova::compute::libvirt::images_type should be rbd if rbd ephemeral storage is used.')
    }
  }

  $disk_cachemodes_real = $disk_cachemodes ? {
    Hash    => join(join_keys_to_values($disk_cachemodes, '='), ','),
    default => join(any2array($disk_cachemodes), ','),
  }
  $hw_machine_type_real = $hw_machine_type ? {
    Hash    => join(join_keys_to_values($hw_machine_type, '='), ','),
    default => join(any2array($hw_machine_type), ','),
  }

  nova_config {
    'DEFAULT/compute_driver':                value => $compute_driver;
    'DEFAULT/preallocate_images':            value => $preallocate_images;
    'vnc/server_listen':                     value => $vncserver_listen;
    'libvirt/virt_type':                     value => $virt_type;
    'libvirt/cpu_mode':                      value => $cpu_mode_real;
    'libvirt/cpu_power_management':          value => $cpu_power_management;
    'libvirt/cpu_power_management_strategy': value => $cpu_power_management_strategy;
    'libvirt/cpu_power_governor_low':        value => $cpu_power_governor_low;
    'libvirt/cpu_power_governor_high':       value => $cpu_power_governor_high;
    'libvirt/snapshot_image_format':         value => $snapshot_image_format;
    'libvirt/snapshots_directory':           value => $snapshots_directory;
    'libvirt/disk_cachemodes':               value => $disk_cachemodes_real;
    'libvirt/inject_password':               value => $inject_password;
    'libvirt/inject_key':                    value => $inject_key;
    'libvirt/inject_partition':              value => $inject_partition;
    'libvirt/hw_disk_discard':               value => $hw_disk_discard;
    'libvirt/hw_machine_type':               value => $hw_machine_type_real;
    'libvirt/sysinfo_serial':                value => $sysinfo_serial;
    'libvirt/enabled_perf_events':           value => join(any2array($enabled_perf_events), ',');
    'libvirt/device_detach_attempts':        value => $device_detach_attempts;
    'libvirt/device_detach_timeout':         value => $device_detach_timeout;
    'libvirt/rx_queue_size':                 value => $rx_queue_size;
    'libvirt/tx_queue_size':                 value => $tx_queue_size;
    'libvirt/file_backed_memory':            value => $file_backed_memory;
    'libvirt/images_type':                   value => $images_type;
    'libvirt/volume_use_multipath':          value => $volume_use_multipath;
    'libvirt/num_volume_scan_tries':         value => $num_volume_scan_tries;
    'libvirt/nfs_mount_options':             value => $nfs_mount_options;
    'libvirt/num_pcie_ports':                value => $num_pcie_ports;
    'libvirt/mem_stats_period_seconds':      value => $mem_stats_period_seconds;
    'libvirt/pmem_namespaces':               value => join(any2array($pmem_namespaces), ',');
    'libvirt/swtpm_enabled':                 value => $swtpm_enabled;
    'libvirt/swtpm_user'   :                 value => $swtpm_user;
    'libvirt/swtpm_group':                   value => $swtpm_group;
    'libvirt/max_queues':                    value => $max_queues;
    'libvirt/num_memory_encrypted_guests':   value => $num_memory_encrypted_guests;
    'libvirt/wait_soft_reboot_seconds':      value => $wait_soft_reboot_seconds;
    'libvirt/tb_cache_size':                 value => $tb_cache_size;
  }

  if !empty($cpu_models) {
    if $cpu_mode_real != 'custom' {
      fail('$cpu_models requires that $cpu_mode is "custom"')
    }
    $cpu_models_real = join($cpu_models, ',')
  } else {
    if $cpu_mode_real == 'custom' {
      fail('$cpu_models is required when $cpu_mode is "custom"')
    }
    $cpu_models_real = $facts['os_service_default']
  }

  nova_config {
    'libvirt/cpu_models': value => $cpu_models_real;
  }

  # cpu_model_extra_flags is only valid if cpu_mode!=none
  # otherwise it should be commented out
  if $cpu_mode_real != 'none' and $cpu_model_extra_flags {
    $cpu_model_extra_flags_real = join(any2array($cpu_model_extra_flags), ',')
  } else {
    if $cpu_model_extra_flags {
      warning('$cpu_model_extra_flags requires that $cpu_mode is not set to "none" and will be ignored')
    }
    $cpu_model_extra_flags_real = $facts['os_service_default']
  }
  nova_config {
    'libvirt/cpu_model_extra_flags': value => $cpu_model_extra_flags_real;
  }
}
