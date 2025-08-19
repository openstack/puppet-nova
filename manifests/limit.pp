# == Class: nova::limit
#
# Configure oslo_limit options
#
# === Parameters:
#
# [*password*]
#   (Required) Password to create for the service user
#
# [*endpoint_id*]
#   (Optional) The service's endpoint id which is registered in Keystone.
#   Defaults to undef
#
# [*endpoint_service_name*]
#   (Optional) Service name for endpoint discovery
#   Defaults to 'nova'
#
# [*endpoint_service_type*]
#   (Optional) Service type for endpoint discovery
#   Defaults to 'compute'
#
# [*endpoint_region_name*]
#   (Optional) Region to which the endpoint belongs.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_interface*]
#   (Optional) The interface for endpoint discovery.
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*auth_type*]
#  (Optional) Authentication type to load
#  Defaults to 'password'.
#
# [*service_type*]
#  (Optional) The name or type of the service as it appears in the service
#  catalog. This is used to validate tokens that have restricted access rules.
#  Defaults to $facts['os_service_default'].
#
# [*valid_interfaces*]
#  (Optional) List of interfaces, in order of preference, for endpoint URL.
#  Defaults to $facts['os_service_default'].
#
# [*region_name*]
#  (Optional) The region in which the identity server can be found.
#  Defaults to $facts['os_service_default'].
#
# [*endpoint_override*]
#  (Optional) Always use this endpoint URL for requests for this client.
#  Defaults to $facts['os_service_default'].
#
class nova::limit (
  String[1] $password,
  Optional[String[1]] $endpoint_id = undef,
  String[1] $endpoint_service_name = 'nova',
  String[1] $endpoint_service_type = 'compute',
  $endpoint_region_name            = $facts['os_service_default'],
  $endpoint_interface              = $facts['os_service_default'],
  $username                        = 'nova',
  $auth_url                        = 'http://localhost:5000',
  $project_name                    = 'services',
  $user_domain_name                = 'Default',
  $project_domain_name             = 'Default',
  $system_scope                    = $facts['os_service_default'],
  $auth_type                       = 'password',
  $service_type                    = $facts['os_service_default'],
  $valid_interfaces                = $facts['os_service_default'],
  $region_name                     = $facts['os_service_default'],
  $endpoint_override               = $facts['os_service_default'],
) {
  include nova::deps

  if $endpoint_id != undef {
    $endpoint_service_name_real = undef
    $endpoint_service_type_real = undef
  } else {
    $endpoint_service_name_real = $endpoint_service_name
    $endpoint_service_type_real = $endpoint_service_type
  }

  oslo::limit { 'nova_config':
    endpoint_id           => $endpoint_id,
    endpoint_service_name => $endpoint_service_name_real,
    endpoint_service_type => $endpoint_service_type_real,
    endpoint_region_name  => $endpoint_region_name,
    endpoint_interface    => $endpoint_interface,
    username              => $username,
    password              => $password,
    auth_url              => $auth_url,
    project_name          => $project_name,
    user_domain_name      => $user_domain_name,
    project_domain_name   => $project_domain_name,
    system_scope          => $system_scope,
    auth_type             => $auth_type,
    service_type          => $service_type,
    valid_interfaces      => join(any2array($valid_interfaces), ','),
    region_name           => $region_name,
    endpoint_override     => $endpoint_override,
  }
}
