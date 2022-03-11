# == Class: nova::cinder
#
# Configures Cinder credentials to use by Nova.
#
# === Parameters:
#
# [*password*]
#   (optional) Password for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*auth_type*]
#   (optional) Name of the auth type to load (string value)
#   Defaults to 'password' if password is set
#
# [*auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:5000' if password is set
#
# [*timeout*]
#   (optional) Timeout value for connecting to cinder in seconds.
#   Defaults to $::os_service_default
#
# [*project_name*]
#   (optional) Project name for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services' if password is set
#
# [*project_domain_name*]
#   (optional) Project Domain name for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default' if password is set
#
# [*system_scope*]
#   (optional) Scope for system operations.
#   Defaults to $::os_service_default
#
# [*username*]
#   (optional) Username for connecting to Cinder services in admin context
#   through the OpenStack Identity service.
#   Defaults to 'cinder' if password is set
#
# [*user_domain_name*]
#   (optional) User Domain name for connecting to Cinder services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default' if password is set
#
# [*os_region_name*]
#   (optional) Sets the os_region_name flag. For environments with
#   more than one endpoint per service, this is required to make
#   things such as cinder volume attach work. If you don't set this
#   and you have multiple endpoints, you will get AmbiguousEndpoint
#   exceptions in the nova API service.
#   Defaults to $::os_service_default
#
# [*catalog_info*]
#   (optional) Info to match when looking for cinder in the service
#   catalog. Format is: separated values of the form:
#   <service_type>:<service_name>:<endpoint_type>
#   Defaults to $::os_service_default
#
# [*http_retries*]
#   (optional) Number of times cinderclient should retry on any failed http
#   call.
#   Defaults to $::os_service_default
#
# [*cross_az_attach*]
#   (optional) Allow attach between instance and volume in different availability zones.
#   Defaults to $::os_service_default
#
# [*debug*]
#   (optional) Enable DEBUG logging with cinderclient and os_brick
#   independently of the rest of Nova.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*region_name*]
#   (optional) Region name for connecting to cinder in admin context
#   through the OpenStack Identity service.
#   Defaults to undef
#
class nova::cinder (
  $password            = $::os_service_default,
  $auth_type           = undef,
  $auth_url            = undef,
  $timeout             = $::os_service_default,
  $project_name        = undef,
  $project_domain_name = undef,
  $system_scope        = undef,
  $username            = undef,
  $user_domain_name    = undef,
  $os_region_name      = $::os_service_default,
  $catalog_info        = $::os_service_default,
  $http_retries        = $::os_service_default,
  $cross_az_attach     = $::os_service_default,
  $debug               = $::os_service_default,
  # DEPRECATED PARAMETERS
  $region_name         = undef,
) {

  include nova::deps

  $os_region_name_real = pick($::nova::os_region_name, $os_region_name)
  $catalog_info_real = pick($::nova::cinder_catalog_info, $catalog_info)
  $cross_az_attach_real = pick($::nova::cross_az_attach, $cross_az_attach)

  if $region_name != undef {
    warning('The nova::cinder::region_name parameter is deprecated and has no effect. \
Use the nova::cinder::os_region_name parameter')
  }
  nova_config {
    'cinder/region_name': ensure => absent;
  }


  if is_service_default($password) {
    $auth_type_real           = pick($auth_type, $::os_service_default)
    $auth_url_real            = pick($auth_url, $::os_service_default)
    $project_name_real        = pick($project_name, $::os_service_default)
    $project_domain_name_real = pick($project_domain_name, $::os_service_default)
    $system_scope_real        = pick($system_scope, $::os_service_default)
    $username_real            = pick($username, $::os_service_default)
    $user_domain_name_real    = pick($user_domain_name, $::os_service_default)
  } else {
    $system_scope_real = pick($system_scope, $::os_service_default)
    if is_service_default($system_scope_real) {
      $project_name_real = pick($project_name, 'services')
      $project_domain_name_real = pick($project_domain_name, 'Default')
    } else {
      $project_name_real = $::os_service_default
      $project_domain_name_real = $::os_service_default
    }
    $auth_type_real           = pick($auth_type, 'password')
    $auth_url_real            = pick($auth_url, 'http://127.0.0.1:5000/')
    $username_real            = pick($username, 'cinder')
    $user_domain_name_real    = pick($user_domain_name, 'Default')
  }

  nova_config {
    'cinder/password':            value => $password, secret => true;
    'cinder/auth_type':           value => $auth_type_real;
    'cinder/auth_url':            value => $auth_url_real;
    'cinder/timeout':             value => $timeout;
    'cinder/project_name':        value => $project_name_real;
    'cinder/project_domain_name': value => $project_domain_name_real;
    'cinder/system_scope':        value => $system_scope_real;
    'cinder/username':            value => $username_real;
    'cinder/user_domain_name':    value => $user_domain_name_real;
    'cinder/os_region_name':      value => $os_region_name_real;
    'cinder/catalog_info':        value => $catalog_info_real;
    'cinder/http_retries':        value => $http_retries;
    'cinder/cross_az_attach':     value => $cross_az_attach_real;
    'cinder/debug':               value => $debug;
  }
}
