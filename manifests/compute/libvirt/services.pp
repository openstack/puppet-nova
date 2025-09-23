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
#   Defaults to $nova::params::libvirt_service_name
#
# [*virtlock_service_name*]
#   (optional) virtlock service name.
#   Defaults to $nova::params::virtlock_service_name
#
# [*virtlog_service_name*]
#   (optional) virtlog service name.
#   Defaults to $nova::params::virtlog_service_name
#
# [*libvirt_virt_type*]
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, parallels
#   Defaults to 'kvm'
#
# [*modular_libvirt*]
#   (optional) Whether to enable modular libvirt daemons or use monolithic
#   libvirt daemon.
#   Defaults to $nova::params::modular_libvirt
#
# [*virtsecret_service_name*]
#   (optional) virtsecret service name.
#   Defaults to $nova::params::virtsecret_socket_name
#
# [*virtnodedev_service_name*]
#   (optional) virtnodedev service name.
#   Defaults to $nova::params::virtnodedevd_socket_name
#
# [*virtqemu_service_name*]
#   (optional) virtqemu service name.
#   Defaults to $nova::params::virtqemu_socket_name
#
# [*virtproxy_service_name*]
#   (optional) virtproxy service name.
#   Defaults to $nova::params::virtproxy_socket_name
#
# [*virtstorage_service_name*]
#   (optional) virtstorage service name.
#   Defaults to $nova::params::virtstorage_socket_name
#
# [*manage_ovmf*]
#   (optional) install the OVMF package.
#   Defaults to true
#
# [*manage_swtpm*]
#   (optional) install the swtpm package.
#   Defaults to false
#
class nova::compute::libvirt::services (
  Stdlib::Ensure::Package $ensure_package = 'present',
  $libvirt_service_name                   = $nova::params::libvirt_service_name,
  $virtlock_service_name                  = $nova::params::virtlock_service_name,
  $virtlog_service_name                   = $nova::params::virtlog_service_name,
  $libvirt_virt_type                      = 'kvm',
  $modular_libvirt                        = $nova::params::modular_libvirt,
  $virtsecret_service_name                = $nova::params::virtsecret_socket_name,
  $virtnodedev_service_name               = $nova::params::virtnodedev_socket_name,
  $virtqemu_service_name                  = $nova::params::virtqemu_socket_name,
  $virtproxy_service_name                 = $nova::params::virtproxy_socket_name,
  $virtstorage_service_name               = $nova::params::virtstorage_socket_name,
  Boolean $manage_ovmf                    = true,
  Boolean $manage_swtpm                   = false,
) inherits nova::params {
  include nova::deps
  include nova::params

  if $modular_libvirt and !$nova::params::modular_libvirt_support {
    fail('Modular libvirt daemons are not supported in this distribution')
  }

  if $manage_ovmf {
    package { 'ovmf':
      ensure => $ensure_package,
      name   => $nova::params::ovmf_package_name,
      tag    => ['openstack', 'nova-support-package'],
    }
    Package['ovmf'] ~> Service<| tag == 'libvirt-qemu-service' |>
    Package['ovmf'] ~> Service<| title == 'nova-compute'|>
  }

  if $manage_swtpm {
    package { 'swtpm':
      ensure => $ensure_package,
      name   => $nova::params::swtpm_package_name,
      tag    => ['openstack', 'nova-support-package'],
    }
  }

  if $libvirt_service_name {
    if $facts['os']['family'] == 'RedHat' {
      case $libvirt_virt_type {
        'qemu': {
          $libvirt_package_name_real = "${nova::params::libvirt_daemon_package_prefix}kvm"
        }
        'parallels': {
          $libvirt_package_name_real = $nova::params::libvirt_package_name
        }
        default: {
          $libvirt_package_name_real = "${nova::params::libvirt_daemon_package_prefix}${libvirt_virt_type}"
        }
      }
    } else {
      $libvirt_package_name_real = $nova::params::libvirt_package_name
    }

    # libvirt
    package { 'libvirt':
      ensure => $ensure_package,
      name   => $libvirt_package_name_real,
      tag    => ['openstack', 'nova-support-package'],
    }
    Package['libvirt'] ~> Service<| tag == 'libvirt-service' |>
    Package['libvirt'] ~> Exec<| tag == 'libvirt-service-stop' |>

    # Stop and disable libvirt service when modular_libvirt is enabled
    if $modular_libvirt {
      $libvirt_service_ensure = 'stopped'
      $libvirt_service_enable = false
    } else {
      $libvirt_service_ensure = 'running'
      $libvirt_service_enable = true

      if $facts['os']['family'] == 'RedHat' {
        package { 'libvirt-daemon':
          ensure => $ensure_package,
          name   => $nova::params::libvirt_daemon_package_name,
          tag    => ['openstack', 'nova-support-package'],
        }
        Package['libvirt-daemon'] ~> Service<| title == 'libvirt' |>
      }
    }

    service { 'libvirt':
      ensure => $libvirt_service_ensure,
      enable => $libvirt_service_enable,
      name   => $libvirt_service_name,
      tag    => ['libvirt-service', 'libvirt-qemu-service'],
    }
    Libvirtd_config<||> ~> Service['libvirt']
  }

  if $virtlock_service_name {
    if $nova::params::virtlock_package_name {
      package { 'virtlockd':
        ensure => present,
        name   => $nova::params::virtlock_package_name,
        tag    => ['openstack', 'nova-support-package'],
      }
      Package['virtlockd'] ~> Service['virtlockd']
    }
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
    Service<| title == 'virtlogd' |>
    -> Service<| title == 'libvirt' |>
    -> Service<| title == 'nova-compute'|>
  } else {
    # NOTE(tkajinam): libvirt should be stopped before starting modular daemons
    Service<| title == 'libvirt' |> -> Service<| tag == 'libvirt-modular-service' |>

    Service<| title == 'virtlogd' |>
    -> Service<| tag == 'libvirt-modular-service' |>
    -> Service<| title == 'nova-compute'|>

    if $virtsecret_service_name {
      package { 'virtsecret':
        ensure => $ensure_package,
        name   => "${nova::params::libvirt_daemon_package_prefix}driver-secret",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtsecretd':
        ensure    => running,
        enable    => true,
        name      => $virtsecret_service_name,
        subscribe => Package['virtsecret'],
        tag       => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtsecretd_config<||> ~> Service['virtsecretd']

      if $virtsecret_service_name =~ /.+\.socket$/ {
        $virtsecret_service_name_real = regsubst($virtsecret_service_name, /\.socket$/, '.service')
        exec { 'stop-virtsecretd':
          command     => "systemctl -q stop ${virtsecret_service_name_real}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${virtsecret_service_name_real}",
          refreshonly => true,
          require     => Anchor['nova::service::begin'],
          subscribe   => Package['virtsecret'],
          tag         => 'libvirt-service-stop',
        }
        Virtsecretd_config<||> ~> Exec['stop-virtsecretd'] -> Service['virtsecretd']
      }
    }

    if $virtnodedev_service_name {
      package { 'virtnodedev':
        ensure => $ensure_package,
        name   => "${nova::params::libvirt_daemon_package_prefix}driver-nodedev",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtnodedevd':
        ensure    => running,
        enable    => true,
        name      => $virtnodedev_service_name,
        subscribe => Package['virtnodedev'],
        tag       => ['libvirt-service', 'libvirt-modular-service'],
      }
      Package['virtnodedev'] ~> Service['virtnodedevd']
      Virtnodedevd_config<||> ~> Service['virtnodedevd']

      if $virtnodedev_service_name =~ /.+\.socket$/ {
        $virtnodedev_service_name_real = regsubst($virtnodedev_service_name, /\.socket$/, '.service')
        exec { 'stop-virtnodedevd':
          command     => "systemctl -q stop ${virtnodedev_service_name_real}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${virtnodedev_service_name_real}",
          refreshonly => true,
          require     => Anchor['nova::service::begin'],
          subscribe   => Package['virtnodedev'],
          tag         => 'libvirt-service-stop',
        }
        Virtnodedevd_config<||> ~> Exec['stop-virtnodedevd'] -> Service['virtnodedevd']
      }
    }

    if $virtqemu_service_name {
      package { 'virtqemu':
        ensure => $ensure_package,
        name   => "${nova::params::libvirt_daemon_package_prefix}driver-qemu",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtqemud':
        ensure    => running,
        enable    => true,
        name      => $virtqemu_service_name,
        subscribe => Package['virtqemu'],
        tag       => ['libvirt-service', 'libvirt-qemu-service', 'libvirt-modular-service'],
      }
      Virtqemud_config<||> ~> Service['virtqemud']

      if $virtqemu_service_name =~ /.+\.socket$/ {
        $virtqemu_service_name_real = regsubst($virtqemu_service_name, /\.socket$/, '.service')
        exec { 'stop-virtqemud':
          command     => "systemctl -q stop ${virtqemu_service_name_real}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${virtqemu_service_name_real}",
          refreshonly => true,
          require     => Anchor['nova::service::begin'],
          subscribe   => Package['virtqemu'],
          tag         => 'libvirt-service-stop',
        }
        Virtqemud_config<||> ~> Exec['stop-virtqemud'] -> Service['virtqemud']
      }
    }

    if $virtproxy_service_name {
      service { 'virtproxyd':
        ensure => running,
        enable => true,
        name   => $virtproxy_service_name,
        tag    => ['libvirt-service', 'libvirt-modular-service'],
      }
      Virtproxyd_config<||> ~> Service['virtproxyd']

      if $virtproxy_service_name =~ /.+\.socket$/ {
        $virtproxy_service_name_real = regsubst($virtproxy_service_name, /\.socket$/, '.service')
        exec { 'stop-virtproxyd':
          command     => "systemctl -q stop ${virtproxy_service_name_real}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${virtproxy_service_name_real}",
          refreshonly => true,
          require     => Anchor['nova::service::begin'],
          tag         => 'libvirt-service-stop',
        }
        Virtproxyd_config<||> ~> Exec['stop-virtproxyd'] -> Service['virtproxyd']
      }
    }

    if $virtstorage_service_name {
      package { 'virtstorage':
        ensure => $ensure_package,
        name   => "${nova::params::libvirt_daemon_package_prefix}driver-storage",
        tag    => ['openstack', 'nova-support-package'],
      }
      service { 'virtstoraged':
        ensure    => running,
        enable    => true,
        name      => $virtstorage_service_name,
        subscribe => Package['virtstorage'],
        tag       => ['libvirt-service', 'libvirt-modular-service'],
      }
      Package['virtstorage'] ~> Service['virtstoraged']
      Virtstoraged_config<||> ~> Service['virtstoraged']
      if $virtstorage_service_name =~ /.+\.socket$/ {
        $virtstorage_service_name_real = regsubst($virtstorage_service_name, /\.socket$/, '.service')
        exec { 'stop-virtstoraged':
          command     => "systemctl -q stop ${virtstorage_service_name_real}",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          onlyif      => "systemctl -q is-active ${virtstorage_service_name_real}",
          refreshonly => true,
          require     => Anchor['nova::service::begin'],
          subscribe   => Package['virtstorage'],
          tag         => 'libvirt-service-stop',
        }
        Virtstoraged_config<||> ~> Exec['stop-virtstoraged'] -> Service['virtstoraged']
      }
    }
  }
}
