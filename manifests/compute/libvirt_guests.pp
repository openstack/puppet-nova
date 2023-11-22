# == Class: nova::compute::libvirt_guests
#
# manages configuration for starting running instances when compute node
# gets rebooted.
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether the libvirt-guests service will be run
#   Defaults to false
#
# [*package_ensure*]
#   (optional) The state of libvirt packages
#   Defaults to 'present'
#
# [*on_boot*]
#   (optional) libvirt-guests parameter - action taken on host boot
#   - start  all guests which were running on shutdown are started on boot
#            regardless on their autostart settings
#   - ignore libvirt-guests init script won't start any guest on boot, however,
#            guests marked as autostart will still be automatically started by
#            libvirtd
#   Defaults to 'ignore'
#
# [*on_shutdown*]
#   (optional) libvirt-guests parameter - action taken on host shutdown
#   - suspend  all running guests are suspended using virsh managedsave
#   - shutdown all running guests are asked to shutdown. Please be careful with
#              this settings since there is no way to distinguish between a
#              guest which is stuck or ignores shutdown requests and a guest
#              which just needs a long time to shutdown. When setting
#              ON_SHUTDOWN=shutdown, you must also set SHUTDOWN_TIMEOUT to a
#              value suitable for your guests.
#   Defaults to 'shutdown'
#
# [*shutdown_timeout*]
#   (optional) Number of seconds we're willing to wait for a guest to shut
#   down. If parallel shutdown is enabled, this timeout applies as a timeout
#   for shutting down all guests on a single URI defined in the variable URIS.
#   If this is 0, then there is no time out (use with caution, as guests might
#   not respond to a shutdown request).
#   Defaults to undef
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to false
#
class nova::compute::libvirt_guests (
  Boolean $enabled        = false,
  $package_ensure         = 'present',
  $shutdown_timeout       = undef,
  $on_boot                = 'ignore',
  $on_shutdown            = 'shutdown',
  Boolean $manage_service = false,
) {
  include nova::params
  include nova::deps

  Anchor['nova::config::begin']
  -> File<| tag =='libvirt-guests-file' |>
  -> File_line<| tag == 'libvirt-guests-file_line'|>
  -> Anchor['nova::config::end']

  # NOTE(tkajinam): The environment file is not present in CentOS/RHEL
  file { $::nova::params::libvirt_guests_environment_file:
    ensure => present,
    path   => $::nova::params::libvirt_guests_environment_file,
    tag    => 'libvirt-guests-file',
  }

  file_line { 'libvirt-guests ON_BOOT':
    path  => $::nova::params::libvirt_guests_environment_file,
    line  => "ON_BOOT=${on_boot}",
    match => '^ON_BOOT=.*',
    tag   => 'libvirt-guests-file_line',
  }
  file_line { 'libvirt-guests ON_SHUTDOWN':
    path  => $::nova::params::libvirt_guests_environment_file,
    line  => "ON_SHUTDOWN=${on_shutdown}",
    match => '^ON_SHUTDOWN=.*',
    tag   => 'libvirt-guests-file_line',
  }

  if $shutdown_timeout {
    file_line { 'libvirt-guests SHUTDOWN_TIMEOUT':
      path  => $::nova::params::libvirt_guests_environment_file,
      line  => "SHUTDOWN_TIMEOUT=${shutdown_timeout}",
      match => '^SHUTDOWN_TIMEOUT=.*',
      tag   => 'libvirt-guests-file_line',
    }
  } else {
    file_line { 'libvirt-guests SHUTDOWN_TIMEOUT':
      ensure            => absent,
      path              => $::nova::params::libvirt_guests_environment_file,
      match             => '^SHUTDOWN_TIMEOUT=.*',
      match_for_absence => true,
      tag               => 'libvirt-guests-file_line',
    }
  }

  package { 'libvirt-client':
    ensure => $package_ensure,
    name   => $::nova::params::libvirt_client_package_name,
    tag    => ['openstack', 'nova-support-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    # NOTE(tkajinam): libvirt-service tag should NOT be added here, because
    #                 any update in libvirt config files does not require
    #                 restarting the libvirt-service. All guests running in
    #                 this node are shut off if the service is restarted.
    service { 'libvirt-guests':
      ensure  => $service_ensure,
      name    => $::nova::params::libvirt_guests_service_name,
      enable  => $enabled,
      require => Anchor['nova::service::begin'],
      notify  => Anchor['nova::service::end']
    }
  }
}
