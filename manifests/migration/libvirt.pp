#
class nova::migration::libvirt {

  case $::lsbdistid {
    'Ubuntu': {
      # Ubuntu-specific, not Debian, due to upstart

      file_line { '/etc/libvirt/libvirtd.conf listen_tls':
        path   => '/etc/libvirt/libvirtd.conf',
        line   => 'listen_tls = 0',
        match  => 'listen_tls =',
        notify => Service['libvirt'],
      }

      file_line { '/etc/libvirt/libvirtd.conf listen_tcp':
        path   => '/etc/libvirt/libvirtd.conf',
        line   => 'listen_tcp = 1',
        match  => 'listen_tcp =',
        notify => Service['libvirt'],
      }

      file_line { '/etc/libvirt/libvirtd.conf auth_tcp':
        path   => '/etc/libvirt/libvirtd.conf',
        line   => 'auth_tcp = "none"',
        match  => 'auth_tcp =',
        notify => Service['libvirt'],
      }

      file_line { '/etc/init/libvirt-bin.conf libvirtd opts':
        path  => '/etc/init/libvirt-bin.conf',
        line  => 'env libvirtd_opts="-d -l"',
        match => 'env libvirtd_opts=',
      }

      file_line { '/etc/default/libvirt-bin libvirtd opts':
        path  => '/etc/default/libvirt-bin',
        line  => 'libvirtd_opts="-d -l"',
        match => 'libvirtd_opts=',
      }
    }
    default:  {
      warning("Unsupported operating system: ${::lsbdistid}, make sure you are configuring this yourself")
    }
  }
}
