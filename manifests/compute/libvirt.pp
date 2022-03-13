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
# [*snapshots_directory*]
#   (optional) Location where libvirt driver will store snapshots before
#   uploading them to image service
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
# [*device_detach_attempts*]
#   (optional) Maximum number of attempts the driver tries to detach a device
#   in libvirt.
#   Defaults to $::os_service_default
#
# [*device_detach_timeout*]
#   (optional) Maximum number of seconds the driver waits for the success or
#   the failure event from libvirt for a given device detach attempt before
#   it re-trigger the detach.
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
# [*modular_libvirt*]
#   (optional) Whether to enable modular libvirt daemons or use monolithic
#   libvirt daemon.
#   Defaults to $::nova::params::modular_libvirt
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
# [*images_type*]
#   (optional) VM Images format.
#   Valid Values are raw, flat, qcow2, lvm, rbd, ploop, default
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
# [*log_outputs*]
#   (optional) Defines log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to $::os_service_default
#
# [*log_filters*]
#   (optional) Defines a filter to select a different logging level
#   for a given category log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to $::os_service_default
#
# [*tls_priority*]
#   (optional) Override the compile time default TLS priority string. The
#   default is usually "NORMAL" unless overridden at build time.
#   Only set this if it is desired for libvirt to deviate from
#   the global default settings.
#   Defaults to $::os_service_default
#
# [*ovs_timeout*]
#   (optional) A timeout for openvswitch calls made by libvirt
#   Defaults to $::os_service_default
#
# [*max_queues*]
#   (optional) The maximum number of virtio queue pairs that can be enabled
#   when creating a multiqueue guest. The number of virtio queues allocated
#   will be the lesser of the CPUs requested by the guest and the max value
#   defined. By default, this value is set to none meaning the legacy limits
#   based on the reported kernel major version will be used.
#   Defaults to $::os_service_default
#
# [*num_memory_encrypted_guests*]
#   (optional) The maximum number of guests with encrypted memory which can
#   run concurrently on this compute host.
#   Defaults to $::os_service_default
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
  $snapshots_directory                        = $::os_service_default,
  $disk_cachemodes                            = [],
  $hw_disk_discard                            = $::os_service_default,
  $hw_machine_type                            = $::os_service_default,
  $inject_password                            = false,
  $inject_key                                 = false,
  $inject_partition                           = -2,
  $enabled_perf_events                        = $::os_service_default,
  $device_detach_attempts                     = $::os_service_default,
  $device_detach_timeout                      = $::os_service_default,
  $libvirt_service_name                       = $::nova::params::libvirt_service_name,
  $virtlock_service_name                      = $::nova::params::virtlock_service_name,
  $virtlog_service_name                       = $::nova::params::virtlog_service_name,
  $modular_libvirt                            = $::nova::params::modular_libvirt,
  $compute_driver                             = 'libvirt.LibvirtDriver',
  $preallocate_images                         = $::os_service_default,
  $manage_libvirt_services                    = true,
  $rx_queue_size                              = $::os_service_default,
  $tx_queue_size                              = $::os_service_default,
  $file_backed_memory                         = undef,
  $images_type                                = $::os_service_default,
  $volume_use_multipath                       = $::os_service_default,
  $nfs_mount_options                          = $::os_service_default,
  $num_pcie_ports                             = $::os_service_default,
  $mem_stats_period_seconds                   = $::os_service_default,
  $pmem_namespaces                            = $::os_service_default,
  $swtpm_enabled                              = $::os_service_default,
  $swtpm_user                                 = $::os_service_default,
  $swtpm_group                                = $::os_service_default,
  $log_outputs                                = $::os_service_default,
  $log_filters                                = $::os_service_default,
  $tls_priority                               = $::os_service_default,
  $ovs_timeout                                = $::os_service_default,
  $max_queues                                 = $::os_service_default,
  $num_memory_encrypted_guests                = $::os_service_default,
) inherits nova::params {

  include nova::deps
  include nova::params

  # cpu_mode has different defaults depending on hypervisor.
  if !$cpu_mode {
    case $virt_type {
      'kvm': {
        $cpu_mode_default = 'host-model'
      }
      default: {
        $cpu_mode_default = 'none'
      }
    }
  } else {
    $cpu_mode_default = $cpu_mode
  }

  if($::osfamily == 'Debian') {
    package { "nova-compute-${virt_type}":
      ensure => $ensure_package,
      tag    => ['openstack', 'nova-package'],
    }
  }

  if $migration_support {
    include nova::migration::libvirt
  }

  [
    'log_outputs',
    'log_filters',
    'tls_priority',
    'ovs_timeout',
  ].each |String $libvirtd_opt| {
    if getvar($libvirtd_opt) == undef {
      warning("Usage of undef for ${libvirtd_opt} has been deprecated.")
    }
  }

  if !$modular_libvirt {
    libvirtd_config {
      'log_outputs':  value => pick($log_outputs, $::os_service_default), quote => true;
      'log_filters':  value => pick($log_filters, $::os_service_default), quote => true;
      'tls_priority': value => pick($tls_priority, $::os_service_default), quote => true;
      'ovs_timeout':  value => pick($ovs_timeout, $::os_service_default);
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
      libvirt_virt_type     => $virt_type,
    }
  }

  if defined('Class[nova::compute::rbd]') {
    if $::nova::compute::rbd::ephemeral_storage and $images_type != 'rbd' {
      fail('nova::compute::libvirt::images_type should be rbd if rbd ephemeral storage is used.')
    }
  }

  nova_config {
    'DEFAULT/compute_driver':              value => $compute_driver;
    'DEFAULT/preallocate_images':          value => $preallocate_images;
    'vnc/server_listen':                   value => $vncserver_listen;
    'libvirt/virt_type':                   value => $virt_type;
    'libvirt/cpu_mode':                    value => $cpu_mode_default;
    'libvirt/snapshot_image_format':       value => $snapshot_image_format;
    'libvirt/snapshots_directory':         value => $snapshots_directory;
    'libvirt/inject_password':             value => $inject_password;
    'libvirt/inject_key':                  value => $inject_key;
    'libvirt/inject_partition':            value => $inject_partition;
    'libvirt/hw_disk_discard':             value => $hw_disk_discard;
    'libvirt/hw_machine_type':             value => $hw_machine_type;
    'libvirt/enabled_perf_events':         value => join(any2array($enabled_perf_events), ',');
    'libvirt/device_detach_attempts':      value => $device_detach_attempts;
    'libvirt/device_detach_timeout':       value => $device_detach_timeout;
    'libvirt/rx_queue_size':               value => $rx_queue_size;
    'libvirt/tx_queue_size':               value => $tx_queue_size;
    'libvirt/file_backed_memory':          value => $file_backed_memory;
    'libvirt/images_type':                 value => $images_type;
    'libvirt/volume_use_multipath':        value => $volume_use_multipath;
    'libvirt/nfs_mount_options':           value => $nfs_mount_options;
    'libvirt/num_pcie_ports':              value => $num_pcie_ports;
    'libvirt/mem_stats_period_seconds':    value => $mem_stats_period_seconds;
    'libvirt/pmem_namespaces':             value => join(any2array($pmem_namespaces), ',');
    'libvirt/swtpm_enabled':               value => $swtpm_enabled;
    'libvirt/swtpm_user'   :               value => $swtpm_user;
    'libvirt/swtpm_group':                 value => $swtpm_group;
    'libvirt/max_queues':                  value => $max_queues;
    'libvirt/num_memory_encrypted_guests': value => $num_memory_encrypted_guests;
  }

  validate_legacy(Array, 'validate_array', $cpu_models)
  # cpu_model param is only valid if cpu_mode=custom
  # otherwise it should be commented out
  if $cpu_mode_default == 'custom' {
    if empty($cpu_models){
      $cpu_models_real = $::os_service_default
    } else {
      $cpu_models_real = join($cpu_models, ',')
    }
  } else {
    if !empty($cpu_models) {
      warning('$cpu_models requires that $cpu_mode => "custom" and will be ignored')
    }
    $cpu_models_real = $::os_service_default
  }
  nova_config {
    'libvirt/cpu_models': value  => $cpu_models_real;
  }

  if $cpu_mode_default != 'none' and $cpu_model_extra_flags {
    validate_legacy(String, 'validate_string', $cpu_model_extra_flags)
    nova_config {
      'libvirt/cpu_model_extra_flags': value => $cpu_model_extra_flags;
    }
  } else {
    nova_config {
      'libvirt/cpu_model_extra_flags': ensure => absent;
    }
    if $cpu_model_extra_flags {
      warning('$cpu_model_extra_flags requires that $cpu_mode is not set to "none" and will be ignored')
    }
  }

  if size($disk_cachemodes) > 0 {
    nova_config {
      'libvirt/disk_cachemodes': value => join($disk_cachemodes, ',');
    }
  } else {
    nova_config {
      'libvirt/disk_cachemodes': ensure => absent;
    }
  }
}
