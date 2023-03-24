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
#   Defaults to $facts['os_service_default'] (bind to all addresses)
#
# [*live_migration_inbound_addr*]
#   (optional) The IP address or hostname to be used as the target for live
#   migration traffic.
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*live_migration_with_native_tls*]
#   (optional) This option will allow both migration stream (guest RAM plus
#   device state) *and* disk stream to be transported over native TLS, i.e.
#   TLS support built into QEMU.
#   Prerequisite: TLS environment is configured correctly on all relevant
#   Compute nodes.  This means, Certificate Authority (CA), server, client
#   certificates, their corresponding keys, and their file permissions are
#   in place, and are validated.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_downtime*]
#   (optional) Target maximum period of time Nova will try to keep the instance paused
#   during the last part of the memory copy, in miliseconds.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_downtime_steps*]
#   (optional) Number of incremental steps to reach max downtime value.
#   Minimum number of steps is 3.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_downtime_delay*]
#   (optional) Time to wait, in seconds, between each step increase of the migration
#   downtime. Value is per GiB of guest RAM + disk to be transferred, with lower bound
#   of a minimum of 2 GiB per device. Minimum delay is 3 seconds.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_completion_timeout*]
#   (optional) Time to wait, in seconds, for migration to successfully complete
#   transferring data before aborting the operation. Value is per GiB of guest
#   RAM + disk to be transferred, with lower bound of a minimum of 2 GiB. Set
#   to 0 to disable timeouts.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_timeout_action*]
#   (optional) This option will be used to determine what action will be taken
#   against a VM after live_migration_completion_timeout expires. By default,
#   the live migrate operation will be aborted after completion timeout.
#   If it is set to force_complete, the compute service will either pause the
#   VM or trigger post-copy depending on if post copy is enabled and available
#   Defaults to $facts['os_service_default']
#
# [*live_migration_permit_post_copy*]
#   (optional) This option allows nova to switch an on-going live migration
#   to post-copy mode, i.e., switch the active VM to the one on the destination
#   node before the migration is complete, therefore ensuring an upper bound
#   on the memory that needs to be transferred.
#   Post-copy requires libvirt>=1.3.3 and QEMU>=2.5.0.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_permit_auto_converge*]
#   (optional) This option allows nova to start live migration with auto
#   converge on. Auto converge throttles down CPU if a progress of on-going
#   live migration is slow. Auto converge will only be used if this flag is
#   set to True and post copy is not permitted or post copy is unavailable
#   due to the version of libvirt and QEMU in use.
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*crl_file*]
#   (optional) Specifies the CRL file that the TLS transport will use.
#   Note that this is only used if the TLS transport is enabled via the
#   "transport" option.
#   Defaults to $facts['os_service_default']
#
# [*libvirt_version*]
#   (optional) installed libvirt version. Default is automatic detected depending
#   of the used OS installed via ::nova::compute::libvirt::version::default .
#   Defaults to ::nova::compute::libvirt::version::default
#
# [*modular_libvirt*]
#   (optional) Whether to enable modular libvirt daemons or use monolithic
#   libvirt daemon.
#   Defaults to undef
#
class nova::migration::libvirt(
  $transport                           = undef,
  $auth                                = 'none',
  $listen_address                      = $facts['os_service_default'],
  $live_migration_inbound_addr         = $facts['os_service_default'],
  $live_migration_tunnelled            = $facts['os_service_default'],
  $live_migration_with_native_tls      = $facts['os_service_default'],
  $live_migration_downtime             = $facts['os_service_default'],
  $live_migration_downtime_steps       = $facts['os_service_default'],
  $live_migration_downtime_delay       = $facts['os_service_default'],
  $live_migration_completion_timeout   = $facts['os_service_default'],
  $live_migration_timeout_action       = $facts['os_service_default'],
  $live_migration_permit_post_copy     = $facts['os_service_default'],
  $live_migration_permit_auto_converge = $facts['os_service_default'],
  $override_uuid                       = false,
  $host_uuid                           = undef,
  $configure_libvirt                   = true,
  $configure_nova                      = true,
  $client_user                         = undef,
  $client_port                         = undef,
  $client_extraparams                  = {},
  $ca_file                             = $facts['os_service_default'],
  $crl_file                            = $facts['os_service_default'],
  $libvirt_version                     = $::nova::compute::libvirt::version::default,
  $modular_libvirt                     = undef,
) inherits nova::compute::libvirt::version {

  include nova::deps
  include nova::params

  validate_legacy(Boolean, 'validate_bool', $override_uuid)
  validate_legacy(Boolean, 'validate_bool', $configure_libvirt)
  validate_legacy(Boolean, 'validate_bool', $configure_nova)

  if $transport {
    $transport_real = $transport
  } else {
    $transport_real = 'tcp'
  }

  $modular_libvirt_real = pick($modular_libvirt, $nova::params::modular_libvirt)


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
      'libvirt/live_migration_downtime':             value => $live_migration_downtime;
      'libvirt/live_migration_downtime_steps':       value => $live_migration_downtime_steps;
      'libvirt/live_migration_downtime_delay':       value => $live_migration_downtime_delay;
      'libvirt/live_migration_completion_timeout':   value => $live_migration_completion_timeout;
      'libvirt/live_migration_timeout_action':       value => $live_migration_timeout_action;
      'libvirt/live_migration_inbound_addr':         value => $live_migration_inbound_addr;
      'libvirt/live_migration_permit_post_copy':     value => $live_migration_permit_post_copy;
      'libvirt/live_migration_permit_auto_converge': value => $live_migration_permit_auto_converge;
    }
  }

  if $configure_libvirt {
    Anchor['nova::config::begin']
    -> File<| tag == 'libvirt-file'|>
    -> File_line<| tag == 'libvirt-file_line'|>
    -> Anchor['nova::config::end']

    File<| tag == 'libvirt-file'|> ~> Service['libvirt']
    File_line<| tag == 'libvirt-file_line' |> ~> Service['libvirt']

    if $override_uuid {
      if ! $facts['libvirt_uuid'] {
        $host_uuid_real = pick(
          $host_uuid,
          generate('/bin/cat', '/proc/sys/kernel/random/uuid'))
        file { '/etc/libvirt/libvirt_uuid':
          content => $host_uuid_real,
          require => Package['libvirt'],
        }
      } else {
        $host_uuid_real = $facts['libvirt_uuid']
      }

      if $modular_libvirt_real {
        ['virtqemud', 'virtproxyd', 'virtsecretd', 'virtnodedevd', 'virtstoraged'].each |String $daemon| {
          augeas { "${daemon}-conf-uuid":
            context => "/files/etc/libvirt/${daemon}.conf",
            changes => ["set host_uuid ${host_uuid_real}"],
            notify  => Service[$daemon],
            require => Package['libvirt'],
          }
        }
      } else {
        augeas { 'libvirt-conf-uuid':
          context => '/files/etc/libvirt/libvirtd.conf',
          changes => ["set host_uuid ${host_uuid_real}"],
          notify  => Service['libvirt'],
          require => Package['libvirt'],
        }
      }
    }

    if $transport_real == 'tls' {
      $auth_tls_real = $auth
      $auth_tcp_real = $facts['os_service_default']
      $ca_file_real  = $ca_file
      $crl_file_real = $crl_file
    } elsif $transport_real == 'tcp' {
      $auth_tls_real = $facts['os_service_default']
      $auth_tcp_real = $auth
      $ca_file_real  = $facts['os_service_default']
      $crl_file_real = $facts['os_service_default']
    } else {
      $auth_tls_real = $facts['os_service_default']
      $auth_tcp_real = $facts['os_service_default']
      $ca_file_real  = $facts['os_service_default']
      $crl_file_real = $facts['os_service_default']
    }

    $libvirt_listen_config = $modular_libvirt_real ? {
      true    => 'virtproxyd_config',
      default => 'libvirtd_config'
    }

    create_resources( $libvirt_listen_config , {
      'listen_tls' => { 'value' => $listen_tls },
      'listen_tcp' => { 'value' => $listen_tcp },
      'auth_tls'   => { 'value' => $auth_tls_real, 'quote' => true },
      'auth_tcp'   => { 'value' => $auth_tcp_real, 'quote' => true },
      'ca_file'    => { 'value' => $ca_file_real, 'quote'  => true },
      'crl_file'   => { 'value' => $crl_file_real, 'quote' => true },
      'listen_addr' => { 'value' => $listen_address, 'quote' => true }
    })

    if $transport_real == 'tls' or $transport_real == 'tcp' {
      if versioncmp($libvirt_version, '5.6') < 0 {
        fail('libvirt version < 5.6 is no longer supported')
      }
      # Since libvirt >= 5.6, system socket of libvirt should be activated
      # by systemd, not by --listen option
      $manage_services = pick($::nova::compute::libvirt::manage_libvirt_services, true)

      if $manage_services {
        $proxy_service = $modular_libvirt ? {
          true    => 'virtproxyd',
          default => 'libvirtd',
        }
        $socket_name = "${proxy_service}-${transport_real}"

        # This is the dummy resource to trigger exec to stop libvirtd.service.
        # libvirtd.service should be stopped before socket is started.
        # Otherwise, socket fails to start.
        exec { "check ${socket_name}.socket":
          command => '/usr/bin/true',
          path    => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          unless  => "systemctl -q is-active ${socket_name}.socket",
          require => Anchor['nova::config::end']
        }

        exec { "stop ${proxy_service}.service":
          command     => "systemctl -q stop ${proxy_service}.service",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          refreshonly => true,
          require     => Anchor['nova::install::end']
        }

        service { $socket_name:
          ensure  => 'running',
          name    => "${socket_name}.socket",
          enable  => true,
          require => Anchor['nova::config::end']
        }

        Exec["check ${socket_name}.socket"]
        ~> Exec["stop ${proxy_service}.service"]
        -> Service[$socket_name]

        if is_service_default($listen_address) {
          file { "/etc/systemd/system/${socket_name}.socket":
            ensure  => absent,
            require => Anchor['nova::install::end']
          } ~> exec { 'systemd-damon-reload':
            command     => 'systemctl daemon-reload',
            path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
            refreshonly => true,
          } ~> Service[$socket_name]

        } else {
          $listen_address_real = normalize_ip_for_uri($listen_address)

          $default_listen_port = $transport_real ? {
            'tls'   => 16514,
            default => 16509
          }
          $listen_port = pick($client_port, $default_listen_port)

          # TODO(tkajinam): We have to completely override the socket file,
          #                 because dropin does not allow us to remove
          #                 ListenStream in the base file.
          exec { "create ${socket_name}.socket":
            command => "cp /usr/lib/systemd/system/${socket_name}.socket /etc/systemd/system/",
            path    => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
            creates => "/etc/systemd/system/${socket_name}.socket",
            require => Anchor['nova::install::end'],
          } -> file_line { "${proxy_service}-${transport_real}.socket ListenStream":
            path  => "/etc/systemd/system/${socket_name}.socket",
            line  => "ListenStream=${listen_address_real}:${listen_port}",
            match => '^ListenStream=.*',
          } ~> exec { 'systemd-damon-reload':
            command     => 'systemctl daemon-reload',
            path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
            refreshonly => true,
          } ~> Service[$socket_name]
          Exec["create ${socket_name}.socket"] ~> Exec['systemd-damon-reload']
        }

        # We have to stop libvirtd.service to restart socket.
        Exec['systemd-damon-reload'] ~> Exec["stop ${proxy_service}.service"]

        if $modular_libvirt {
          Service["${proxy_service}-${transport_real}"] -> Service<| title == 'virtproxyd' |>
        } else {
          Service["${proxy_service}-${transport_real}"] -> Service<| title == 'libvirt' |>
        }
      }
    }

    case $facts['os']['family'] {
      'RedHat': {
        # NOTE(tkajinam): Since libvirt 8.1.0, the sysconfig files are
        #                 no longer provided by packages.
        # TODO(tkajinam): Remove this after A release.
        file { '/etc/sysconfig/libvirtd':
          ensure => absent,
          path   => '/etc/sysconfig/libvirtd',
          tag    => 'libvirt-file',
        }
      }
      'Debian': {
        # TODO(tkajinam): Remove this after A release.
        file_line { '/etc/default/libvirtd libvirtd opts':
          ensure            => absent,
          path              => '/etc/default/libvirtd',
          match             => '^libvirtd_opts=$',
          match_for_absence => true,
          tag               => 'libvirt-file_line',
        }
      }
      default: {
        warning("Unsupported osfamily: ${facts['os']['family']}, make sure you are configuring this yourself")
      }
    }
  }
}
