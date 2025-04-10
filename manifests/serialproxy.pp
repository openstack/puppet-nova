# == Class: nova::serialproxy
#
# Configures nova serialproxy
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to run the serialproxy service
#   Defaults to false
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*serialproxy_host*]
#   (optional) Host on which to listen for incoming requests
#   Defaults to $facts['os_service_default']
#
# [*serialproxy_port*]
#   (optional) Port on which to listen for incoming requests
#   Defaults to $facts['os_service_default']
#
# [*ensure_package*]
#   (optional) The state of the nova-serialproxy package
#   Defaults to 'present'
#
class nova::serialproxy(
  Boolean $enabled        = true,
  Boolean $manage_service = true,
  $serialproxy_host       = $facts['os_service_default'],
  $serialproxy_port       = $facts['os_service_default'],
  $ensure_package         = 'present'
) {

  include nova::deps
  include nova::params

  nova_config {
    'serial_console/serialproxy_port': value => $serialproxy_port;
    'serial_console/serialproxy_host': value => $serialproxy_host;
  }

  nova::generic_service { 'serialproxy':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::serialproxy_package_name,
    service_name   => $::nova::params::serialproxy_service_name,
    ensure_package => $ensure_package
  }

}
