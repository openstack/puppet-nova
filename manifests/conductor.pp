# == Class: nova::conductor
#
# Manages nova conductor package and service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the nova-conductor service
#   Defaults to false
#
# [*ensure_package*]
#   (optional) The state of the nova conductor package
#   Defaults to 'present'
#
class nova::conductor(
  $enabled        = false,
  $ensure_package = 'present'
) {

  include nova::params

  nova::generic_service { 'conductor':
    enabled        => $enabled,
    package_name   => $::nova::params::conductor_package_name,
    service_name   => $::nova::params::conductor_service_name,
    ensure_package => $ensure_package,
  }

}
