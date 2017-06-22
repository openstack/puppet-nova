# == Class: nova::compute::ironic
#
# Configures Nova compute service to use Ironic.
#
# === Parameters:
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'ironic.IronicDriver'
#
# [*max_concurrent_builds*]
#   (optional) Maximum number of instance builds to run concurrently
#   Defaults to $::os_service_default.
#
class nova::compute::ironic (
  $max_concurrent_builds = $::os_service_default,
  $compute_driver        = 'ironic.IronicDriver'
) {

  include ::nova::deps
  require ::nova::ironic::common
  include ::ironic::client

  nova_config {
    'DEFAULT/compute_driver':           value => $compute_driver;
    'DEFAULT/max_concurrent_builds':    value => $max_concurrent_builds;
  }
}
