# == Class: nova::placement::service
#
# Class for deploying the Placement service.
#
# This class is deprecated and will be removed in a future release in favour of
# the puppet-placement module.
#
# === Parameters:
#
# DEPRECATED PARAMETERS
#
# [*enabled*]
#   (optional) Whether the nova placement api service will be run
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Only useful if $::nova::params::service_name is set to
#   nova-placement-api.
#   Defaults to true
#
# [*package_name*]
#   (optional) The package name for nova placement.
#   Defaults to $::nova::params::placement_package_name
#
# [*service_name*]
#   (optional) The service name for the placement service.
#   Defaults to $::nova::params::placement_service_name
#
# [*ensure_package*]
#   (optional) The state of the nova placement package
#   Defaults to 'present'
#
class nova::placement::service(
  # DEPRECATED PARAMETERS
  $enabled             = true,
  $manage_service      = true,
  $package_name        = $::nova::params::placement_package_name,
  $service_name        = $::nova::params::placement_service_name,
  $ensure_package      = 'present',
) inherits nova::params {

  warning('nova::placement::service is deprecated and will be removed in a future release')

  include ::nova::deps

  assert_private()

  validate_bool($enabled)

  if $service_name == 'nova-placement-api' {
    nova::generic_service { 'nova-placement-api':
      enabled        => $enabled,
      manage_service => $manage_service,
      package_name   => $package_name,
      service_name   => $service_name,
      ensure_package => $ensure_package,
    }
  } elsif $service_name == 'httpd' {
    # we need to make sure nova-placement-api/uwsgi is stopped before trying to start apache
    if ($::os_package_type == 'debian') {
      Service['nova-placement-api'] -> Service[$service_name]
    }
  }
}
