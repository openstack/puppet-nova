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
    'log_level':         value => $log_level;
    'log_filters':       value => join(any2array($log_filters), ' '), quote => true;
    'log_outputs':       value => join(any2array($log_outputs), ' '), quote => true;
    'max_clients':       value => $max_clients;
    'admin_max_clients': value => $admin_max_clients;
    'max_size':          value => $max_size;
    'max_backups':       value => $max_backups;
  }
}
