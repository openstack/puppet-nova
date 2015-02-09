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
# [*auth_name_v3*]
#   (optional) The name of the nova v3 service user
#   Defaults to 'novav3'
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name, but must differ from the value
#   of service_name_v3.
#
# [*service_name_v3*]
#   (optional) Name of the v3 service.
#   Defaults to the value of auth_name_v3, but must differ from the value
#   of service_name.
#
# [*public_address*]
#   (optional) The public nova-api endpoint
#   Defaults to '127.0.0.1'
#
# [*admin_address*]
#   (optional) The admin nova-api endpoint
#   Defaults to '127.0.0.1'
#
# [*internal_address*]
#   (optional) The internal nova-api endpoint
#   Defaults to '127.0.0.1'
#
# [*compute_port*]
#   (optional) The port to use for the compute endpoint
#   Defaults to '8774'
#
# [*ec2_port*]
#   (optional) The port to use for the ec2 endpoint
#   Defaults to '8773'
#
# [*compute_version*]
#   (optional) The version of the compute api to put in the endpoint
#   Defaults to 'v2'
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
# [*configure_ec2_endpoint*]
#   (optional) Whether to create an ec2 endpoint
#   Defaults to true
#
# [*configure_endpoint*]
#   (optional) Whether to create the endpoint.
#   Defaults to true
#
# [*configure_endpoint_v3*]
#   (optional) Whether to create the v3 endpoint.
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
# [*public_protocol*]
#   (optional) Protocol to use for the public endpoint. Can be http or https.
#   Defaults to 'http'
#
# [*admin_protocol*]
#   Protocol for admin endpoints. Defaults to 'http'.
#
# [*internal_protocol*]
#   Protocol for internal endpoints. Defaults to 'http'.
#
class nova::keystone::auth(
  $password,
  $auth_name              = 'nova',
  $auth_name_v3           = 'novav3',
  $service_name           = undef,
  $service_name_v3        = undef,
  $public_address         = '127.0.0.1',
  $admin_address          = '127.0.0.1',
  $internal_address       = '127.0.0.1',
  $compute_port           = '8774',
  $ec2_port               = '8773',
  $compute_version        = 'v2',
  $region                 = 'RegionOne',
  $tenant                 = 'services',
  $email                  = 'nova@localhost',
  $configure_ec2_endpoint = true,
  $public_protocol        = 'http',
  $configure_endpoint     = true,
  $configure_endpoint_v3  = true,
  $configure_user         = true,
  $configure_user_role    = true,
  $admin_protocol         = 'http',
  $internal_protocol      = 'http'
) {

  if $service_name == undef {
    $real_service_name = $auth_name
  } else {
    $real_service_name = $service_name
  }

  if $service_name_v3 == undef {
    $real_service_name_v3 = $auth_name_v3
  } else {
    $real_service_name_v3 = $service_name_v3
  }

  if $real_service_name == $real_service_name_v3 {
    fail('nova::keystone::auth parameters service_name and service_name_v3 must be different.')
  }

  Keystone_endpoint["${region}/${real_service_name}"] ~> Service <| name == 'nova-api' |>

  keystone::resource::service_identity { "nova service, user ${auth_name}":
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => 'compute',
    service_description => 'Openstack Compute Service',
    service_name        => $real_service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => "${public_protocol}://${public_address}:${compute_port}/${compute_version}/%(tenant_id)s",
    admin_url           => "${admin_protocol}://${admin_address}:${compute_port}/${compute_version}/%(tenant_id)s",
    internal_url        => "${internal_protocol}://${internal_address}:${compute_port}/${compute_version}/%(tenant_id)s",
  }

  keystone::resource::service_identity { "nova v3 service, user ${auth_name_v3}":
    configure_user      => false,
    configure_user_role => false,
    configure_endpoint  => $configure_endpoint_v3,
    configure_service   => $configure_endpoint_v3,
    service_type        => 'computev3',
    service_description => 'Openstack Compute Service v3',
    service_name        => $real_service_name_v3,
    region              => $region,
    auth_name           => $auth_name_v3,
    public_url          => "${public_protocol}://${public_address}:${compute_port}/v3",
    admin_url           => "${admin_protocol}://${admin_address}:${compute_port}/v3",
    internal_url        => "${internal_protocol}://${internal_address}:${compute_port}/v3",
  }

  keystone::resource::service_identity { "nova ec2 service, user ${auth_name}_ec2":
    configure_user      => false,
    configure_user_role => false,
    configure_endpoint  => $configure_ec2_endpoint,
    configure_service   => $configure_ec2_endpoint,
    service_type        => 'ec2',
    service_description => 'EC2 Service',
    service_name        => "${real_service_name}_ec2",
    region              => $region,
    auth_name           => "${auth_name}_ec2",
    public_url          => "${public_protocol}://${public_address}:${ec2_port}/services/Cloud",
    admin_url           => "${admin_protocol}://${admin_address}:${ec2_port}/services/Admin",
    internal_url        => "${internal_protocol}://${internal_address}:${ec2_port}/services/Cloud",
  }

}
