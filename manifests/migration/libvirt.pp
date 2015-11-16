# == Class: nova::migration::libvirt
#
# Sets libvirt config that is required for migration
#
# === Parameters:
#
# [*use_tls*]
#   (optional) Use tls for remote connections to libvirt
#   Defaults to false
#
# [*auth*]
#   (optional) Use this authentication scheme for remote libvirt connections.
#   Valid options are none and sasl.
#   Defaults to 'none'
#
# [*live_migration_flag*]
#   (optional) Migration flags to be set for live migration (string value)
#   Defaults to undef
#
# [*block_migration_flag*]
#   (optional) Migration flags to be set for block migration (string value)
#   Defaults to undef
#
class nova::migration::libvirt(
  $use_tls              = false,
  $auth                 = 'none',
  $live_migration_flag  = undef,
  $block_migration_flag = undef,
){

  include ::nova::deps

  if $use_tls {
    $listen_tls = '1'
    $listen_tcp = '0'
    nova_config {
      'libvirt/live_migration_uri': value => 'qemu+tls://%s/system';
    }
  } else {
    $listen_tls = '0'
    $listen_tcp = '1'
  }

  if $live_migration_flag {
    nova_config {
    'libvirt/live_migration_flag': value => $live_migration_flag
    }
  }

  if $block_migration_flag {
    nova_config {
    'libvirt/block_migration_flag': value => $block_migration_flag
    }
  }

  validate_re($auth, [ '^sasl$', '^none$' ], 'Valid options for auth are none and sasl.')

  Anchor['nova::config::begin']
  -> File_line<| tag == 'libvirt-file_line'|>
  -> Anchor['nova::config::end']

  File_line<| tag == 'libvirt-file_line' |>
  ~> Service['libvirt']

  case $::osfamily {
    'RedHat': {
      file_line { '/etc/libvirt/libvirtd.conf listen_tls':
        path  => '/etc/libvirt/libvirtd.conf',
        line  => "listen_tls = ${listen_tls}",
        match => 'listen_tls =',
        tag   => 'libvirt-file_line',
      }

      file_line { '/etc/libvirt/libvirtd.conf listen_tcp':
        path  => '/etc/libvirt/libvirtd.conf',
        line  => "listen_tcp = ${listen_tcp}",
        match => 'listen_tcp =',
        tag   => 'libvirt-file_line',
      }

      if $use_tls {
        file_line { '/etc/libvirt/libvirtd.conf auth_tls':
          path  => '/etc/libvirt/libvirtd.conf',
          line  => "auth_tls = \"${auth}\"",
          match => 'auth_tls =',
          tag   => 'libvirt-file_line',
        }
      } else {
        file_line { '/etc/libvirt/libvirtd.conf auth_tcp':
          path  => '/etc/libvirt/libvirtd.conf',
          line  => "auth_tcp = \"${auth}\"",
          match => 'auth_tcp =',
          tag   => 'libvirt-file_line',
        }
      }

      file_line { '/etc/sysconfig/libvirtd libvirtd args':
        path  => '/etc/sysconfig/libvirtd',
        line  => 'LIBVIRTD_ARGS="--listen"',
        match => 'LIBVIRTD_ARGS=',
        tag   => 'libvirt-file_line',
      }
    }

    'Debian': {
      file_line { '/etc/libvirt/libvirtd.conf listen_tls':
        path  => '/etc/libvirt/libvirtd.conf',
        line  => "listen_tls = ${listen_tls}",
        match => 'listen_tls =',
        tag   => 'libvirt-file_line',
      }

      file_line { '/etc/libvirt/libvirtd.conf listen_tcp':
        path  => '/etc/libvirt/libvirtd.conf',
        line  => "listen_tcp = ${listen_tcp}",
        match => 'listen_tcp =',
        tag   => 'libvirt-file_line',
      }

      if $use_tls {
        file_line { '/etc/libvirt/libvirtd.conf auth_tls':
          path  => '/etc/libvirt/libvirtd.conf',
          line  => "auth_tls = \"${auth}\"",
          match => 'auth_tls =',
          tag   => 'libvirt-file_line',
        }
      } else {
        file_line { '/etc/libvirt/libvirtd.conf auth_tcp':
          path  => '/etc/libvirt/libvirtd.conf',
          line  => "auth_tcp = \"${auth}\"",
          match => 'auth_tcp =',
          tag   => 'libvirt-file_line',
        }
      }

      file_line { "/etc/default/${::nova::compute::libvirt::libvirt_service_name} libvirtd opts":
        path  => "/etc/default/${::nova::compute::libvirt::libvirt_service_name}",
        line  => 'libvirtd_opts="-d -l"',
        match => 'libvirtd_opts=',
        tag   => 'libvirt-file_line',
      }
    }

    default:  {
      warning("Unsupported osfamily: ${::osfamily}, make sure you are configuring this yourself")
    }
  }
}
