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
# [*libvirt_virt_type*]
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
# [*libvirt_cpu_mode*]
#   (optional) The libvirt CPU mode to configure.  Possible values
#   include custom, host-model, none, host-passthrough.
#   Defaults to 'host-model' if libvirt_virt_type is set to kvm,
#   otherwise defaults to 'none'.
#
# [*libvirt_cpu_model*]
#   (optional) The named libvirt CPU model (see names listed in
#   /usr/share/libvirt/cpu_map.xml). Only has effect if
#   cpu_mode="custom" and virt_type="kvm|qemu".
#   Defaults to undef
#
# [*libvirt_disk_cachemodes*]
#   (optional) A list of cachemodes for different disk types, e.g.
#   ["file=directsync", "block=none"]
#   If an empty list is specified, the disk_cachemodes directive
#   will be removed from nova.conf completely.
#   Defaults to an empty list
#
# [*libvirt_hw_disk_discard*]
#   (optional) Discard option for nova managed disks. Need Libvirt(1.0.6)
#   Qemu1.5 (raw format) Qemu1.6(qcow2 format).
#   Defaults to $::os_service_default
#
# [*libvirt_inject_password*]
#   (optional) Inject the admin password at boot time, without an agent.
#   Defaults to false
#
# [*libvirt_inject_key*]
#   (optional) Inject the ssh public key at boot time.
#   Defaults to false
#
# [*libvirt_inject_partition*]
#   (optional) The partition to inject to : -2 => disable, -1 => inspect
#   (libguestfs only), 0 => not partitioned, >0 => partition
#   number (integer value)
#   Defaults to -2
#
# [*remove_unused_base_images*]
#   (optional) Should unused base images be removed?
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a boolean to remove or not the base images.
#   Defaults to undef
#
# [*remove_unused_resized_minimum_age_seconds*]
#   (optional) Unused resized base images younger
#   than this will not be removed
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a integer or a string to define after
#   how many seconds it will be removed.
#   Defaults to undef
#
# [*remove_unused_original_minimum_age_seconds*]
#   (optional) Unused unresized base images younger
#   than this will not be removed
#   If undef is specified, remove the line in nova.conf
#   otherwise, use a integer or a string to define after
#   how many seconds it will be removed.
#   Defaults to undef
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
# [*manage_libvirt_services*]
#   (optional) Whether or not deploy Libvirt services.
#   In the case of micro-services, set it to False and use
#   nova::compute::libvirt::services + hiera to select what
#   you actually want to deploy.
#   Defaults to true for backward compatibility.
#
class nova::compute::libvirt (
  $ensure_package                             = 'present',
  $libvirt_virt_type                          = 'kvm',
  $vncserver_listen                           = '127.0.0.1',
  $migration_support                          = false,
  $libvirt_cpu_mode                           = false,
  $libvirt_cpu_model                          = undef,
  $libvirt_disk_cachemodes                    = [],
  $libvirt_hw_disk_discard                    = $::os_service_default,
  $libvirt_inject_password                    = false,
  $libvirt_inject_key                         = false,
  $libvirt_inject_partition                   = -2,
  $remove_unused_base_images                  = undef,
  $remove_unused_resized_minimum_age_seconds  = undef,
  $remove_unused_original_minimum_age_seconds = undef,
  $libvirt_service_name                       = $::nova::params::libvirt_service_name,
  $virtlock_service_name                      = $::nova::params::virtlock_service_name,
  $virtlog_service_name                       = $::nova::params::virtlog_service_name,
  $compute_driver                             = 'libvirt.LibvirtDriver',
  $manage_libvirt_services                    = true,
) inherits nova::params {

  include ::nova::deps
  include ::nova::params

  # libvirt_cpu_mode has different defaults depending on hypervisor.
  if !$libvirt_cpu_mode {
    case $libvirt_virt_type {
      'kvm': {
        $libvirt_cpu_mode_real = 'host-model'
      }
      default: {
        $libvirt_cpu_mode_real = 'none'
      }
    }
  } else {
    $libvirt_cpu_mode_real = $libvirt_cpu_mode
  }

  if($::osfamily == 'Debian') {
    package { "nova-compute-${libvirt_virt_type}":
      ensure => $ensure_package,
      tag    => ['openstack', 'nova-package'],
    }
  }

  if $migration_support {
    include ::nova::migration::libvirt
  }

  # manage_libvirt_services is here for backward compatibility to support
  # deployments that do not include nova::compute::libvirt::services
  #
  # If you're using hiera:
  #  - set nova::compute::libvirt::manage_libvirt_services to false
  #  - include ::nova::compute::libvirt::services in your composition layer
  #  - select which services you want to deploy with
  #    ::nova::compute::libvirt::services:* parameters.
  #
  # If you're not using hiera:
  #  - set nova::compute::libvirt::manage_libvirt_services to true (default).
  #  - select which services you want to deploy with
  #    ::nova::compute::libvirt::*_service_name parameters.
  if $manage_libvirt_services {
    class { '::nova::compute::libvirt::services':
      libvirt_service_name  => $libvirt_service_name,
      virtlock_service_name => $virtlock_service_name,
      virtlog_service_name  => $virtlog_service_name,
      libvirt_virt_type     => $libvirt_virt_type,
    }
  }

  nova_config {
    'DEFAULT/compute_driver':   value => $compute_driver;
    'vnc/vncserver_listen':     value => $vncserver_listen;
    'libvirt/virt_type':        value => $libvirt_virt_type;
    'libvirt/cpu_mode':         value => $libvirt_cpu_mode_real;
    'libvirt/inject_password':  value => $libvirt_inject_password;
    'libvirt/inject_key':       value => $libvirt_inject_key;
    'libvirt/inject_partition': value => $libvirt_inject_partition;
    'libvirt/hw_disk_discard':  value => $libvirt_hw_disk_discard;
  }

  # cpu_model param is only valid if cpu_mode=custom
  # otherwise it should be commented out
  if $libvirt_cpu_mode_real == 'custom' {
    validate_string($libvirt_cpu_model)
    nova_config {
      'libvirt/cpu_model': value => $libvirt_cpu_model;
    }
  } else {
    nova_config {
      'libvirt/cpu_model': ensure => absent;
    }
    if $libvirt_cpu_model {
      warning('$libvirt_cpu_model requires that $libvirt_cpu_mode => "custom" and will be ignored')
    }
  }

  if size($libvirt_disk_cachemodes) > 0 {
    nova_config {
      'libvirt/disk_cachemodes': value => join($libvirt_disk_cachemodes, ',');
    }
  } else {
    nova_config {
      'libvirt/disk_cachemodes': ensure => absent;
    }
  }

  if $remove_unused_resized_minimum_age_seconds != undef {
    nova_config {
      'libvirt/remove_unused_resized_minimum_age_seconds': value => $remove_unused_resized_minimum_age_seconds;
    }
  } else {
    nova_config {
      'libvirt/remove_unused_resized_minimum_age_seconds': ensure => absent;
    }
  }

  if $remove_unused_base_images != undef {
    nova_config {
      'DEFAULT/remove_unused_base_images': value => $remove_unused_base_images;
    }
  } else {
    nova_config {
      'DEFAULT/remove_unused_base_images': ensure => absent;
    }
  }

  if $remove_unused_original_minimum_age_seconds != undef {
    nova_config {
      'DEFAULT/remove_unused_original_minimum_age_seconds': value => $remove_unused_original_minimum_age_seconds;
    }
  } else {
    nova_config {
      'DEFAULT/remove_unused_original_minimum_age_seconds': ensure => absent;
    }
  }
}
