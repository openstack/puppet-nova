# == Class: nova::conductor
#
# Manages nova conductor package and service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the nova-conductor service
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) The state of the nova conductor package
#   Defaults to 'present'
#
# [*workers*]
#   (optional) Number of workers for OpenStack Conductor service
#   Defaults to $facts['os_workers']
#
# [*enable_new_services*]
#   (optional) When a new service (for example "nova-compute") start up, it gets
#   registered in the database as an enabled service. Setting this to false will
#   cause new services to be disabled when added. This config option is only used
#   by the conductor service which is responsible for creating the service entries.
#   Defaults to $facts['os_service_default']
#
class nova::conductor(
  Boolean $enabled        = true,
  Boolean $manage_service = true,
  $ensure_package         = 'present',
  $workers                = $facts['os_workers'],
  $enable_new_services    = $facts['os_service_default'],
) {

  include nova::deps
  include nova::db
  include nova::params
  include nova::availability_zone

  nova::generic_service { 'conductor':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::conductor_package_name,
    service_name   => $::nova::params::conductor_service_name,
    ensure_package => $ensure_package,
  }

  nova_config {
    'conductor/workers':           value => $workers;
    'DEFAULT/enable_new_services': value => $enable_new_services
  }
}
