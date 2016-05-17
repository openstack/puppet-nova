# == Class: nova::ironic::common
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
class nova::ironic::common (
  $admin_username    = 'admin',
  $admin_password    = 'ironic',
  $admin_tenant_name = 'services',
  $admin_url         = 'http://127.0.0.1:35357/v2.0',
  $api_endpoint      = 'http://127.0.0.1:6385/v1',
) {

  include ::nova::deps

  $admin_username_real = pick(
    $::nova::compute::ironic::admin_user,
    $::nova::compute::ironic::admin_username,
    $admin_username)
  $admin_password_real = pick(
    $::nova::compute::ironic::admin_passwd,
    $::nova::compute::ironic::admin_password,
    $admin_password)
  $admin_tenant_name_real = pick(
    $::nova::compute::ironic::admin_tenant_name,
    $admin_tenant_name)
  $admin_url_real = pick(
    $::nova::compute::ironic::admin_url,
    $admin_url)
  $api_endpoint_real = pick(
    $::nova::compute::ironic::api_endpoint,
    $api_endpoint)

  nova_config {
    'ironic/admin_username':    value => $admin_username_real;
    'ironic/admin_password':    value => $admin_password_real;
    'ironic/admin_url':         value => $admin_url_real;
    'ironic/admin_tenant_name': value => $admin_tenant_name_real;
    'ironic/api_endpoint':      value => $api_endpoint_real;
  }
}
