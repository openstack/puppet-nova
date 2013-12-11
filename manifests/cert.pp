# == Class: nova::cert
#
# Installs nova cert package and service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether or not to enable the nova cert service
#   Defaults to false
#
# [*ensure_package*]
#   (optional) The state to set for the nova-cert package
#   Defaults to 'present'
#
class nova::cert(
  $enabled        = false,
  $ensure_package = 'present'
) {

  include nova::params

  nova::generic_service { 'cert':
    enabled        => $enabled,
    package_name   => $::nova::params::cert_package_name,
    service_name   => $::nova::params::cert_service_name,
    ensure_package => $ensure_package,
  }

}
