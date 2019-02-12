# == Class: nova::keystone::auth_placement
#
# Creates nova placement api endpoints and service account in keystone
#
# This class is deprecated and will be removed in a future release in favour of
# the puppet-placement module.

# === Parameters:
#
# DEPRECATED PARAMETERS
#
# [*password*]
#   (Required) Password to create for the service user
#
# [*auth_name*]
#   (Optional) The name of the placement service user
#   Defaults to 'placement'
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'placement'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Openstack Placement Service'.
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   Defaults to 'http://127.0.0.1/placement'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1/placement'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   Defaults to 'http://127.0.0.1/placement'
#
# [*region*]
#   (Optional) The region in which to place the endpoints
#   Defaults to 'RegionOne'
#
# [*tenant*]
#   (Optional) The tenant to use for the nova service user
#   Defaults to 'services'
#
# [*email*]
#   (Optional) The email address for the nova service user
#   Defaults to 'placement@localhost'
#
# [*configure_endpoint*]
#   (Optional) Whether to create the endpoint.
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Whether to create the service user.
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Whether to configure the admin role for the service user.
#   Defaults to true
#
class nova::keystone::auth_placement(
  # DEPRECATED PARAMETERS
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

  warning('nova::keystone::auth_placement is deprecated and will be removed in a future release')

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
