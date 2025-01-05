# == Class: nova::compute::serial
#
# Configures nova serial console
#
# === Parameters:
#
# [*port_range*]
#   (optional) Range of TCP ports to use for serial ports on compute hosts
#   Defaults to $facts['os_service_default']
#
# [*base_url*]
#   (optional) URL that gets passed to the clients
#   Defaults to $facts['os_service_default']
#
# [*proxyclient_address*]
#   The address to which proxy clients (like nova-serialproxy)
#   should connect (string value)
#   Defaults to $facts['os_service_default']
#
class nova::compute::serial(
  $port_range          = $facts['os_service_default'],
  $base_url            = $facts['os_service_default'],
  $proxyclient_address = $facts['os_service_default'],
) {

  include nova::deps

  nova_config {
    'serial_console/enabled':             value => true;
    'serial_console/port_range':          value => $port_range;
    'serial_console/base_url':            value => $base_url;
    'serial_console/proxyclient_address': value => $proxyclient_address;
  }
}
