# == Class: nova::compute::libvirt::virtstoraged
#
# virtstoraged configuration
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
# [*ovs_timeout*]
#   (optional) A timeout for openvswitch calls made by libvirt
#   Defaults to $facts['os_service_default']
#
class nova::compute::libvirt::virtstoraged (
  $log_level         = $facts['os_service_default'],
  $log_filters       = $facts['os_service_default'],
  $log_outputs       = $facts['os_service_default'],
  $ovs_timeout       = $facts['os_service_default'],
) {
  include nova::deps

  virtstoraged_config {
    'log_level':   value => $log_level;
    'log_filters': value => join(any2array($log_filters), ' '), quote => true;
    'log_outputs': value => join(any2array($log_outputs), ' '), quote => true;
    'ovs_timeout': value => $ovs_timeout;
  }
}
