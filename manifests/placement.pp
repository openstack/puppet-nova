# == Class: nova::placement
#
# Class for configuring the [placement] section in nova.conf.
#
# === Parameters:
#
# [*password*]
#   (required) Password for connecting to Placement API service in
#   admin context through the OpenStack Identity service.
#
# [*auth_type*]
#   Name of the auth type to load (string value)
#   Defaults to 'password'
#
# [*project_domain_name*]
#   (optional) Project Domain name for connecting to Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*project_name*]
#   (optional) Project name for connecting to Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $facts['os_service_default']
#
# [*user_domain_name*]
#   (optional) User Domain name for connecting to Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*username*]
#   (optional) Username for connecting to Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'placement'
#
# [*region_name*]
#   (optional) Region name for connecting to Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*valid_interfaces*]
#   (optional) Interface names used for getting the keystone endpoint for
#   the placement API. Comma separated if multiple.
#   Defaults to $facts['os_service_default']
#
# [*auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:5000/v3'
#
class nova::placement(
  $password,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000/v3',
  $region_name         = 'RegionOne',
  $valid_interfaces    = $facts['os_service_default'],
  $project_domain_name = 'Default',
  $project_name        = 'services',
  $system_scope        = $facts['os_service_default'],
  $user_domain_name    = 'Default',
  $username            = 'placement',
) inherits nova::params {

  include nova::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  nova_config {
    'placement/auth_type':           value => $auth_type;
    'placement/auth_url':            value => $auth_url;
    'placement/password':            value => $password, secret => true;
    'placement/project_domain_name': value => $project_domain_name_real;
    'placement/project_name':        value => $project_name_real;
    'placement/system_scope':        value => $system_scope;
    'placement/user_domain_name':    value => $user_domain_name;
    'placement/username':            value => $username;
    'placement/region_name':         value => $region_name;
    'placement/valid_interfaces':    value => join(any2array($valid_interfaces), ',');
  }

}
