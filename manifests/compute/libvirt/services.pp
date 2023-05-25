# == Class: nova::compute::libvirt::services
#
# Install and manage libvirt services.
#
# === Parameters:
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
# [*libvirt_virt_type*]
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, parallels
#   Defaults to 'kvm'
#
# [*modular_libvirt*]
#   (optional) Whether to enable modular libvirt daemons or use monolithic
#   libvirt daemon.
#   Defaults to $::nova::params::modular_libvirt
#
# [*virtsecret_service_name*]
#   (optional) virtsecret service name.
#   Defaults to $::nova::params::virtsecret_service_name
#
# [*virtnodedev_service_name*]
#   (optional) virtnodedev service name.
#   Defaults to $::nova::params::virtnodedevd_service_name
#
# [*virtqemu_service_name*]
#   (optional) virtqemu service name.
#   Defaults to $::nova::params::virtqemu_service_name
#
# [*virtproxy_service_name*]
#   (optional) virtproxy service name.
#   Defaults to $::nova::params::virtproxy_service_name
#
# [*virtstorage_service_name*]
#   (optional) virtstorage service name.
#   Defaults to $::nova::params::virtstorage_service_name
#
class nova::compute::libvirt::services (
  $libvirt_service_name     = $::nova::params::libvirt_service_name,
  $virtlock_service_name    = $::nova::params::virtlock_service_name,
  $virtlog_service_name     = $::nova::params::virtlog_service_name,
  $libvirt_virt_type        = 'kvm',
  $modular_libvirt          = $::nova::params::modular_libvirt,
  $virtsecret_service_name  = $::nova::params::virtsecret_service_name,
  $virtnodedev_service_name = $::nova::params::virtnodedev_service_name,
  $virtqemu_service_name    = $::nova::params::virtqemu_service_name,
  $virtproxy_service_name   = $::nova::params::virtproxy_service_name,
  $virtstorage_service_name = $::nova::params::virtstorage_service_name
) inherits nova::params {

  include nova::deps
  include nova::params

  if $libvirt_service_name {
    # libvirt-nwfilter
    if $::osfamily == 'RedHat' {
      package { 'libvirt-nwfilter':
        ensure => present,
        name   => $::nova::params::libvirt_nwfilter_package_name,
        before => Service['libvirt'],
        tag    => ['openstack', 'nova-support-package'],
      }
      case $libvirt_virt_type {
        'qemu': {
          $libvirt_package_name_real = "${::nova::params::libvirt_daemon_package_prefix}kvm"
        }
        'parallels': {
          $libvirt_package_name_real = $::nova::params::libvirt_package_name
        }
        default: {
          $libvirt_package_name_real = "${::nova::params::libvirt_daemon_package_prefix}${libvirt_virt_type}"
        }
      }
    } else {
      $libvirt_package_name_real = $::nova::params::libvirt_package_name
    }

    # libvirt
    package { 'libvirt':
      ensure => present,
      name   => $libvirt_package_name_real,
      tag    => ['openstack', 'nova-support-package'],
    }

    # Stop and disable libvirt service when modular_libvirt is enabled
    if $modular_libvirt {
      $libvirt_service_ensure = 'stopped'
      $libvirt_service_enable = false
    } else {
      $libvirt_service_ensure = 'running'
      $libvirt_service_enable = true
    }

    service { 'libvirt':
      ensure => $libvirt_service_ensure,
      enable => $libvirt_service_enable,
      name   => $libvirt_service_name,
      tag    => ['libvirt-service', 'libvirt-qemu-service'],
    }
    Libvirtd_config<||> ~> Service['libvirt']

    # messagebus
    if($::osfamily == 'RedHat') {
      service { 'messagebus':
        ensure => running,
        enable => true,
        name   => $::nova::params::messagebus_service_name,
        tag    => 'libvirt-service',
      }
    }
  }

  if $virtlock_service_name {
    service { 'virtlockd':
      ensure => running,
      enable => true,
      name   => $virtlock_service_name,
      tag    => 'libvirt-service',
    }
    Virtlockd_config<||> ~> Service['virtlockd']
  }

  if $virtlog_service_name {
    service { 'virtlogd':
      ensure => running,
      enable => true,
      name   => $virtlog_service_name,
      tag    => 'libvirt-service',
    }
    Virtlogd_config<||> ~> Service['virtlogd']
  }

  if ! $modular_libvirt {
    Service<| title == 'messagebus' |> -> Service<| title == 'libvirt' |>

    Service<| title == 'virtlogd' |>
    -> Service<| title == 'libvirt' |>
    -> Service<| title == 'nova-compute'|>

    if $facts['os']['family'] == 'RedHat' {
      package { 'libvirt-daemon':
        ensure => present,
        name   => $::nova::params::libvirt_daemon_package_name,
        tag    => ['openstack', 'nova-support-package'],
      }
    }
  } else {
    # NOTE(tkajinam): libvirt should be stopped before starting modular daemons
    Service<| title == 'libvirt' |> -> Service<| tag == 'libvirt-modular-service' |>

    Service<| title == 'messagebus' |> -> Service<| tag == 'libvirt-modular-service' |>

    Service<| title == 'virtlogd' |>
    -> Service<| tag == 'libvirt-modular-service' |>
    -> Service<| title == 'nova-compute'|>

    if $virtsecret_service_name {
      package { 'virtsecret':
        ensure => present,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-secret",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtsecretd':
        ensure => running,
        enable => true,
        name   => $virtsecret_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtsecretd_config<||> ~> Service['virtsecretd']
    }

    if $virtnodedev_service_name {
      package { 'virtnodedev':
        ensure => present,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-nodedev",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtnodedevd':
        ensure => running,
        enable => true,
        name   => $virtnodedev_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtnodedevd_config<||> ~> Service['virtnodedevd']
    }

    if $virtqemu_service_name {
      package { 'virtqemu':
        ensure => present,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-qemu",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtqemud':
        ensure => running,
        enable => true,
        name   => $virtqemu_service_name,
        tag    => ['libvirt-service', 'libvirt-qemu-service', 'libvirt-modular-service'],
      }
      Virtqemud_config<||> ~> Service['virtqemud']
    }

    if $virtproxy_service_name {
      service { 'virtproxyd':
        ensure => running,
        enable => true,
        name   => $virtproxy_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtproxyd_config<||> ~> Service['virtproxyd']
    }

    if $virtstorage_service_name {
      package { 'virtstorage':
        ensure => present,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-storage",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtstoraged':
        ensure => running,
        enable => true,
        name   => $virtstorage_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtstoraged_config<||> ~> Service['virtstoraged']
    }
  }
}
