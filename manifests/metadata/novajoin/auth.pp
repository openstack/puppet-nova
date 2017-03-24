# == Class: nova::metadata::novajoin::auth
#
# Creates nova endpoints and service account in keystone
#
# === Parameters:
#
# [*password*]
#   Password to create for the service user
#
# [*auth_name*]
#   (optional) The name of the novajoin service user
#   Defaults to 'novajoin'
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'novajoin'.
#
# [*service_description*]
#   (optional) Description for keystone service.
#   Defaults to 'Openstack Compute Service'.
#
# [*public_url*]
#   (optional) The endpoint's public url.
#   Defaults to 'http://127.0.0.1:8774/v2.1'
#
# [*internal_url*]
#   (optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:8774/v2.1'
#
# [*admin_url*]
#   (optional) The endpoint's admin url.
#   Defaults to 'http://127.0.0.1:8774/v2.1'
#
# [*region*]
#   (optional) The region in which to place the endpoints
#   Defaults to 'RegionOne'
#
# [*tenant*]
#   (optional) The tenant to use for the novajoin service user
#   Defaults to 'services'
#
# [*email*]
#   (optional) The email address for the novajoin service user
#   Defaults to 'novajoin@localhost'
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
class nova::metadata::novajoin::auth(
  $password,
  $auth_name               = 'novajoin',
  $service_name            = 'novajoin',
  $service_description     = 'Novajoin vendordata plugin',
  $region                  = 'RegionOne',
  $tenant                  = 'services',
  $email                   = 'novajoin@localhost',
  $public_url              = 'http://127.0.0.1:9090',
  $internal_url            = 'http://127.0.0.1:9090',
  $admin_url               = 'http://127.0.0.1:9090',
  $configure_endpoint      = false,
  $configure_user          = true,
  $configure_user_role     = true,
) {

  if $configure_endpoint {
    Keystone_endpoint["${region}/${service_name}::compute-vendordata-plugin"] ~> Service <| name == 'novajoin-server' |>
    Keystone_endpoint["${region}/${service_name}::compute-vendordata-plugin"] ~> Service <| name == 'novajoin-notify' |>
  }

  keystone::resource::service_identity { 'novajoin':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => 'compute-vendordata-plugin',
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
