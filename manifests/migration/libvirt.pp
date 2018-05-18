# == Class: nova::migration::libvirt
#
# Sets libvirt config that is required for migration
#
# === Parameters:
#
# [*transport*]
#   (optional) Transport to use for live-migration.
#   Valid options are 'tcp', 'tls', and 'ssh'.
#   Defaults to 'tcp'
#
# [*auth*]
#   (optional) Use this authentication scheme for remote libvirt connections.
#   Valid options are none and sasl.
#   Defaults to 'none'
#
# [*listen_address*]
#   (optional) Bind libvirtd tcp/tls socket to the given address.
#   Defaults to undef (bind to all addresses)
#
# [*live_migration_inbound_addr*]
#   (optional) The IP address or hostname to be used as the target for live
#   migration traffic.
#   Defaults to $::os_service_default
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
# [*live_migration_completion_timeout*]
#   (optional) Time to wait, in seconds, for migration to successfully complete
#   transferring data before aborting the operation. Value is per GiB of guest
#   RAM + disk to be transferred, with lower bound of a minimum of 2 GiB. Set
#   to 0 to disable timeouts.
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
# [*client_user*]
#   (optional) Remote user to connect as.
#   Only applies to ssh transport.
#   Defaults to undef (root)
#
# [*client_port*]
#   (optional) Remote port to connect to.
#   Defaults to undef (default port for the transport)
#
# [*client_extraparams*]
#   (optional) Hash of additional params to append to the live-migration uri
#   See https://libvirt.org/guide/html/Application_Development_Guide-Architecture-Remote_URIs.html
#   Defaults to {}
#
class nova::migration::libvirt(
  $transport                         = undef,
  $auth                              = 'none',
  $listen_address                    = undef,
  $live_migration_inbound_addr       = $::os_service_default,
  $live_migration_tunnelled          = $::os_service_default,
  $live_migration_completion_timeout = $::os_service_default,
  $override_uuid                     = false,
  $configure_libvirt                 = true,
  $configure_nova                    = true,
  $client_user                       = undef,
  $client_port                       = undef,
  $client_extraparams                = {},
){

  include ::nova::deps

  if $transport {
    $transport_real = $transport
  } else {
    $transport_real = 'tcp'
  }

  validate_re($transport_real, ['^tcp$', '^tls$', '^ssh$'], 'Valid options for transport are tcp, tls, ssh.')
  validate_re($auth, [ '^sasl$', '^none$' ], 'Valid options for auth are none and sasl.')

  if $transport_real == 'tls' {
    $listen_tls = '1'
    $listen_tcp = '0'
  } elsif $transport_real == 'tcp' {
    $listen_tls = '0'
    $listen_tcp = '1'
  } else {
    $listen_tls = '0'
    $listen_tcp = '0'
  }

  if $configure_nova {
    if $transport_real == 'ssh' {
      if $client_user {
        $prefix =  "${client_user}@"
      } else {
        $prefix = ''
      }
    } else {
      $prefix = ''
    }

    if $client_port {
      $postfix = ":${client_port}"
    } else {
      $postfix = ''
    }

    if $client_extraparams != {} {
      $extra_params_before_python_escape = join(uriescape(join_keys_to_values($client_extraparams, '=')), '&')
      # Must escape % as nova interprets it incorrectly.
      $extra_params = sprintf('?%s', regsubst($extra_params_before_python_escape, '%', '%%', 'G'))
    } else {
      $extra_params =''
    }

    $live_migration_uri = "qemu+${transport_real}://${prefix}%s${postfix}/system${extra_params}"

    nova_config {
      'libvirt/live_migration_uri':                value => $live_migration_uri;
      'libvirt/live_migration_tunnelled':          value => $live_migration_tunnelled;
      'libvirt/live_migration_completion_timeout': value => $live_migration_completion_timeout;
      'libvirt/live_migration_inbound_addr':       value => $live_migration_inbound_addr;
    }
  }

  if $configure_libvirt {
    Anchor['nova::config::begin']
    -> Libvirtd_config<||>
    -> File_line<| tag == 'libvirt-file_line'|>
    -> Anchor['nova::config::end']

    Libvirtd_config<||>
    ~> Service['libvirt']

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

    libvirtd_config {
      'listen_tls': value => $listen_tls;
      'listen_tcp': value => $listen_tcp;
    }

    if $transport_real == 'tls' {
      libvirtd_config {
        'auth_tls': value => "\"${auth}\"";
      }
    } elsif $transport_real == 'tcp' {
      libvirtd_config {
        'auth_tcp': value => "\"${auth}\"";
      }
    }

    if $listen_address {
      libvirtd_config {
        'listen_addr': value => "\"${listen_address}\"";
      }
    }

    case $::osfamily {
      'RedHat': {
        if $transport_real != 'ssh' {
          file_line { '/etc/sysconfig/libvirtd libvirtd args':
            path  => '/etc/sysconfig/libvirtd',
            line  => 'LIBVIRTD_ARGS="--listen"',
            match => 'LIBVIRTD_ARGS=',
            tag   => 'libvirt-file_line',
          }
        }
      }

      'Debian': {
        if $transport_real != 'ssh' {
          file_line { "/etc/default/${::nova::compute::libvirt::libvirt_service_name} libvirtd opts":
            path  => "/etc/default/${::nova::compute::libvirt::libvirt_service_name}",
            line  => 'libvirtd_opts="-l"',
            match => 'libvirtd_opts=',
            tag   => 'libvirt-file_line',
          }
        }
      }

      default:  {
        warning("Unsupported osfamily: ${::osfamily}, make sure you are configuring this yourself")
      }
    }
  }
}
