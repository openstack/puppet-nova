# == Class: nova::compute::libvirt::services
#
# Install and manage libvirt services.
#
# === Parameters:
#
# [*ensure_package*]
#   (optional) The state of the libvirt packages.
#   Defaults to 'present'
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
#   Defaults to $::nova::params::virtsecret_socket_name
#
# [*virtnodedev_service_name*]
#   (optional) virtnodedev service name.
#   Defaults to $::nova::params::virtnodedevd_socket_name
#
# [*virtqemu_service_name*]
#   (optional) virtqemu service name.
#   Defaults to $::nova::params::virtqemu_socket_name
#
# [*virtproxy_service_name*]
#   (optional) virtproxy service name.
#   Defaults to $::nova::params::virtproxy_socket_name
#
# [*virtstorage_service_name*]
#   (optional) virtstorage service name.
#   Defaults to $::nova::params::virtstorage_socket_name
#
class nova::compute::libvirt::services (
  $ensure_package           = 'present',
  $libvirt_service_name     = $::nova::params::libvirt_service_name,
  $virtlock_service_name    = $::nova::params::virtlock_service_name,
  $virtlog_service_name     = $::nova::params::virtlog_service_name,
  $libvirt_virt_type        = 'kvm',
  $modular_libvirt          = $::nova::params::modular_libvirt,
  $virtsecret_service_name  = $::nova::params::virtsecret_socket_name,
  $virtnodedev_service_name = $::nova::params::virtnodedev_socket_name,
  $virtqemu_service_name    = $::nova::params::virtqemu_socket_name,
  $virtproxy_service_name   = $::nova::params::virtproxy_socket_name,
  $virtstorage_service_name = $::nova::params::virtstorage_socket_name
) inherits nova::params {

  include nova::deps
  include nova::params

  if $modular_libvirt and !$::nova::params::modular_libvirt_support {
    fail('Modular libvirt daemons are not supported in this distribution')
  }

  if $libvirt_service_name {
    # libvirt-nwfilter
    if $facts['os']['family'] == 'RedHat' {
      package { 'libvirt-nwfilter':
        ensure => $ensure_package,
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
      ensure => $ensure_package,
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
    if( $facts['os']['family'] == 'RedHat') {
      # NOTE(tkajinam): Do not use libvirt-service tag to avoid unnecessary
      # restart.
      service { 'messagebus':
        ensure  => running,
        enable  => true,
        name    => $::nova::params::messagebus_service_name,
        require => Anchor['nova::service::begin'],
        before  => Anchor['nova::service::end'],
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
        ensure => $ensure_package,
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
        ensure => $ensure_package,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-secret",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtsecretd':
        ensure => running,
        enable => true,
        name   => $virtsecret_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtsecretd_config<||> -> Service['virtsecretd']

      if $virtsecret_service_name =~ /.+\.socket$/ {
        exec { 'restart-virtsecretd':
          command     => "systemctl -q restart ${::nova::params::virtsecret_service_name}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${::nova::params::virtsecret_service_name}",
          refreshonly => true,
        }
        Virtsecretd_config<||> ~> Exec['restart-virtsecretd']
      }
    }

    if $virtnodedev_service_name {
      package { 'virtnodedev':
        ensure => $ensure_package,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-nodedev",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtnodedevd':
        ensure => running,
        enable => true,
        name   => $virtnodedev_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtnodedevd_config<||> -> Service['virtnodedevd']

      if $virtnodedev_service_name =~ /.+\.socket$/ {
        exec { 'restart-virtnodedevd':
          command     => "systemctl -q restart ${::nova::params::virtnodedev_service_name}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${::nova::params::virtnodedev_service_name}",
          refreshonly => true,
        }
        Virtnodedevd_config<||> ~> Exec['restart-virtnodedevd']
      }
    }

    if $virtqemu_service_name {
      package { 'virtqemu':
        ensure => $ensure_package,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-qemu",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtqemud':
        ensure => running,
        enable => true,
        name   => $virtqemu_service_name,
        tag    => ['libvirt-service', 'libvirt-qemu-service', 'libvirt-modular-service'],
      }
      Virtqemud_config<||> -> Service['virtqemud']
      if $virtqemu_service_name =~ /.+\.socket$/ {
        exec { 'restart-virtqemud':
          command     => "systemctl -q restart ${::nova::params::virtqemu_service_name}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${::nova::params::virtqemu_service_name}",
          refreshonly => true,
        }
        Virtqemud_config<||> ~> Exec['restart-virtqemud']
      }
    }

    if $virtproxy_service_name {
      service { 'virtproxyd':
        ensure => running,
        enable => true,
        name   => $virtproxy_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtproxyd_config<||> -> Service['virtproxyd']
      if $virtproxy_service_name =~ /.+\.socket$/ {
        exec { 'restart-virtproxyd':
          command     => "systemctl -q restart ${::nova::params::virtproxy_service_name}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${::nova::params::virtproxy_service_name}",
          refreshonly => true,
        }
        Virtproxyd_config<||> ~> Exec['restart-virtproxyd']
      }
    }

    if $virtstorage_service_name {
      package { 'virtstorage':
        ensure => $ensure_package,
        name   => "${::nova::params::libvirt_daemon_package_prefix}driver-storage",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtstoraged':
        ensure => running,
        enable => true,
        name   => $virtstorage_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtstoraged_config<||> -> Service['virtstoraged']
      if $virtstorage_service_name =~ /.+\.socket$/ {
        exec { 'restart-virtstoraged':
          command     => "systemctl -q restart ${::nova::params::virtstorage_service_name}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${::nova::params::virtstorage_service_name}",
          refreshonly => true,
        }
        Virtstoraged_config<||> ~> Exec['restart-storaged']
      }
    }
  }
}
