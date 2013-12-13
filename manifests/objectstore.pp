# == Class: nova::objectstore
#
# Manages the nova-objectstore service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the service
#   Defaults to false
#
# [*ensure_package*]
#   (optional) The package state to set
#   Defaults to 'present'
#
class nova::objectstore(
  $enabled        = false,
  $ensure_package = 'present'
) {

  include nova::params

  nova::generic_service { 'objectstore':
    enabled        => $enabled,
    package_name   => $::nova::params::objectstore_package_name,
    service_name   => $::nova::params::objectstore_service_name,
    ensure_package => $ensure_package,
  }

}
