#
class nova::compute::libvirt (
  $libvirt_type      = 'kvm',
  $vncserver_listen  = '127.0.0.1',
  $migration_support = false,
  $libvirt_images_type = 'default',
  $libvirt_images_rbd_pool = 'rbd',
  $libvirt_images_rbd_ceph_conf = '/etc/ceph/ceph.conf',
  $rbd_user             = unset,
  $rbd_secret_uuid      = unset,
  $rbd_secret_val       = unset,
) {

  include nova::params

  Service['libvirt'] -> Service['nova-compute']

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
    name     => $::nova::params::libvirt_service_name,
    provider => $::nova::params::special_service_provider,
    require  => Package['libvirt'],
  }


  if ($libvirt_images_type == 'rbd'){
    if $rbd_user {
      file { '/etc/libvirt/secret.xml':
        ensure   => file,
        owner    => 'root',
        group    => 'root',
        mode     => '600',
        content  => template("${module_name}/secret.xml.erb"),
        require  => Package['libvirt'],
        notify   => Exec['secret_refresh'],
      }

      exec { 'secret_define':
        path        => '/usr/bin:/usr/sbin:/bin',
        command     => 'virsh secret-define /etc/libvirt/secret.xml',
        unless      => "virsh secret-dumpxml ${rbd_secret_uuid}",
        require     => File['/etc/libvirt/secret.xml'],
      }

      exec { 'secret_set':
        path        => '/usr/bin:/usr/sbin:/bin',
        command     => "virsh secret-set-value ${rbd_secret_uuid} ${rbd_secret_val}",
        unless      => "virsh secret-get-value ${rbd_secret_uuid}",
        require     => Exec['secret_define'],
      }

      exec { 'secret_refresh':
        path        => '/usr/bin:/usr/sbin:/bin',
        command     => "virsh secret-set-value ${rbd_secret_uuid} ${rbd_secret_val}",
        refreshonly => true,
        require     => Exec['secret_define'],
      }
    }

    nova_config {
      'DEFAULT/libvirt_inject_partition':         value => '-2';
      'DEFAULT/libvirt_images_rbd_pool':          value => $libvirt_images_rbd_pool;
      'DEFAULT/libvirt_images_rbd_ceph_conf':     value => $libvirt_images_rbd_ceph_conf;
      'DEFAULT/rbd_user':                         value => $rbd_user;
      'DEFAULT/rbd_secret_uuid':                  value => $rbd_secret_uuid;
    }
  }

  nova_config {
    'DEFAULT/compute_driver':           value => 'libvirt.LibvirtDriver';
    'DEFAULT/libvirt_type':             value => $libvirt_type;
    'DEFAULT/connection_type':          value => 'libvirt';
    'DEFAULT/vncserver_listen':         value => $vncserver_listen;
    'DEFAULT/libvirt_images_type':      value => $libvirt_images_type;
  }
}
