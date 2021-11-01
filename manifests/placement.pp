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
# [*project_name*]
#   (optional) Project name for connecting to Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (optional) Project Domain name for connecting to Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*user_domain_name*]
#   (optional) User Domain name for connecting to Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*region_name*]
#   (optional) Region name for connecting to Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*valid_interfaces*]
#   (optional) Interface names used for getting the keystone endpoint for
#   the placement API. Comma separated if multiple.
#   Defaults to $::os_service_default
#
# [*username*]
#   (optional) Username for connecting to Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'placement'
#
# [*auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:5000/v3'
#
class nova::placement(
  $password            = false,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000/v3',
  $region_name         = 'RegionOne',
  $valid_interfaces    = $::os_service_default,
  $project_domain_name = 'Default',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $username            = 'placement',
) inherits nova::params {

  include nova::deps

  nova_config {
    'placement/auth_type':           value => $auth_type;
    'placement/auth_url':            value => $auth_url;
    'placement/password':            value => $password, secret => true;
    'placement/project_domain_name': value => $project_domain_name;
    'placement/project_name':        value => $project_name;
    'placement/user_domain_name':    value => $user_domain_name;
    'placement/username':            value => $username;
    'placement/region_name':         value => $region_name;
    'placement/valid_interfaces':    value => join(any2array($valid_interfaces), ',');
  }

}
