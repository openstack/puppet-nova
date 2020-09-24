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
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, uml, xen
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
#   Defaults to 'host-model' if virt_type is set to kvm,
#   otherwise defaults to 'none'.
#
# [*cpu_models*]
#   (optional) The named libvirt CPU models (see names listed in
#   /usr/share/libvirt/cpu_map.xml). Only has effect if
#   cpu_mode="custom" and virt_type="kvm|qemu".
#   Defaults to []
#
# [*cpu_model_extra_flags*]
#   (optional) This allows specifying granular CPU feature flags when
#   specifying CPU models. Only has effect if cpu_mode is not set
#   to 'none'.
#   Defaults to undef
#
# [*snapshot_image_format*]
#   (optional) Format to save snapshots to. Some filesystems
#   have a preference and only operate on raw or qcow2
#   Defaults to $::os_service_default
#
# [*disk_cachemodes*]
#   (optional) A list of cachemodes for different disk types, e.g.
#   ["file=directsync", "block=none"]
#   If an empty list is specified, the disk_cachemodes directive
#   will be removed from nova.conf completely.
#   Defaults to an empty list
#
# [*hw_disk_discard*]
#   (optional) Discard option for nova managed disks. Need Libvirt(1.0.6)
#   Qemu1.5 (raw format) Qemu1.6(qcow2 format).
#   Defaults to $::os_service_default
#
# [*hw_machine_type*]
#   (optional) Option to specify a default machine type per host architecture.
#   Defaults to $::os_service_default
#
# [*inject_password*]
#   (optional) Inject the admin password at boot time, without an agent.
#   Defaults to false
#
# [*inject_key*]
#   (optional) Inject the ssh public key at boot time.
#   Defaults to false
#
# [*inject_partition*]
#   (optional) The partition to inject to : -2 => disable, -1 => inspect
#   (libguestfs only), 0 => not partitioned, >0 => partition
#   number (integer value)
#   Defaults to -2
#
# [*enabled_perf_events*]
#   (optional) This is a performance event list which could be used as monitor.
#   A string list. For example: ``enabled_perf_events = cmt, mbml, mbmt``
#   The supported events list can be found in
#   https://libvirt.org/html/libvirt-libvirt-domain.html ,
#   which you may need to search key words ``VIR_PERF_PARAM_*``
#   Defaults to $::os_service_default
#
# [*remove_unused_base_images*]
#   (optional) Should unused base images be removed?
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a boolean to remove or not the base images.
#   Defaults to $::os_service_default
#
# [*remove_unused_resized_minimum_age_seconds*]
#   (optional) Unused resized base images younger
#   than this will not be removed
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a integer or a string to define after
#   how many seconds it will be removed.
#   Defaults to $::os_service_default
#
# [*remove_unused_original_minimum_age_seconds*]
#   (optional) Unused unresized base images younger
#   than this will not be removed
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a integer or a string to define after
#   how many seconds it will be removed.
#   Defaults to $::os_service_default
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
#   Defaults to $::os_service_default
#
# [*manage_libvirt_services*]
#   (optional) Whether or not deploy Libvirt services.
#   In the case of micro-services, set it to False and use
#   nova::compute::libvirt::services + hiera to select what
#   you actually want to deploy.
#   Defaults to true for backward compatibility.
#
# [*log_outputs*]
#   (optional) Defines log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to undef
#
# [*rx_queue_size*]
#   (optional) virtio-net rx queue size
#   Valid values are 256, 512, 1024
#   Defaults to $::os_service_default
#
# [*tx_queue_size*]
#   (optional) virtio-net tx queue size
#   Valid values are 256, 512, 1024
#   Defaults to $::os_service_default
#
# [*file_backed_memory*]
#   (optional) Available capacity in MiB for file-backed memory.
#   Defaults to $::os_service_default
#
# [*volume_use_multipath*]
#   (optional) Use multipath connection of the
#   iSCSI or FC volume. Volumes can be connected in the
#   LibVirt as multipath devices.
#   Defaults to $::os_service_default
#
# [*nfs_mount_options*]
#   (optional) Mount options passed to the NFS client. See section of the
#   nfs man page for details.
#   Defaults to $::os_service_default
#
# [*num_pcie_ports*]
#  (optional) The number of PCIe ports an instance will get.
#  Libvirt allows a custom number of PCIe ports (pcie-root-port controllers) a
#  target instance will get. Some will be used by default, rest will be available
#  for hotplug use.
#  Defaults to $::os_service_default
#
# [*mem_stats_period_seconds*]
#   (optional) A number of seconds to memory usage statistics period,
#   zero or negative value mean to disable memory usage statistics.
#   Defaults to $::os_service_default
#
# [*log_filters*]
#   (optional) Defines a filter to select a different logging level
#   for a given category log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to undef
#
# [*tls_priority*]
#   (optional) Override the compile time default TLS priority string. The
#   default is usually "NORMAL" unless overridden at build time.
#   Only set this if it is desired for libvirt to deviate from
#   the global default settings.
#   Defaults to undef
#
# [*pmem_namespaces*]
#   (optional) Configure persistent memory(pmem) namespaces. These namespaces
#   must have been already created on the host. This config option is in the
#   following format: "$LABEL:$NSNAME[|$NSNAME][,$LABEL:$NSNAME[|$NSNAME]]"
#   $NSNAME is the name of the pmem namespace. $LABEL represents one resource
#   class, this is used to generate the resource class name as
#   CUSTOM_PMEM_NAMESPACE_$LABEL.
#   Defaults to $::os_service_default
#
# [*swtpm_enabled*]
#   (optional) Enable emulated Trusted Platform Module (TPM) for guests.
#   Defaults to $::os_service_default
#
# [*swtpm_user*]
#   (optional) Configure the user that the swtpm binary, used for emulated
#   Trusted Platform Module (TPM) functionality, runs as.
#   Defaults to $::os_service_default
#
# [*swtpm_group*]
#   (optional) Configure the group that the swtpm binary, used for emulated
#   Trusted Platform Module (TPM) functionality, runs as.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*libvirt_virt_type*]
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, uml, xen
#   Defaults to undef
#
# [*libvirt_cpu_mode*]
#   (optional) The libvirt CPU mode to configure.  Possible values
#   include custom, host-model, none, host-passthrough.
#   Defaults to 'host-model' if libvirt_virt_type is set to kvm,
#   Defaults to undef
#
# [*libvirt_cpu_model*]
#   (optional) The named libvirt CPU model (see names listed in
#   /usr/share/libvirt/cpu_map.xml). Only has effect if
#   cpu_mode="custom" and virt_type="kvm|qemu".
#   Defaults to undef
#
# [*libvirt_cpu_model_extra_flags*]
#   (optional) This allows specifying granular CPU feature flags when
#   specifying CPU models. Only has effect if cpu_mode is not set
#   to 'none'.
#   Defaults to undef
#
# [*libvirt_snapshot_image_format*]
#   (optional) Format to save snapshots to. Some filesystems
#   have a preference and only operate on raw or qcow2
#   Defaults to undef
#
# [*libvirt_disk_cachemodes*]
#   (optional) A list of cachemodes for different disk types, e.g.
#   ["file=directsync", "block=none"]
#   If an empty list is specified, the disk_cachemodes directive
#   will be removed from nova.conf completely.
#   Defaults to undef
#
# [*libvirt_hw_disk_discard*]
#   (optional) Discard option for nova managed disks. Need Libvirt(1.0.6)
#   Qemu1.5 (raw format) Qemu1.6(qcow2 format).
#   Defaults to undef
#
# [*libvirt_hw_machine_type*]
#   (optional) Option to specify a default machine type per host architecture.
#   Defaults to undef
#
# [*libvirt_inject_password*]
#   (optional) Inject the admin password at boot time, without an agent.
#   Defaults to undef
#
# [*libvirt_inject_key*]
#   (optional) Inject the ssh public key at boot time.
#   Defaults to undef
#
# [*libvirt_inject_partition*]
#   (optional) The partition to inject to : -2 => disable, -1 => inspect
#   (libguestfs only), 0 => not partitioned, >0 => partition
#   number (integer value)
#   Defaults to -2
#   Defaults to undef
#
# [*libvirt_enabled_perf_events*]
#   (optional) This is a performance event list which could be used as monitor.
#   A string list. For example: ``enabled_perf_events = cmt, mbml, mbmt``
#   The supported events list can be found in
#   https://libvirt.org/html/libvirt-libvirt-domain.html ,
#   which you may need to search key words ``VIR_PERF_PARAM_*``
#   Defaults to undef
#
class nova::compute::libvirt (
  $ensure_package                             = 'present',
  $virt_type                                  = 'kvm',
  $vncserver_listen                           = '127.0.0.1',
  $migration_support                          = false,
  $cpu_mode                                   = false,
  $cpu_models                                 = [],
  $cpu_model_extra_flags                      = undef,
  $snapshot_image_format                      = $::os_service_default,
  $disk_cachemodes                            = [],
  $hw_disk_discard                            = $::os_service_default,
  $hw_machine_type                            = $::os_service_default,
  $inject_password                            = false,
  $inject_key                                 = false,
  $inject_partition                           = -2,
  $enabled_perf_events                        = $::os_service_default,
  $remove_unused_base_images                  = $::os_service_default,
  $remove_unused_resized_minimum_age_seconds  = $::os_service_default,
  $remove_unused_original_minimum_age_seconds = $::os_service_default,
  $libvirt_service_name                       = $::nova::params::libvirt_service_name,
  $virtlock_service_name                      = $::nova::params::virtlock_service_name,
  $virtlog_service_name                       = $::nova::params::virtlog_service_name,
  $compute_driver                             = 'libvirt.LibvirtDriver',
  $preallocate_images                         = $::os_service_default,
  $manage_libvirt_services                    = true,
  $log_outputs                                = undef,
  $rx_queue_size                              = $::os_service_default,
  $tx_queue_size                              = $::os_service_default,
  $file_backed_memory                         = undef,
  $volume_use_multipath                       = $::os_service_default,
  $nfs_mount_options                          = $::os_service_default,
  $num_pcie_ports                             = $::os_service_default,
  $mem_stats_period_seconds                   = $::os_service_default,
  $log_filters                                = undef,
  $tls_priority                               = undef,
  $pmem_namespaces                            = $::os_service_default,
  $swtpm_enabled                              = $::os_service_default,
  $swtpm_user                                 = $::os_service_default,
  $swtpm_group                                = $::os_service_default,
  # DEPRECATED PARAMETERS
  $libvirt_virt_type                          = undef,
  $libvirt_cpu_mode                           = undef,
  $libvirt_cpu_model                          = undef,
  $libvirt_cpu_model_extra_flags              = undef,
  $libvirt_snapshot_image_format              = undef,
  $libvirt_disk_cachemodes                    = undef,
  $libvirt_hw_disk_discard                    = undef,
  $libvirt_hw_machine_type                    = undef,
  $libvirt_inject_password                    = undef,
  $libvirt_inject_key                         = undef,
  $libvirt_inject_partition                   = undef,
  $libvirt_enabled_perf_events                = undef,
) inherits nova::params {

  include nova::deps
  include nova::params

  if $libvirt_virt_type != undef {
    warning('The libvirt_virt_type parameter was deprecated and will be removed \
in a future release. Use the virt_type parameter instead')
    $virt_type_real = $libvirt_virt_type
  } else {
    $virt_type_real = $virt_type
  }

  if $libvirt_cpu_mode != undef {
    warning('The libvirt_cpu_mode parameter was deprecated and will be removed \
in a future release. Use the cpu_mode parameter instead')
    $cpu_mode_real = $libvirt_cpu_mode
  } else {
    $cpu_mode_real = $cpu_mode
  }

  if $libvirt_cpu_model_extra_flags != undef {
    warning('The libvirt_cpu_model_extra_flags parameter was deprecated and will be removed \
in a future release. Use the cpu_model_extra_flags parameter instead')
    $cpu_model_extra_flags_real = $libvirt_cpu_model_extra_flags
  } else {
    $cpu_model_extra_flags_real = $cpu_model_extra_flags
  }

  if $libvirt_snapshot_image_format != undef {
    warning('The libvirt_snapshot_image_format parameter was deprecated and will be removed \
in a future release. Use the snapshot_image_format parameter instead')
    $snapshot_image_format_real = $libvirt_snapshot_image_format
  } else {
    $snapshot_image_format_real = $snapshot_image_format
  }

  if $libvirt_disk_cachemodes != undef {
    warning('The libvirt_disk_cachemodes parameter was deprecated and will be removed \
in a future release. Use the disk_cachemodes parameter instead')
    $disk_cachemodes_real = $libvirt_disk_cachemodes
  } else {
    $disk_cachemodes_real = $disk_cachemodes
  }

  if $libvirt_hw_disk_discard != undef {
    warning('The libvirt_hw_disk_discard parameter was deprecated and will be removed \
in a future release. Use the hw_disk_discard parameter instead')
    $hw_disk_discard_real = $libvirt_hw_disk_discard
  } else {
    $hw_disk_discard_real = $hw_disk_discard
  }

  if $libvirt_hw_machine_type != undef {
    warning('The libvirt_hw_machine_type parameter was deprecated and will be removed \
in a future release. Use the hw_machine_type parameter instead')
    $hw_machine_type_real = $libvirt_hw_machine_type
  } else {
    $hw_machine_type_real = $hw_machine_type
  }

  if $libvirt_inject_password != undef {
    warning('The libvirt_inject_password parameter was deprecated and will be removed \
in a future release. Use the inject_password parameter instead')
    $inject_password_real = $libvirt_inject_password
  } else {
    $inject_password_real = $inject_password
  }

  if $libvirt_inject_key != undef {
    warning('The libvirt_inject_key parameter was deprecated and will be removed \
in a future release. Use the inject_key parameter instead')
    $inject_key_real = $libvirt_inject_key
  } else {
    $inject_key_real = $inject_key
  }

  if $libvirt_inject_partition != undef {
    warning('The libvirt_inject_partition parameter was deprecated and will be removed \
in a future release. Use the inject_partition parameter instead')
    $inject_partition_real = $libvirt_inject_partition
  } else {
    $inject_partition_real = $inject_partition
  }

  if $libvirt_enabled_perf_events != undef {
    warning('The libvirt_enabled_perf_events parameter was deprecated and will be removed \
in a future release. Use the enabled_perf_events parameter instead')
    $enabled_perf_events_real = $libvirt_enabled_perf_events
  } else {
    $enabled_perf_events_real = $enabled_perf_events
  }

  # cpu_mode has different defaults depending on hypervisor.
  if !$cpu_mode_real {
    case $virt_type_real {
      'kvm': {
        $cpu_mode_default = 'host-model'
      }
      default: {
        $cpu_mode_default = 'none'
      }
    }
  } else {
    $cpu_mode_default = $cpu_mode_real
  }

  if($::osfamily == 'Debian') {
    package { "nova-compute-${virt_type_real}":
      ensure => $ensure_package,
      tag    => ['openstack', 'nova-package'],
    }
  }

  if $migration_support {
    include nova::migration::libvirt
  }

  if $log_outputs {
    libvirtd_config {
      'log_outputs': value => "\"${log_outputs}\"";
    }
  } else {
    libvirtd_config {
      'log_outputs': ensure => 'absent';
    }
  }

  if $log_filters {
    libvirtd_config {
      'log_filters': value => "\"${log_filters}\"";
    }
  } else {
    libvirtd_config {
      'log_filters': ensure => 'absent';
    }
  }

  if $tls_priority {
    libvirtd_config {
      'tls_priority': value => "\"${tls_priority}\"";
    }
  } else {
    libvirtd_config {
      'tls_priority': ensure => 'absent';
    }
  }

  unless $rx_queue_size == $::os_service_default or $rx_queue_size in [256, 512, 1024] {
    fail("Invalid rx_queue_size parameter: ${rx_queue_size}")
  }

  unless $tx_queue_size == $::os_service_default or $tx_queue_size in [256, 512, 1024] {
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
      libvirt_virt_type     => $virt_type_real,
    }
  }

  nova_config {
    'DEFAULT/compute_driver':           value => $compute_driver;
    'DEFAULT/preallocate_images':       value => $preallocate_images;
    'vnc/server_listen':                value => $vncserver_listen;
    'libvirt/virt_type':                value => $virt_type_real;
    'libvirt/cpu_mode':                 value => $cpu_mode_default;
    'libvirt/snapshot_image_format':    value => $snapshot_image_format_real;
    'libvirt/inject_password':          value => $inject_password_real;
    'libvirt/inject_key':               value => $inject_key_real;
    'libvirt/inject_partition':         value => $inject_partition_real;
    'libvirt/hw_disk_discard':          value => $hw_disk_discard_real;
    'libvirt/hw_machine_type':          value => $hw_machine_type_real;
    'libvirt/enabled_perf_events':      value => join(any2array($enabled_perf_events_real), ',');
    'libvirt/rx_queue_size':            value => $rx_queue_size;
    'libvirt/tx_queue_size':            value => $tx_queue_size;
    'libvirt/file_backed_memory':       value => $file_backed_memory;
    'libvirt/volume_use_multipath':     value => $volume_use_multipath;
    'libvirt/nfs_mount_options':        value => $nfs_mount_options;
    'libvirt/num_pcie_ports':           value => $num_pcie_ports;
    'libvirt/mem_stats_period_seconds': value => $mem_stats_period_seconds;
    'libvirt/pmem_namespaces':          value => $pmem_namespaces;
    'libvirt/swtpm_enabled':            value => $swtpm_enabled;
    'libvirt/swtpm_user'   :            value => $swtpm_user;
    'libvirt/swtpm_group':              value => $swtpm_group;
  }

  if $libvirt_cpu_model != undef {
    warning('The libvirt_cpu_model parameter was deprecated an will be removed \
in a future release. Use the cpu_models parameter instead')
    validate_legacy(String, 'validate_string', $libvirt_cpu_model)
    $cpu_models_real = [$libvirt_cpu_model]
  } else {
    validate_legacy(Array, 'validate_array', $cpu_models)
    $cpu_models_real = $cpu_models
  }

  # cpu_model param is only valid if cpu_mode=custom
  # otherwise it should be commented out
  if $cpu_mode_default == 'custom' {
    if empty($cpu_models_real){
      $cpu_models_value = $::os_service_default
    } else {
      $cpu_models_value = join($cpu_models_real, ',')
    }
  } else {
    if !empty($cpu_models_real) {
      warning('$cpu_models requires that $cpu_mode => "custom" and will be ignored')
    }
    $cpu_models_value = $::os_service_default
  }
  nova_config {
    'libvirt/cpu_model' : ensure => absent;
    'libvirt/cpu_models': value  => $cpu_models_value;
  }

  if $cpu_mode_default != 'none' and $cpu_model_extra_flags_real {
    validate_legacy(String, 'validate_string', $cpu_model_extra_flags_real)
    nova_config {
      'libvirt/cpu_model_extra_flags': value => $cpu_model_extra_flags_real;
    }
  } else {
    nova_config {
      'libvirt/cpu_model_extra_flags': ensure => absent;
    }
    if $cpu_model_extra_flags_real {
      warning('$cpu_model_extra_flags requires that $cpu_mode is not set to "none" and will be ignored')
    }
  }

  if size($disk_cachemodes_real) > 0 {
    nova_config {
      'libvirt/disk_cachemodes': value => join($disk_cachemodes_real, ',');
    }
  } else {
    nova_config {
      'libvirt/disk_cachemodes': ensure => absent;
    }
  }

  if $remove_unused_resized_minimum_age_seconds == undef {
    warning('Use $::os_service_default instead of undef for the remove_unused_resized_minimum_age_seconds \
parameter. The current behavior for undef will be changed in a future release')
    nova_config {
      'libvirt/remove_unused_resized_minimum_age_seconds': ensure => absent;
    }
  } else {
    nova_config {
      'libvirt/remove_unused_resized_minimum_age_seconds': value => $remove_unused_resized_minimum_age_seconds;
    }
  }

  if $remove_unused_base_images == undef {
    warning('Use $::os_service_default instead of undef for the remove_unused_base_images \
parameter. The current behavior for undef will be changed in a future release')
    nova_config {
      'DEFAULT/remove_unused_base_images': ensure => absent;
    }
  } else {
    nova_config {
      'DEFAULT/remove_unused_base_images': value => $remove_unused_base_images;
    }
  }

  if $remove_unused_original_minimum_age_seconds == undef {
    warning('Use $::os_service_default instead of undef for the remove_unused_original_minimum_age_seconds \
parameter. The current behavior for undef will be changed in a future release')
    nova_config {
      'DEFAULT/remove_unused_original_minimum_age_seconds': ensure => absent;
    }
  } else {
    nova_config {
      'DEFAULT/remove_unused_original_minimum_age_seconds': value => $remove_unused_original_minimum_age_seconds;
    }
  }
}
