# == Class: nova::compute::libvirt::libvirtd
#
# libvirtd configuration
#
# === Parameters:
#
# [*log_level*]
#   Defines a log level to filter log outputs.
#   Defaults to $facts['os_service_default']
#
# [*log_filters*]
#   Defines a log filter to select a different logging level for
#   for a given category log outputs.
#   Defaults to $facts['os_service_default']
#
# [*log_outputs*]
#   (optional) Defines log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to $facts['os_service_default']
#
# [*max_clients*]
#   The maximum number of concurrent client connections to allow
#   on primary socket.
#   Defaults to $facts['os_service_default']
#
# [*admin_max_clients*]
#   The maximum number of concurrent client connections to allow
#   on administrative socket.
#   Defaults to $facts['os_service_default']
#
# [*max_client_requests*]
#   Limit on concurrent requests from a single client connection.
#   Defaults to $facts['os_service_default']
#
# [*admin_max_client_requests*]
#   Limit on concurrent requests from a single client connection
#   for the admin interface.
#   Defaults to $facts['os_service_default']
#
# [*tls_priority*]
#   (optional) Override the compile time default TLS priority string. The
#   default is usually "NORMAL" unless overridden at build time.
#   Only set this if it is desired for libvirt to deviate from
#   the global default settings.
#   Defaults to $facts['os_service_default']
#
# [*ovs_timeout*]
#   (optional) A timeout for openvswitch calls made by libvirt
#   Defaults to $facts['os_service_default']
#
class nova::compute::libvirt::libvirtd (
  $log_level                 = $facts['os_service_default'],
  $log_filters               = $facts['os_service_default'],
  $log_outputs               = $facts['os_service_default'],
  $max_clients               = $facts['os_service_default'],
  $admin_max_clients         = $facts['os_service_default'],
  $max_client_requests       = $facts['os_service_default'],
  $admin_max_client_requests = $facts['os_service_default'],
  $tls_priority              = $facts['os_service_default'],
  $ovs_timeout               = $facts['os_service_default'],
) {

  include nova::deps

  libvirtd_config {
    'log_level':                 value => $log_level;
    'log_filters':               value => join(any2array($log_filters), ' '), quote => true;
    'log_outputs':               value => join(any2array($log_outputs), ' '), quote => true;
    'max_clients':               value => $max_clients;
    'admin_max_clients':         value => $admin_max_clients;
    'max_client_requests':       value => $max_client_requests;
    'admin_max_client_requests': value => $admin_max_client_requests;
    'tls_priority':              value => $tls_priority, quote => true;
    'ovs_timeout':               value => $ovs_timeout;
  }
}
