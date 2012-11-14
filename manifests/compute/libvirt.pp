class nova::compute::libvirt (
  $libvirt_type      = 'kvm',
  $vncserver_listen  = '127.0.0.1',
  $migration_support = false
) {

  include nova::params

  Service['libvirt'] -> Service['nova-compute']

  if($::osfamily == 'Debian') {
    package { "nova-compute-${libvirt_type}":
      ensure => present,
      before => Package['nova-compute'],
    }
  }

  if $migration_support {
    if $vncserver_listen != '0.0.0.0' {
      fail("For migration support to work, you MUST set vncserver_listen to '0.0.0.0'")
    } else {
      class { 'nova::migration::libvirt': }
    }
  }

  package { 'libvirt':
    name   => $::nova::params::libvirt_package_name,
    ensure => present,
  }

  service { 'libvirt' :
    name     => $::nova::params::libvirt_service_name,
    ensure   => running,
    provider => $::nova::params::special_service_provider,
    require  => Package['libvirt'],
  }

  nova_config {
    'compute_driver':   value => 'libvirt.LibvirtDriver';
    'libvirt_type':     value => $libvirt_type;
    'connection_type':  value => 'libvirt';
    'vncserver_listen': value => $vncserver_listen;
  }
}
