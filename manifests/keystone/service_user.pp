# class: nova::keystone::service_user
#
# Configure the service_user section in the configuration file
#
# === Parameters
#
# [*username*]
#   (Optional) The name of the service user
#   Defaults to 'nova'
#
# [*password*]
#   (Optional) Password to create for the service user
#   Defaults to $facts['os_service_default']
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http:://127.0.0.1:5000'
#
# [*project_name*]
#   (Optional) Service project name
#   Defaults to 'services'
#
# [*user_domain_name*]
#   (Optional) Name of domain for $user_domain_name
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (Optional) Name of domain for $project_domain_name
#   Defaults to 'Default'
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $facts['os_service_default']
#
# [*send_service_user_token*]
#   (Optional) The service uses service token feature when this is set as true
#   Defaults to $facts['os_service_default']
#
# [*insecure*]
#   (Optional) If true, explicitly allow TLS without checking server cert
#   against any certificate authorities.  WARNING: not recommended.  Use with
#   caution.
#   Defaults to $facts['os_service_default']
#
# [*auth_type*]
#   (Optional) Authentication type to load
#   Defaults to 'password'
#
# [*auth_version*]
#   (Optional) API version of the admin Identity API endpoint.
#   Defaults to $facts['os_service_default'].
#
# [*cafile*]
#   (Optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to $facts['os_service_default'].
#
# [*certfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $facts['os_service_default'].
#
# [*keyfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $facts['os_service_default'].
#
# [*region_name*]
#   (Optional) The region in which the identity server can be found.
#   Defaults to $facts['os_service_default'].
#
class nova::keystone::service_user (
  $username                = 'nova',
  $password                = $facts['os_service_default'],
  $auth_url                = 'http://127.0.0.1:5000/',
  $project_name            = 'services',
  $user_domain_name        = 'Default',
  $project_domain_name     = 'Default',
  $system_scope            = $facts['os_service_default'],
  $send_service_user_token = $facts['os_service_default'],
  $insecure                = $facts['os_service_default'],
  $auth_type               = 'password',
  $auth_version            = $facts['os_service_default'],
  $cafile                  = $facts['os_service_default'],
  $certfile                = $facts['os_service_default'],
  $keyfile                 = $facts['os_service_default'],
  $region_name             = $facts['os_service_default'],
) {
  include nova::deps

  keystone::resource::service_user { 'nova_config':
    username                => $username,
    password                => $password,
    project_name            => $project_name,
    auth_url                => $auth_url,
    auth_version            => $auth_version,
    auth_type               => $auth_type,
    user_domain_name        => $user_domain_name,
    project_domain_name     => $project_domain_name,
    system_scope            => $system_scope,
    send_service_user_token => $send_service_user_token,
    insecure                => $insecure,
    cafile                  => $cafile,
    certfile                => $certfile,
    keyfile                 => $keyfile,
    region_name             => $region_name,
  }
}
