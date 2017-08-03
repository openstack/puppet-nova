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
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, uml, xen
#   Defaults to 'kvm'
#
class nova::compute::libvirt::services (
  $libvirt_service_name  = $::nova::params::libvirt_service_name,
  $virtlock_service_name = $::nova::params::virtlock_service_name,
  $virtlog_service_name  = $::nova::params::virtlog_service_name,
  $libvirt_virt_type     = 'kvm',
) inherits nova::params {

  include ::nova::deps
  include ::nova::params

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
    service { 'libvirt' :
      ensure   => running,
      enable   => true,
      name     => $libvirt_service_name,
      provider => $::nova::params::special_service_provider,
      require  => Anchor['nova::install::end'],
    }

    # messagebus
    if($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora') {
      service { 'messagebus':
        ensure   => running,
        enable   => true,
        name     => $::nova::params::messagebus_service_name,
        provider => $::nova::params::special_service_provider,
      }
      Package['libvirt'] -> Service['messagebus'] -> Service['libvirt']
    }

    # when nova-compute & libvirt run together
    Service['libvirt'] -> Service<| title == 'nova-compute'|>
  }


  if $virtlock_service_name {
    service { 'virtlockd':
      ensure   => running,
      enable   => true,
      name     => $virtlock_service_name,
      provider => $::nova::params::special_service_provider,
    }
    Package<| name == 'libvirt' |> -> Service['virtlockd']
  }

  if $virtlog_service_name {
    service { 'virtlogd':
      ensure   => running,
      enable   => true,
      name     => $virtlog_service_name,
      provider => $::nova::params::special_service_provider,
    }
    Package<| name == 'libvirt' |> -> Service['virtlogd']
  }

}
