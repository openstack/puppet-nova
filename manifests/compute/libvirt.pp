# == Class: nova::compute::libvirt
#
# Install and manage nova-compute guests managed
# by libvirt
#
# === Parameters:
#
# [*libvirt_type*]
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
#   include custom, host-model, None, host-passthrough.
#   Defaults to 'host-model' if libvirt_type is set to either
#   kvm or qemu, otherwise defaults to 'None'.
#
# [*libvirt_disk_cachemodes*]
#   (optional) A list of cachemodes for different disk types, e.g.
#   ["file=directsync", "block=none"]
#   If an empty list is specified, the disk_cachemodes directive
#   will be removed from nova.conf completely.
#   Defaults to an empty list
#

class nova::compute::libvirt (
  $libvirt_type            = 'kvm',
  $vncserver_listen        = '127.0.0.1',
  $migration_support       = false,
  $libvirt_cpu_mode        = false,
  $libvirt_disk_cachemodes = [],
) {

  include nova::params

  Service['libvirt'] -> Service['nova-compute']

  # libvirt_cpu_mode has different defaults depending on hypervisor.
  if !$libvirt_cpu_mode {
    case $libvirt_type {
      'kvm','qemu': {
        $libvirt_cpu_mode_real = 'host-model'
      }
      default: {
        $libvirt_cpu_mode_real = 'None'
      }
    }
  } else {
    $libvirt_cpu_mode_real = $libvirt_cpu_mode
  }

  if($::osfamily == 'Debian') {
    package { "nova-compute-${libvirt_type}":
      ensure => present,
      before => Package['nova-compute'],
    }
  }

  if($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora') {
    service { 'messagebus':
      ensure   => running,
      enable   => true,
      provider => $::nova::params::special_service_provider,
    }
    Package['libvirt'] -> Service['messagebus'] -> Service['libvirt']

  }

  if $migration_support {
    if $vncserver_listen != '0.0.0.0' {
      fail('For migration support to work, you MUST set vncserver_listen to \'0.0.0.0\'')
    } else {
      class { 'nova::migration::libvirt': }
    }
  }

  package { 'libvirt':
    ensure => present,
    name   => $::nova::params::libvirt_package_name,
  }

  service { 'libvirt' :
    ensure   => running,
    enable   => true,
    name     => $::nova::params::libvirt_service_name,
    provider => $::nova::params::special_service_provider,
    require  => Package['libvirt'],
  }

  nova_config {
    'DEFAULT/compute_driver':   value => 'libvirt.LibvirtDriver';
    'DEFAULT/libvirt_type':     value => $libvirt_type;
    'DEFAULT/connection_type':  value => 'libvirt';
    'DEFAULT/vncserver_listen': value => $vncserver_listen;
    'DEFAULT/libvirt_cpu_mode': value => $libvirt_cpu_mode_real;
  }

  if size($libvirt_disk_cachemodes) > 0 {
    nova_config {
      'DEFAULT/disk_cachemodes': value => join($libvirt_disk_cachemodes, ',');
    }
  } else {
    nova_config {
      'DEFAULT/disk_cachemodes': ensure => absent;
    }
  }
}
