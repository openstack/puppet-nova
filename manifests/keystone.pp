# == Class: nova::keystone
#
# Configures Keystone credentials to use by Nova.
#
# === Parameters:
#
# [*password*]
#   (required) Password for connecting to Keystone services in
#   admin context through the OpenStack Identity service.
#
# [*auth_type*]
#   (optional) Name of the auth type to load (string value)
#   Defaults to 'password'
#
# [*auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to $::os_service_default
#
# [*timeout*]
#   (optional) Timeout value for connecting to keystone in seconds.
#   Defaults to $::os_service_default
#
# [*service_type*]
#   (optional) The default service_type for endpoint URL discovery.
#   Defaults to $::os_service_default
#
# [*valid_interfaces*]
#   (optional) List of interfaces, in order of preference for endpoint URL.
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (optional) Region name for connecting to keystone in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   (optional) Always use this endpoint URL for requests for this client.
#   Defaults to $::os_service_default
#
# [*project_name*]
#   (optional) Project name for connecting to Keystone services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (optional) Project Domain name for connecting to Keystone services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $::os_service_default
#
# [*username*]
#   (optional) Username for connecting to Keystone services in admin context
#   through the OpenStack Identity service.
#   Defaults to 'keystone'
#
# [*user_domain_name*]
#   (optional) User Domain name for connecting to Keystone services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# =
#
class nova::keystone (
  $password,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000',
  $timeout             = $::os_service_default,
  $service_type        = $::os_service_default,
  $valid_interfaces    = $::os_service_default,
  $endpoint_override   = $::os_service_default,
  $region_name         = $::os_service_default,
  $project_name        = 'services',
  $project_domain_name = 'Default',
  $system_scope        = $::os_service_default,
  $username            = 'nova',
  $user_domain_name    = 'Default',
) {

  include nova::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $::os_service_default
    $project_domain_name_real = $::os_service_default
  }

  nova_config {
    'keystone/password':            value => $password, secret => true;
    'keystone/auth_type':           value => $auth_type;
    'keystone/auth_url':            value => $auth_url;
    'keystone/service_type':        value => $service_type;
    'keystone/valid_interfaces':    value => join(any2array($valid_interfaces), ',');
    'keystone/endpoint_override':   value => $endpoint_override;
    'keystone/region_name':         value => $region_name;
    'keystone/timeout':             value => $timeout;
    'keystone/project_name':        value => $project_name_real;
    'keystone/project_domain_name': value => $project_domain_name_real;
    'keystone/system_scope':        value => $system_scope;
    'keystone/username':            value => $username;
    'keystone/user_domain_name':    value => $user_domain_name;
  }
}
