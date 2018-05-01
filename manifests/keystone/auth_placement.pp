# == Class: nova::keystone::auth_placement
#
# Creates nova placement api endpoints and service account in keystone
#
# === Parameters:
#
# [*password*]
#   Password to create for the service user
#
# [*auth_name*]
#   (optional) The name of the placement service user
#   Defaults to 'placement'
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'placement'.
#
# [*service_description*]
#   (optional) Description for keystone service.
#   Defaults to 'Openstack Placement Service'.
#
# [*public_url*]
#   (optional) The endpoint's public url.
#   Defaults to 'http://127.0.0.1/placement'
#
# [*internal_url*]
#   (optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1/placement'
#
# [*admin_url*]
#   (optional) The endpoint's admin url.
#   Defaults to 'http://127.0.0.1/placement'
#
# [*region*]
#   (optional) The region in which to place the endpoints
#   Defaults to 'RegionOne'
#
# [*tenant*]
#   (optional) The tenant to use for the nova service user
#   Defaults to 'services'
#
# [*email*]
#   (optional) The email address for the nova service user
#   Defaults to 'placement@localhost'
#
# [*configure_endpoint*]
#   (optional) Whether to create the endpoint.
#   Defaults to true
#
# [*configure_user*]
#   (optional) Whether to create the service user.
#   Defaults to true
#
# [*configure_user_role*]
#   (optional) Whether to configure the admin role for the service user.
#   Defaults to true
#
class nova::keystone::auth_placement(
  $password,
  $auth_name               = 'placement',
  $service_name            = 'placement',
  $service_description     = 'Openstack Placement Service',
  $region                  = 'RegionOne',
  $tenant                  = 'services',
  $email                   = 'placement@localhost',
  $public_url              = $::nova::params::placement_public_url,
  $internal_url            = $::nova::params::placement_internal_url,
  $admin_url               = $::nova::params::placement_admin_url,
  $configure_endpoint      = true,
  $configure_user          = true,
  $configure_user_role     = true,
) inherits nova::params {

  include ::nova::deps

  keystone::resource::service_identity { 'placement':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => 'placement',
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

}
