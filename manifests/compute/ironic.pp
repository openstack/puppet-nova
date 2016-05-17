# == Class: nova::compute::ironic
#
# Configures Nova compute service to use Ironic.
#
# === Parameters:
#
# [*admin_username*]
#   The admin username for Ironic to connect to Nova.
#   Defaults to 'admin'
#
# [*admin_password*]
#   The admin password for Ironic to connect to Nova.
#   Defaults to 'ironic'
#
# [*admin_url*]
#   The address of the Keystone api endpoint.
#   Defaults to 'http://127.0.0.1:35357/v2.0'
#
# [*admin_tenant_name*]
#   The Ironic Keystone tenant name.
#   Defaults to 'services'
#
# [*api_endpoint*]
#   The url for Ironic api endpoint.
#   Defaults to 'http://127.0.0.1:6385/v1'
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'ironic.IronicDriver'
#
# [*admin_user*]
#   (optional) DEPRECATED: Use admin_username instead.
#
# [*admin_passwd*]
#   (optional) DEPRECATED: Use admin_password instead.
#
# [*max_concurrent_builds*]
#   (optional) Maximum number of instance builds to run concurrently
#   Defaults to $::os_service_default.
#
class nova::compute::ironic (
  $max_concurrent_builds = $::os_service_default,
  # DEPRECATED PARAMETERS
  $admin_username        = undef,
  $admin_password        = undef,
  $admin_url             = undef,
  $admin_tenant_name     = undef,
  $api_endpoint          = undef,
  $admin_user            = undef,
  $admin_passwd          = undef,
  $compute_driver        = 'ironic.IronicDriver'
) {

  include ::nova::deps

  if $admin_user {
    warning('The admin_user parameter in class nova::compute::ironic is deprecated, use class nova::ironic::common instead.')
  }

  if $admin_passwd {
    warning('The admin_passwd parameter in class nova::compute::ironic is deprecated, use class nova::ironic::common instead.')
  }

  if $admin_username {
    warning('The admin_username parameter in class nova::compute::ironic is deprecated, use class nova::ironic::common instead.')
  }

  if $admin_password {
    warning('The admin_password parameter in class nova::compute::ironic is deprecated, use class nova::ironic::common instead.')
  }

  if $admin_url {
    warning('The admin_url parameter in class nova::compute::ironic is deprecated, use class nova::ironic::common instead.')
  }

  if $admin_tenant_name {
    warning('The admin_tenant_name parameter in class nova::compute::ironic is deprecated, use class nova::ironic::common instead.')
  }

  if $api_endpoint {
    warning('The api_endpoint parameter in class nova::compute::ironic is deprecated, use class nova::ironic::common instead.')
  }

  include ::nova::ironic::common

  nova_config {
    'DEFAULT/compute_driver':           value => $compute_driver;
    'DEFAULT/max_concurrent_builds':    value => $max_concurrent_builds;
  }
}
