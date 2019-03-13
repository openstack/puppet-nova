# == Class: nova::placement
#
# Class for deploying Placement and configuring the [placement] section in nova.conf.
#
# === Parameters:
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
# [*valid_interfaces*]
#   (optional) Interface names used for getting the keystone endpoint for
#   the placement API. Comma separated if multiple.
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
# [*os_interface*]
#   (optional) interface name used for getting the keystone endpoint for
#   the placement API.
#   Defaults to undef
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

class nova::placement(
  $password            = false,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000/v3',
  $region_name         = 'RegionOne',
  $valid_interfaces    = $::os_service_default,
  $project_domain_name = 'Default',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $username            = 'placement',
  # DEPRECATED PARAMETERS
  $os_interface        = undef,
  $enabled             = true,
  $manage_service      = true,
  $package_name        = $::nova::params::placement_package_name,
  $service_name        = $::nova::params::placement_service_name,
  $ensure_package      = 'present',
) inherits nova::params {

  include ::nova::deps

  validate_legacy(Boolean, 'validate_bool', $enabled)

  if $os_interface {
    warning('nova::placement::os_interface is deprecated for removal, please use valid_interfaces instead.')
  }
  $valid_interfaces_real = pick($os_interface, $valid_interfaces)

  class { '::nova::placement::service':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $package_name,
    service_name   => $service_name,
    ensure_package => $ensure_package,
  }

  nova_config {
    'placement/auth_type':           value => $auth_type;
    'placement/auth_url':            value => $auth_url;
    'placement/password':            value => $password, secret => true;
    'placement/project_domain_name': value => $project_domain_name;
    'placement/project_name':        value => $project_name;
    'placement/user_domain_name':    value => $user_domain_name;
    'placement/username':            value => $username;
    'placement/region_name':         value => $region_name;
    'placement/valid_interfaces':    value => $valid_interfaces_real;
  }

}
