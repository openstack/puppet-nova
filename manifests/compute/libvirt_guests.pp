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
# [*start_delay*]
#   (optional) Number of seconds to wait between each guest start. Set 0 to
#   allow parallel startup.
#   Defaults to undef
#
# [*parallel_shutdown*]
#   (optional) Number of guests will be shutdown concurrently, taking effect
#   when "ON_SHUTDOWN" is set to "shutdown". If set to 0, guests will be
#   shutdown one after another. Number of guests on shutdown at any time will
#   not exceed number set in this variable.
#   Defaults to undef
#
# [*shutdown_timeout*]
#   (optional) Number of seconds we're willing to wait for a guest to shut
#   down. If parallel shutdown is enabled, this timeout applies as a timeout
#   for shutting down all guests on a single URI defined in the variable URIS.
#   If this is 0, then there is no time out (use with caution, as guests might
#   not respond to a shutdown request).
#   Defaults to undef
#
# [*bypass_cache*]
#   (optional) Try to bypass the file system cache when saving and restoring
#   guests, even though this may give slower operation for some file systems.
#   Defaults to false
#
# [*sync_time*]
#   (optional) Try to sync guest time on domain resume. Be aware, that this
#   requires guest agent support for time synchronization running in the guest.
#   Defaults to false
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to false
#
class nova::compute::libvirt_guests (
  Boolean $enabled                         = false,
  $package_ensure                          = 'present',
  Enum['start', 'ignore'] $on_boot         = 'ignore',
  Enum['suspend', 'shutdown'] $on_shutdown = 'shutdown',
  Optional[Integer[0]] $start_delay        = undef,
  Optional[Integer[0]] $parallel_shutdown  = undef,
  Optional[Integer[0]] $shutdown_timeout   = undef,
  Boolean $bypass_cache                    = false,
  Boolean $sync_time                       = false,
  Boolean $manage_service                  = false,
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

  if $start_delay {
    file_line { 'libvirt-guests START_DELAY':
      path  => $::nova::params::libvirt_guests_environment_file,
      line  => "START_DELAY=${start_delay}",
      match => '^START_DELAY=.*',
      tag   => 'libvirt-guests-file_line',
    }
  } else {
    file_line { 'libvirt-guests START_DELAY':
      ensure            => absent,
      path              => $::nova::params::libvirt_guests_environment_file,
      match             => '^START_DELAY=.*',
      match_for_absence => true,
      tag               => 'libvirt-guests-file_line',
    }
  }

  if $parallel_shutdown {
    file_line { 'libvirt-guests PARALLEL_SHUTDOWN':
      path  => $::nova::params::libvirt_guests_environment_file,
      line  => "PARALLEL_SHUTDOWN=${parallel_shutdown}",
      match => '^PARALLEL_SHUTDOWN=.*',
      tag   => 'libvirt-guests-file_line',
    }
  } else {
    file_line { 'libvirt-guests PARALLEL_SHUTDOWN':
      ensure            => absent,
      path              => $::nova::params::libvirt_guests_environment_file,
      match             => '^PARALLEL_SHUTDOWN=.*',
      match_for_absence => true,
      tag               => 'libvirt-guests-file_line',
    }
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

  if $bypass_cache {
    file_line { 'libvirt-guests BYPASS_CACHE':
      path  => $::nova::params::libvirt_guests_environment_file,
      line  => 'BYPASS_CACHE=1',
      match => '^BYPASS_CACHE=.*',
      tag   => 'libvirt-guests-file_line',
    }
  } else {
    file_line { 'libvirt-guests BYPASS_CACHE':
      ensure            => absent,
      path              => $::nova::params::libvirt_guests_environment_file,
      match             => '^BYPASS_CACHE=.*',
      match_for_absence => true,
      tag               => 'libvirt-guests-file_line',
    }
  }

  if $sync_time {
    file_line { 'libvirt-guests SYNC_TIME':
      path  => $::nova::params::libvirt_guests_environment_file,
      line  => 'SYNC_TIME=1',
      match => '^SYNC_TIME=.*',
      tag   => 'libvirt-guests-file_line',
    }
  } else {
    file_line { 'libvirt-guests SYNC_TIME':
      ensure            => absent,
      path              => $::nova::params::libvirt_guests_environment_file,
      match             => '^SYNC_TIME=.*',
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
