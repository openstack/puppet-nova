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
#   Defaults to undef (i.e. parameter will not be present)
#
# [*enable_new_services*]
#   (optional) When a new service (for example "nova-compute") start up, it gets
#   registered in the database as an enabled service. Setting this to false will
#   cause new services to be disabled when added. This config option is only used
#   by the conductor service which is responsible for creating the service entries.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*use_local*]
#   (optional) Perform nova-conductor operations locally
#   Defaults to undef
#
class nova::conductor(
  $enabled             = true,
  $manage_service      = true,
  $ensure_package      = 'present',
  $workers             = undef,
  $enable_new_services = $::os_service_default,
  # DEPREACTED PARAMETERS
  $use_local           = undef,
) {

  if $use_local {
    warning('use_local parameter is deprecated, has no effect and will be dropped in a future release.')
  }

  include ::nova::deps
  include ::nova::db
  include ::nova::params

  nova::generic_service { 'conductor':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::conductor_package_name,
    service_name   => $::nova::params::conductor_service_name,
    ensure_package => $ensure_package,
  }

  if $workers {
    nova_config {
      'conductor/workers': value => $workers;
    }
  }

  nova_config {
    'DEFAULT/enable_new_services': value => $enable_new_services
  }
}
