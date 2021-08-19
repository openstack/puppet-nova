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
class nova::compute::ironic (
  $compute_driver        = 'ironic.IronicDriver',
) {

  include nova::deps
  require nova::ironic::common
  include ironic::client

  nova_config {
    'DEFAULT/compute_driver': value => $compute_driver;
  }
}
