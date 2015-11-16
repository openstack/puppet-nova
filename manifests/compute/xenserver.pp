# == Class: nova::compute::xenserver
#
# Configures nova-compute to manage xen guests
#
# === Parameters:
#
# [*xenapi_connection_url*]
#   (required) URL for connection to XenServer/Xen Cloud Platform.
#
# [*xenapi_connection_username*]
#   (required) Username for connection to XenServer/Xen Cloud Platform
#
# [*xenapi_connection_password*]
#   (required) Password for connection to XenServer/Xen Cloud Platform
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'xenapi.XenAPIDriver'
#
# [*xenapi_inject_image*]
#   (optional) DEPRECATED: This parameter does nothing.
#
class nova::compute::xenserver(
  $xenapi_connection_url,
  $xenapi_connection_username,
  $xenapi_connection_password,
  $compute_driver = 'xenapi.XenAPIDriver',
  # DEPRECATED PARAMETERS
  $xenapi_inject_image = undef,
) {

  include ::nova::deps

  if $xenapi_inject_image != undef {
    warning('The xenapi_inject_image parameter is deprecated and has no effect.')
  }

  nova_config {
    'DEFAULT/compute_driver':             value => $compute_driver;
    'DEFAULT/xenapi_connection_url':      value => $xenapi_connection_url;
    'DEFAULT/xenapi_connection_username': value => $xenapi_connection_username;
    'DEFAULT/xenapi_connection_password': value => $xenapi_connection_password;
  }

  ensure_packages(['python-pip'])

  package { 'xenapi':
    ensure   => present,
    provider => pip,
    tag      => ['openstack', 'nova-support-package'],
  }

  Package['python-pip'] -> Package['xenapi']
}
