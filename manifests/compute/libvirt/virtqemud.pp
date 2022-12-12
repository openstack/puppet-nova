# == Class: nova::compute::libvirt::virtqemud
#
# virtqemud configuration
#
# === Parameters:
#
# [*log_level*]
#   Defines a log level to filter log outputs.
#   Defaults to $::os_service_default
#
# [*log_filters*]
#   Defines a log filter to select a different logging level for
#   for a given category log outputs.
#   Defaults to $::os_service_default
#
# [*log_outputs*]
#   (optional) Defines log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to $::os_service_default
#
# [*max_clients*]
#   The maximum number of concurrent client connections to allow
#   on primary socket.
#   Defaults to $::os_service_default
#
# [*admin_max_clients*]
#   The maximum number of concurrent client connections to allow
#   on administrative socket.
#   Defaults to $::os_service_default
#
# [*max_client_requests*]
#   Limit on concurrent requests from a single client connection.
#   Defaults to $::os_service_default
#
# [*admin_max_client_requests*]
#   Limit on concurrent requests from a single client connection
#   for the admin interface.
#   Defaults to $::os_service_default
#
# [*ovs_timeout*]
#   (optional) A timeout for openvswitch calls made by libvirt
#   Defaults to $::os_service_default
#
#
class nova::compute::libvirt::virtqemud (
  $log_level                 = $::os_service_default,
  $log_filters               = $::os_service_default,
  $log_outputs               = $::os_service_default,
  $max_clients               = $::os_service_default,
  $admin_max_clients         = $::os_service_default,
  $max_client_requests       = $::os_service_default,
  $admin_max_client_requests = $::os_service_default,
  $ovs_timeout               = $::os_service_default,
) {

  include nova::deps
  require nova::compute::libvirt

  virtqemud_config {
    'log_level':                 value => $log_level;
    'log_filters':               value => $log_filters, quote => true;
    'log_outputs':               value => $log_outputs, quote => true;
    'max_clients':               value => $max_clients;
    'admin_max_clients':         value => $admin_max_clients;
    'max_client_requests':       value => $max_client_requests;
    'admin_max_client_requests': value => $admin_max_client_requests;
    'ovs_timeout':               value => $ovs_timeout;
  }

  Anchor['nova::config::begin']
  -> Virtqemud_config<||>
  -> Anchor['nova::config::end']
}
