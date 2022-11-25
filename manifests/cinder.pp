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
class nova::cinder (
  $password            = $::os_service_default,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000/',
  $timeout             = $::os_service_default,
  $project_name        = 'services',
  $project_domain_name = 'Default',
  $system_scope        = $::os_service_default,
  $username            = 'cinder',
  $user_domain_name    = 'Default',
  $os_region_name      = $::os_service_default,
  $catalog_info        = $::os_service_default,
  $http_retries        = $::os_service_default,
  $cross_az_attach     = $::os_service_default,
  $debug               = $::os_service_default,
) {

  include nova::deps

  if is_service_default($password) {
    # Controller nodes do not require the admin credential while controller
    # nodes require it. We keep the credential optional here to avoid
    # requiring unnecessary credential.
    $auth_type_real           = $::os_service_default
    $auth_url_real            = $::os_service_default
    $project_name_real        = $::os_service_default
    $project_domain_name_real = $::os_service_default
    $system_scope_real        = $::os_service_default
    $username_real            = $::os_service_default
    $user_domain_name_real    = $::os_service_default
  } else {
    $auth_type_real           = $auth_type
    $auth_url_real            = $auth_url
    $username_real            = $username
    $user_domain_name_real    = $user_domain_name
    $system_scope_real        = $system_scope

    if is_service_default($system_scope) {
      $project_name_real = $project_name
      $project_domain_name_real = $project_domain_name
    } else {
      $project_name_real = $::os_service_default
      $project_domain_name_real = $::os_service_default
    }
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
    'cinder/os_region_name':      value => $os_region_name;
    'cinder/catalog_info':        value => $catalog_info;
    'cinder/http_retries':        value => $http_retries;
    'cinder/cross_az_attach':     value => $cross_az_attach;
    'cinder/debug':               value => $debug;
  }
}
