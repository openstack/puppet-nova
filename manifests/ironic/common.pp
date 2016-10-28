# == Class: nova::ironic::common
#
# [*api_endpoint*]
#   The url for Ironic api endpoint.
#   Defaults to 'http://127.0.0.1:6385/v1'
#
# [*auth_plugin*]
#   The authentication plugin to use when connecting to nova.
#   Defaults to 'password'
#
# [*auth_url*]
#   The address of the Keystone api endpoint.
#   Defaults to 'http://127.0.0.1:35357/'
#
# [*project_name*]
#   The Ironic Keystone project name.
#   Defaults to 'services'
#
# [*password*]
#   The admin password for Ironic to connect to Nova.
#   Defaults to 'ironic'
#
# [*username*]
#   The admin username for Ironic to connect to Nova.
#   Defaults to 'admin'
#
# === DEPRECATED
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
class nova::ironic::common (
  $api_endpoint      = 'http://127.0.0.1:6385/v1',
  $auth_plugin       = 'password',
  $auth_url          = 'http://127.0.0.1:35357/',
  $password          = 'ironic',
  $project_name      = 'services',
  $username          = 'admin',
  # DEPRECATED
  $admin_username    = undef,
  $admin_password    = undef,
  $admin_tenant_name = undef,
  $admin_url         = undef,
) {

  include ::nova::deps

  if ($admin_username) {
    warning('nova::ironic::common::admin_username is deprecated. Please use username')
  }

  if ($admin_password) {
    warning('nova::ironic::common::admin_password is deprecated. Please use password')
  }

  if ($admin_tenant_name) {
    warning('nova::ironic::common::admin_tenant_name is deprecated. Please use project_name')
  }

  if ($admin_url) {
    warning('nova::ironic::common::admin_url is deprecated. Please use auth_url')
  }



  $username_real = pick($admin_username, $username)
  $password_real = pick($admin_password, $password)
  $auth_url_real = pick($admin_url, $auth_url)
  $project_name_real = pick($admin_tenant_name, $project_name)


  nova_config {
    'ironic/auth_plugin':  value => $auth_plugin;
    'ironic/username':     value => $username_real;
    'ironic/password':     value => $password_real;
    'ironic/auth_url':     value => $auth_url_real;
    'ironic/project_name': value => $project_name_real;
    'ironic/api_endpoint': value => $api_endpoint;
  }

  # TODO(aschultz): these are deprecated, remove in P
  nova_config {
    'ironic/admin_username':    value => $username_real;
    'ironic/admin_password':    value => $password_real;
    'ironic/admin_url':         value => $auth_url_real;
    'ironic/admin_tenant_name': value => $project_name_real;
  }
}
