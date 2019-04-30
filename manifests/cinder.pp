# == Class: nova::cinder
#
# Configures Cinder credentials to use by Nova.
#
# === Parameters:
#
# [*password*]
#   (required) Password for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*auth_type*]
#   Name of the auth type to load (string value)
#   Defaults to $::os_service_default
#
# [*auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to $::os_service_default
#
# [*timeout*]
#   (optional) Timeout value for connecting to cinder in seconds.
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (optional) Region name for connecting to cinder in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*project_name*]
#   (optional) Project name for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (optional) Project Domain name for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*username*]
#   (optional) Username for connecting to Cinder services in admin context
#   through the OpenStack Identity service.
#   Defaults to 'cinder'
#
# [*user_domain_name*]
#   (optional) User Domain name for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
class nova::cinder (
  $password            = $::os_service_default,
  $auth_type           = $::os_service_default,
  $auth_url            = $::os_service_default,
  $timeout             = $::os_service_default,
  $region_name         = $::os_service_default,
  $project_name        = 'services',
  $project_domain_name = 'Default',
  $username            = 'cinder',
  $user_domain_name    = 'Default',

) {

  include ::nova::deps

  nova_config {
    'cinder/password':            value => $password, secret => true;
    'cinder/auth_type':           value => $auth_type;
    'cinder/auth_url':            value => $auth_url;
    'cinder/region_name':         value => $region_name;
    'cinder/timeout':             value => $timeout;
    'cinder/project_name':        value => $project_name;
    'cinder/project_domain_name': value => $project_domain_name;
    'cinder/username':            value => $username;
    'cinder/user_domain_name':    value => $user_domain_name;

  }
}
