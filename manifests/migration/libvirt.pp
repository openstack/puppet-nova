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
# [*live_migration_with_native_tls*]
#   (optional) This option will allow both migration stream (guest RAM plus
#   device state) *and* disk stream to be transported over native TLS, i.e.
#   TLS support built into QEMU.
#   Prerequisite: TLS environment is configured correctly on all relevant
#   Compute nodes.  This means, Certificate Authority (CA), server, client
#   certificates, their corresponding keys, and their file permisssions are
#   in place, and are validated.
#   Defaults to $::os_service_default
#
# [*live_migration_completion_timeout*]
#   (optional) Time to wait, in seconds, for migration to successfully complete
#   transferring data before aborting the operation. Value is per GiB of guest
#   RAM + disk to be transferred, with lower bound of a minimum of 2 GiB. Set
#   to 0 to disable timeouts.
#   Defaults to $::os_service_default
#
# [*live_migration_timeout_action*]
#   (optional) This option will be used to determine what action will be taken
#   against a VM after live_migration_completion_timeout expires. By default,
#   the live migrate operation will be aborted after completion timeout.
#   If it is set to force_complete, the compute service will either pause the
#   VM or trigger post-copy depending on if post copy is enabled and available
#   Defaults to $::os_service_default
#
# [*live_migration_permit_post_copy*]
#   (optional) This option allows nova to switch an on-going live migration
#   to post-copy mode, i.e., switch the active VM to the one on the destination
#   node before the migration is complete, therefore ensuring an upper bound
#   on the memory that needs to be transferred.
#   Post-copy requires libvirt>=1.3.3 and QEMU>=2.5.0.
#   Defaults to $::os_service_default
#
# [*live_migration_permit_auto_converge*]
#   (optional) This option allows nova to start live migration with auto
#   converge on. Auto converge throttles down CPU if a progress of on-going
#   live migration is slow. Auto converge will only be used if this flag is
#   set to True and post copy is not permitted or post copy is unavailable
#   due to the version of libvirt and QEMU in use.
#   Defaults to $::os_service_default
#
# [*override_uuid*]
#   (optional) Set uuid not equal to output from dmidecode (boolean)
#   Defaults to false
#
# [*host_uuid*]
#   (optional) Set host_uuid to this value, instead of generating a random
#   uuid, if override_uuid is set to true.
#   Defaults to undef
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
# [*ca_file*]
#   (optional) Specifies the CA certificate that the TLS transport will use.
#   Note that this is only used if the TLS transport is enabled via the
#   "transport" option.
#   Defaults to undef
#
# [*crl_file*]
#   (optional) Specifies the CRL file that the TLS transport will use.
#   Note that this is only used if the TLS transport is enabled via the
#   "transport" option.
#   Defaults to undef
#
# [*libvirt_version*]
#   (optional) installed libvirt version. Default is automatic detected depending
#   of the used OS installed via ::nova::compute::libvirt::version::default .
#   Defaults to ::nova::compute::libvirt::version::default
#
class nova::migration::libvirt(
  $transport                           = undef,
  $auth                                = 'none',
  $listen_address                      = undef,
  $live_migration_inbound_addr         = $::os_service_default,
  $live_migration_tunnelled            = $::os_service_default,
  $live_migration_with_native_tls      = $::os_service_default,
  $live_migration_completion_timeout   = $::os_service_default,
  $live_migration_timeout_action       = $::os_service_default,
  $live_migration_permit_post_copy     = $::os_service_default,
  $live_migration_permit_auto_converge = $::os_service_default,
  $override_uuid                       = false,
  $host_uuid                           = undef,
  $configure_libvirt                   = true,
  $configure_nova                      = true,
  $client_user                         = undef,
  $client_port                         = undef,
  $client_extraparams                  = {},
  $ca_file                             = undef,
  $crl_file                            = undef,
  $libvirt_version                     = $::nova::compute::libvirt::version::default,
) inherits nova::compute::libvirt::version {

  include nova::deps

  if $transport {
    $transport_real = $transport
  } else {
    $transport_real = 'tcp'
  }

  validate_legacy(Enum['tcp', 'tls', 'ssh'], 'validate_re', $transport_real,
    [['^tcp$', '^tls$', '^ssh$'], 'Valid options for transport are tcp, tls, ssh.'])
  validate_legacy(Enum['sasl', 'none'], 'validate_re', $auth,
    [['^sasl$', '^none$'], 'Valid options for auth are none and sasl.'])

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
      'libvirt/live_migration_uri':                  value => $live_migration_uri;
      'libvirt/live_migration_tunnelled':            value => $live_migration_tunnelled;
      'libvirt/live_migration_with_native_tls':      value => $live_migration_with_native_tls;
      'libvirt/live_migration_completion_timeout':   value => $live_migration_completion_timeout;
      'libvirt/live_migration_timeout_action':       value => $live_migration_timeout_action;
      'libvirt/live_migration_inbound_addr':         value => $live_migration_inbound_addr;
      'libvirt/live_migration_permit_post_copy':     value => $live_migration_permit_post_copy;
      'libvirt/live_migration_permit_auto_converge': value => $live_migration_permit_auto_converge;
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
        $host_uuid_real = pick(
          $host_uuid,
          generate('/bin/cat', '/proc/sys/kernel/random/uuid'))
        file { '/etc/libvirt/libvirt_uuid':
          content => $host_uuid_real,
          require => Package['libvirt'],
        }
      } else {
        $host_uuid_real = $::libvirt_uuid
      }

      augeas { 'libvirt-conf-uuid':
        context => '/files/etc/libvirt/libvirtd.conf',
        changes => [
          "set host_uuid ${host_uuid_real}",
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
      if $ca_file {
        libvirtd_config {
          'ca_file': value => "\"${ca_file}\"";
        }
      }
      if $crl_file {
        libvirtd_config {
          'crl_file': value => "\"${crl_file}\"";
        }
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

    if $transport_real == 'tls' or $transport_real == 'tcp' {
      if versioncmp($libvirt_version, '5.6') >= 0 {
        # Since libvirt >= 5.6 and libvirtd is managed by systemd,
        # system socket should be activated by systemd, not by --listen option
        $manage_services = pick($::nova::compute::libvirt::manage_libvirt_services, true)

        if $manage_services {
          # libvirtd.service should be stopped before socket service is started.
          # Otherwise, socket service fails to start.
          exec { 'stop libvirtd.service':
            path    => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
            command => 'systemctl -q stop libvirtd.service',
            unless  => "systemctl -q is-active libvirtd-${transport_real}.socket",
            require => Anchor['nova::install::end']
          }

          service { "libvirtd-${transport_real}":
            ensure  => 'running',
            name    => "libvirtd-${transport_real}.socket",
            enable  => true,
            require => Anchor['nova::config::end']
          }

          Exec['stop libvirtd.service'] -> Service["libvirtd-${transport_real}"] -> Service<| title == 'libvirt' |>
        }

        # --listen option should be disabled in newer libvirt
        $libvirtd_service_listen = false

      } else {
        # For older libvirt --listen option should be used.
        $libvirtd_service_listen = true
      }

      case $::osfamily {
        'RedHat': {
          if $libvirtd_service_listen {
            $libvirtd_args = '"--listen"'
          } else {
            $libvirtd_args = ''
          }

          file_line { '/etc/sysconfig/libvirtd libvirtd args':
            path  => '/etc/sysconfig/libvirtd',
            line  => "LIBVIRTD_ARGS=${libvirtd_args}",
            match => '^LIBVIRTD_ARGS=',
            tag   => 'libvirt-file_line',
          }
        }
        'Debian': {
          if $libvirtd_service_listen {
            $libvirtd_opts = '"-l"'
          } else {
            $libvirtd_opts = ''
          }

          file_line { "/etc/default/${::nova::compute::libvirt::libvirt_service_name} libvirtd opts":
            path  => "/etc/default/${::nova::compute::libvirt::libvirt_service_name}",
            line  => "libvirtd_opts=${libvirtd_opts}",
            match => 'libvirtd_opts=',
            tag   => 'libvirt-file_line',
          }
        }
        default: {
          warning("Unsupported osfamily: ${::osfamily}, make sure you are configuring this yourself")
        }
      }
    }
  }
}
