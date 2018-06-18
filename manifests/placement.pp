# == Class: nova::placement
#
# Class for configuring [placement] section in nova.conf.
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether the nova placement api service will be run
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Only useful if $::nova::params::service_name is set to
#   nova-placement-api.
#   Defaults to true
#
# [*package_name*]
#   (optional) The package name for nova placement.
#   Defaults to $::nova::params::placement_package_name
#
# [*service_name*]
#   (optional) The service name for the placement service.
#   Defaults to $::nova::params::placement_service_name
#
# [*ensure_package*]
#   (optional) The state of the nova placement package
#   Defaults to 'present'
#
# [*password*]
#   (required) Password for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#
# [*auth_type*]
#   Name of the auth type to load (string value)
#   Defaults to 'password'
#
# [*project_name*]
#   (optional) Project name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (optional) Project Domain name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*user_domain_name*]
#   (optional) User Domain name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*region_name*]
#   (optional) Region name for connecting to Nova Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*os_interface*]
#   (optional) interface name used for getting the keystone endpoint for
#   the placement API.
#   Defaults to $::os_service_default
#
# [*username*]
#   (optional) Username for connecting to Nova Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'placement'
#
# [*auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:5000/v3'
#
# DEPRECATED PARAMETERS
#
# [*os_region_name*]
#   (optional) Region name for connecting to Nova Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to undef
#
class nova::placement(
  $enabled             = true,
  $manage_service      = true,
  $package_name        = $::nova::params::placement_package_name,
  $service_name        = $::nova::params::placement_service_name,
  $ensure_package      = 'present',
  $password            = false,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000/v3',
  $region_name         = 'RegionOne',
  $os_interface        = $::os_service_default,
  $project_domain_name = 'Default',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $username            = 'placement',
  # DEPRECATED PARAMETERS
  $os_region_name      = undef,
) inherits nova::params {

  include ::nova::deps

  validate_bool($enabled)

  if $os_region_name {
    warning('The os_region_name parameter is deprecated and will be removed \
in a future release. Please use region_name instead.')
  }
  $region_name_real = pick($os_region_name, $region_name)

  if $service_name == 'nova-placement-api' {
    nova::generic_service { 'nova-placement-api':
      enabled        => $enabled,
      manage_service => $manage_service,
      package_name   => $package_name,
      service_name   => $service_name,
      ensure_package => $ensure_package,
    }
  } elsif $service_name == 'httpd' {
    # we need to make sure nova-placement-api/uwsgi is stopped before trying to start apache
    if ($::os_package_type == 'debian') {
      Service['nova-placement-api'] -> Service[$service_name]
    }
  }

  nova_config {
    'placement/auth_type':           value => $auth_type;
    'placement/auth_url':            value => $auth_url;
    'placement/password':            value => $password, secret => true;
    'placement/project_domain_name': value => $project_domain_name;
    'placement/project_name':        value => $project_name;
    'placement/user_domain_name':    value => $user_domain_name;
    'placement/username':            value => $username;
    'placement/region_name':         value => $region_name_real;
    'placement/os_interface':        value => $os_interface;
  }

}
