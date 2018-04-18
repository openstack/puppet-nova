# == Class: nova::scheduler
#
# Install and manage nova scheduler
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to run the scheduler service
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) The state of the scheduler package
#   Defaults to 'present'
#
# [*scheduler_driver*]
#   (optional) Default driver to use for the scheduler
#   Defaults to 'filter_scheduler'
#
# [*discover_hosts_in_cells_interval*]
#   (optional) This value controls how often (in seconds) the scheduler should
#   attempt to discover new hosts that have been added to cells.
#   Defaults to $::os_service_default
#
class nova::scheduler(
  $enabled                          = true,
  $manage_service                   = true,
  $ensure_package                   = 'present',
  $scheduler_driver                 = 'filter_scheduler',
  $discover_hosts_in_cells_interval = $::os_service_default,
) {

  include ::nova::deps
  include ::nova::db
  include ::nova::params

  nova::generic_service { 'scheduler':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::scheduler_package_name,
    service_name   => $::nova::params::scheduler_service_name,
    ensure_package => $ensure_package,
  }

  nova_config {
    'scheduler/driver':                           value => $scheduler_driver;
    'scheduler/discover_hosts_in_cells_interval': value => $discover_hosts_in_cells_interval;
  }

}
