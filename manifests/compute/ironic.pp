# == Class: nova::compute::ironic
#
# Configures Nova compute service to use Ironic.
#
# === Parameters:
#
# [*ensure_package*]
#   (optional) The state of nova packages
#   Defaults to 'present'
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'ironic.IronicDriver'
#
class nova::compute::ironic (
  Stdlib::Ensure::Package $ensure_package = 'present',
  $compute_driver                         = 'ironic.IronicDriver',
) {
  include nova::deps
  require nova::ironic::common

  if($facts['os']['family'] == 'Debian') {
    package { 'nova-compute-ironic':
      ensure => $ensure_package,
      tag    => ['openstack', 'nova-package'],
    }
  }

  nova_config {
    'DEFAULT/compute_driver': value => $compute_driver;
  }
}
