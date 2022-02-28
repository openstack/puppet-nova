# == Class: nova::limit
#
# Configure oslo_limit options
#
# === Parameters:
#
# [*endpoint_id*]
#   (Required) The service's endpoint id which is registered in Keystone.
#
# [*password*]
#   (Required) Password to create for the service user
#
# [*username*]
#   (Optional) The name of the service user
#   Defaults to 'nova'
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http://localhost:5000'
#
# [*project_name*]
#   (Optional) Service project name
#   Defaults to 'services'
#
# [*user_domain_name*]
#   (Optional) Name of domain for $username
#   Defaults to 'Default'.
#
# [*project_domain_name*]
#   (Optional) Name of domain for $project_name
#   Defaults to 'Default'.
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to $::os_service_default
#
# [*auth_type*]
#  (Optional) Authentication type to load
#  Defaults to 'password'.
#
# [*service_type*]
#  (Optional) The name or type of the service as it appears in the service
#  catalog. This is used to validate tokens that have restricted access rules.
#  Defaults to $::os_service_default.
#
# [*valid_interfaces*]
#  (Optional) List of interfaces, in order of preference, for endpoint URL.
#  Defaults to $::os_service_default.
#
# [*region_name*]
#  (Optional) The region in which the identity server can be found.
#  Defaults to $::os_service_default.
#
# [*endpoint_override*]
#  (Optional) Always use this endpoint URL for requests for this client.
#  Defualts to $::os_service_default.
#
class nova::limit(
  $endpoint_id,
  $password,
  $username            = 'nova',
  $auth_url            = 'http://localhost:5000',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $system_scope        = $::os_service_default,
  $auth_type           = 'password',
  $service_type        = $::os_service_default,
  $valid_interfaces    = $::os_service_default,
  $region_name         = $::os_service_default,
  $endpoint_override   = $::os_service_default,
) {

  include nova::deps

  oslo::limit { 'nova_config':
    endpoint_id         => $endpoint_id,
    username            => $username,
    password            => $password,
    auth_url            => $auth_url,
    project_name        => $project_name,
    user_domain_name    => $user_domain_name,
    project_domain_name => $project_domain_name,
    system_scope        => $system_scope,
    auth_type           => $auth_type,
    service_type        => $service_type,
    valid_interfaces    => join(any2array($valid_interfaces), ','),
    region_name         => $region_name,
    endpoint_override   => $endpoint_override,
  }
}
