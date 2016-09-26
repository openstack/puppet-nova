# == Class: nova::keystone::auth
#
# Creates nova endpoints and service account in keystone
#
# === Parameters:
#
# [*password*]
#   Password to create for the service user
#
# [*auth_name*]
#   (optional) The name of the nova service user
#   Defaults to 'nova'
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'nova'.
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
#   (optional) The tenant to use for the nova service user
#   Defaults to 'services'
#
# [*email*]
#   (optional) The email address for the nova service user
#   Defaults to 'nova@localhost'
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
# DEPRECATED PARAMETERS
#
# [*public_url_v3*]
#   (optional) Deprecated. The v3 endpoint's public url.
#   Defaults to undef.
#
# [*internal_url_v3*]
#   (optional) Deprecated. The v3 endpoint's internal url.
#   Defaults to undef.
#
# [*admin_url_v3*]
#   (optional) DEPRECATED The v3 endpoint's admin url.
#   Defaults to undef.
#
# [*service_description_v3*]
#   (optional) Deprecated. Description for keystone v3 service.
#   Defaults to undef.
#
# [*service_name_v3*]
#   (optional) Deprecated. Name of the v3 service.
#   Defaults to undef.
#
# [*auth_name_v3*]
#   (optional) Deprecated. The name of the nova v3 service user
#   Defaults to undef.
#
# [*configure_endpoint_v3*]
#   (optional) Deprecated. Whether to create the v3 endpoint.
#   Defaults to undef.
#
class nova::keystone::auth(
  $password,
  $auth_name               = 'nova',
  $service_name            = 'nova',
  $service_description     = 'Openstack Compute Service',
  $region                  = 'RegionOne',
  $tenant                  = 'services',
  $email                   = 'nova@localhost',
  $public_url              = 'http://127.0.0.1:8774/v2.1',
  $internal_url            = 'http://127.0.0.1:8774/v2.1',
  $admin_url               = 'http://127.0.0.1:8774/v2.1',
  $configure_endpoint      = true,
  $configure_user          = true,
  $configure_user_role     = true,
  # DEPRECATED PARAMETERS
  $auth_name_v3            = undef,
  $service_description_v3  = undef,
  $service_name_v3         = undef,
  $public_url_v3           = undef,
  $internal_url_v3         = undef,
  $admin_url_v3            = undef,
  $configure_endpoint_v3   = undef,
) {

  include ::nova::deps

  if $auth_name_v3 or $service_description_v3 or $service_name_v3 or
      $public_url_v3 or $internal_url_v3 or $admin_url_v3 or $configure_endpoint_v3 {

    warning("all parameters related to v3 API in nova::keystone::auth are \
deprecated, have no effect and will be removed after Newton release.")
  }

  if $configure_endpoint {
    Keystone_endpoint["${region}/${service_name}::compute"] ~> Service <| name == 'nova-api' |>
  }

  keystone::resource::service_identity { 'nova':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => 'compute',
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
