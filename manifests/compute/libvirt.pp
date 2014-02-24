# == Class: nova::compute::libvirt
#
# Install and manage nova-compute guests managed
# by libvirt
#
# === Parameters:
#
# [*libvirt_virt_type*]
#   (optional) Libvirt domain type. Options are: kvm, lxc, qemu, uml, xen
#   Replaces libvirt_type
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
class nova::compute::libvirt (
  $libvirt_virt_type = 'kvm',
  $vncserver_listen  = '127.0.0.1',
  $migration_support = false,
  # DEPRECATED PARAMETER
  $libvirt_type      = false
) {

  include nova::params

  Service['libvirt'] -> Service['nova-compute']

  if $libvirt_type {
    warning ('The libvirt_type parameter is deprecated, use libvirt_virt_type instead.')
    $libvirt_virt_type_real = $libvirt_type
  } else {
    $libvirt_virt_type_real = $libvirt_virt_type
  }

  if($::osfamily == 'Debian') {
    package { "nova-compute-${libvirt_virt_type_real}":
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
    'DEFAULT/vncserver_listen': value => $vncserver_listen;
    'libvirt/virt_type':        value => $libvirt_virt_type_real;
  }
}
