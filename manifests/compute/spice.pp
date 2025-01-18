# == Class: nova::compute::spice
#
# Configure spice on the compute side
#
# === Parameters:
#
# [*agent_enabled*]
#   (optional) enable spice guest agent support
#   Defaults to true
#
# [*server_listen*]
#   (optional)  IP address on which instance spice servers should listen
#   Defaults to $facts['os_service_default']
#
# [*server_proxyclient_address*]
#   (optional) Management IP Address on which instance spiceservers will
#   listen on the compute host.
#   Defaults to $facts['os_service_default']
#
# [*html5proxy_base_url*]
#   (optional) URL for the html5 console proxy
#   only used if $proxy_host is not set explicitly
#   Defaults to $facts['os_service_default']
#
# [*proxy_host*]
#   (optional) Host for the html5 console proxy
#   Defaults to undef
#
# [*proxy_port*]
#   (optional) Port for the html5 console proxy
#   Defaults to 6082
#
# [*proxy_protocol*]
#   (optional) Protocol for the html5 console proxy
#   Defaults to 'http'
#
# [*proxy_path*]
#   (optional) Path of the spice html file for the html5 console proxy
#   Defaults to '/spice_auto.html'
#
class nova::compute::spice(
  Boolean $agent_enabled                = true,
  $server_listen                        = $facts['os_service_default'],
  $server_proxyclient_address           = $facts['os_service_default'],
  $html5proxy_base_url                  = $facts['os_service_default'],
  Optional[String[1]] $proxy_host       = undef,
  Enum['http', 'https'] $proxy_protocol = 'http',
  Stdlib::Port $proxy_port              = 6082,
  String $proxy_path                    = '/spice_auto.html',
) {

  include nova::deps

  if $proxy_host {
    $html5proxy_base_url_real = "${proxy_protocol}://${proxy_host}:${proxy_port}${proxy_path}"
  } else {
    $html5proxy_base_url_real = $html5proxy_base_url
  }

  nova_config {
    'spice/agent_enabled':              value => $agent_enabled;
    'spice/server_listen':              value => $server_listen;
    'spice/server_proxyclient_address': value => $server_proxyclient_address;
    'spice/html5proxy_base_url':        value => $html5proxy_base_url_real;
  }
}
