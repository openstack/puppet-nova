# == Class: nova::schedule
#
# Install and manage nova scheduler
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to run the scheduler service
#   Defaults to false
#
# [*ensure_package*]
#   (optional) The state of the scheduler package
#   Defaults to 'present'
#
class nova::scheduler(
  $enabled        = false,
  $ensure_package = 'present'
) {

  include nova::params

  nova::generic_service { 'scheduler':
    enabled        => $enabled,
    package_name   => $::nova::params::scheduler_package_name,
    service_name   => $::nova::params::scheduler_service_name,
    ensure_package => $ensure_package,
  }

}
