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
# [*live_migration_tunnelled*]
#   (optional) Whether to use tunnelled migration, where migration data is
#   transported over the libvirtd connection.
#   If True, we use the VIR_MIGRATE_TUNNELLED migration flag, avoiding the
#   need to configure the network to allow direct hypervisor to hypervisor
#   communication.
#   If False, use the native transport.
#   If not set, Nova will choose a sensible default based on, for example
#   the availability of native encryption support in the hypervisor.
#   Defaults to $::os_service_default
#
# [*override_uuid*]
#   (optional) Set uuid not equal to output from dmidecode (boolean)
#   Defaults to false
#
# [*configure_libvirt*]
#   (optional) Whether or not configure libvirt bits.
#   Defaults to true.
#
# [*configure_nova*]
#   (optional) Whether or not configure libvirt bits.
#   Defaults to true.
#
class nova::migration::libvirt(
  $use_tls                  = false,
  $auth                     = 'none',
  $live_migration_flag      = undef,
  $block_migration_flag     = undef,
  $live_migration_tunnelled = $::os_service_default,
  $override_uuid            = false,
  $configure_libvirt        = true,
  $configure_nova           = true,
){

  include ::nova::deps

  validate_re($auth, [ '^sasl$', '^none$' ], 'Valid options for auth are none and sasl.')

  if $use_tls {
    $listen_tls = '1'
    $listen_tcp = '0'
  } else {
    $listen_tls = '0'
    $listen_tcp = '1'
  }

  if $configure_nova {
    if $use_tls {
      nova_config {
        'libvirt/live_migration_uri': value => 'qemu+tls://%s/system';
      }
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

    nova_config {
      'libvirt/live_migration_tunnelled': value => $live_migration_tunnelled
    }
  }

  if $configure_libvirt {
    Anchor['nova::config::begin']
    -> File_line<| tag == 'libvirt-file_line'|>
    -> Anchor['nova::config::end']

    File_line<| tag == 'libvirt-file_line' |>
    ~> Service['libvirt']

    if $override_uuid {
      if ! $::libvirt_uuid {
        $host_uuid = generate('/bin/cat', '/proc/sys/kernel/random/uuid')
        file { '/etc/libvirt/libvirt_uuid':
          content => $host_uuid,
          require => Package['libvirt'],
        }
      } else {
        $host_uuid = $::libvirt_uuid
      }

      augeas { 'libvirt-conf-uuid':
        context => '/files/etc/libvirt/libvirtd.conf',
        changes => [
          "set host_uuid ${host_uuid}",
        ],
        notify  => Service['libvirt'],
        require => Package['libvirt'],
      }
    }

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

        if $::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemmajrelease, '16') >= 0 {
          # If systemd is being used then libvirtd is already being launched correctly and
          # adding -d causes a second consecutive start to fail which causes puppet to fail.
          $libvirtd_opts = 'libvirtd_opts="-l"'
        } else {
          $libvirtd_opts = 'libvirtd_opts="-d -l"'
        }

        file_line { "/etc/default/${::nova::compute::libvirt::libvirt_service_name} libvirtd opts":
          path  => "/etc/default/${::nova::compute::libvirt::libvirt_service_name}",
          line  => $libvirtd_opts,
          match => 'libvirtd_opts=',
          tag   => 'libvirt-file_line',
        }
      }

      default:  {
        warning("Unsupported osfamily: ${::osfamily}, make sure you are configuring this yourself")
      }
    }
  }
}
