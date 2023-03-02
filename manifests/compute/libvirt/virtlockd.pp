# == Class: nova::compute::libvirt::virtlockd
#
# virtlockd configuration
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
# [*max_size*]
#   Maximum file size before rolling over.
#   Defaults to $facts['os_service_default']
#
# [*max_backups*]
#   Maximum number of backup files to keep.
#   Defaults to $facts['os_service_default']
#
class nova::compute::libvirt::virtlockd (
  $log_level         = $facts['os_service_default'],
  $log_filters       = $facts['os_service_default'],
  $log_outputs       = $facts['os_service_default'],
  $max_clients       = $facts['os_service_default'],
  $admin_max_clients = $facts['os_service_default'],
  $max_size          = $facts['os_service_default'],
  $max_backups       = $facts['os_service_default'],
) {

  include nova::deps

  virtlockd_config {
    'log_level':         value => pick($log_level, $facts['os_service_default']);
    'log_filters':       value => pick($log_filters, $facts['os_service_default']), quote => true;
    'log_outputs':       value => pick($log_outputs, $facts['os_service_default']), quote => true;
    'max_clients':       value => pick($max_clients, $facts['os_service_default']);
    'admin_max_clients': value => pick($admin_max_clients, $facts['os_service_default']);
    'max_size':          value => pick($max_size, $facts['os_service_default']);
    'max_backups':       value => pick($max_backups, $facts['os_service_default']);
  }
}
