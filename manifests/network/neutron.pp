# == Class: nova::network::neutron
#
# Configures Nova network to use Neutron.
#
# === Parameters:
#
# [*password*]
#   (required) Password for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#
# [*auth_type*]
#   Name of the auth type to load (string value)
#   Defaults to 'v3password'
#
# [*project_name*]
#   (optional) Project name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (optional) Project Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*username*]
#   (optional) Username for connecting to Neutron network services in admin context
#   through the OpenStack Identity service.
#   Defaults to 'neutron'
#
# [*user_domain_name*]
#   (optional) User Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:5000/v3'
#
# [*valid_interfaces*]
#   (optional) The endpoint type to lookup when talking to Neutron.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   (optional) Override the endpoint to use to talk to Neutron.
#   Defaults to $::os_service_default
#
# [*timeout*]
#   (optional) Timeout value for connecting to neutron in seconds.
#   Defaults to '30'
#
# [*region_name*]
#   (optional) Region name for connecting to neutron in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*ovs_bridge*]
#   (optional) Name of Integration Bridge used by Open vSwitch
#   Defaults to 'br-int'
#
# [*extension_sync_interval*]
#   (optional) Number of seconds before querying neutron for extensions
#   Defaults to '600'
#
# [*vif_plugging_is_fatal*]
#   (optional) Fail to boot instance if vif plugging fails.
#   This prevents nova from booting an instance if vif plugging notification
#   is not received from neutron.
#   Defaults to 'True'
#
# [*vif_plugging_timeout*]
#   (optional) Number of seconds to wait for neutron vif plugging events.
#   Set to '0' and vif_plugging_is_fatal to 'False' if vif plugging
#   notification is not being used.
#   Defaults to '300'
#
# [*default_floating_pool*]
#   (optional) Default pool for floating IPs
#   Defaults to 'nova'
#
# DEPRECATED
#
# [*neutron_password*]
#   (optional) Password for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*neutron_auth_type*]
#   Name of the auth type to load (string value)
#   Defaults to undef
#
# [*neutron_project_name*]
#   (optional) Project name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*neutron_project_domain_name*]
#   (optional) Project Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*neutron_username*]
#   (optional) Username for connecting to Neutron network services in admin context
#   through the OpenStack Identity service.
#   Defaults to undef
#
# [*neutron_user_domain_name*]
#   (optional) User Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*neutron_auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to undef
#
# [*neutron_valid_interfaces*]
#   (optional) The endpoint type to lookup when talking to Neutron.
#   Defaults to undef
#
# [*neutron_endpoint_override*]
#   (optional) Override the endpoint to use to talk to Neutron.
#   Defaults to undef
#
# [*neutron_timeout*]
#   (optional) Timeout value for connecting to neutron in seconds.
#   Defaults to undef
#
# [*neutron_region_name*]
#   (optional) Region name for connecting to neutron in admin context
#   through the OpenStack Identity service.
#   Defaults to undef
#
# [*neutron_ovs_bridge*]
#   (optional) Name of Integration Bridge used by Open vSwitch
#   Defaults to undef
#
# [*neutron_extension_sync_interval*]
#   (optional) Number of seconds before querying neutron for extensions
#   Defaults to undef
#
class nova::network::neutron (
  $password                        = false,
  $auth_type                       = 'v3password',
  $project_name                    = 'services',
  $project_domain_name             = 'Default',
  $username                        = 'neutron',
  $user_domain_name                = 'Default',
  $auth_url                        = 'http://127.0.0.1:5000/v3',
  $valid_interfaces                = $::os_service_default,
  $endpoint_override               = $::os_service_default,
  $timeout                         = '30',
  $region_name                     = 'RegionOne',
  $ovs_bridge                      = 'br-int',
  $extension_sync_interval         = '600',
  $vif_plugging_is_fatal           = true,
  $vif_plugging_timeout            = '300',
  $default_floating_pool           = 'nova',
  #DEPRECATED
  $neutron_password                = undef,
  $neutron_auth_type               = undef,
  $neutron_project_name            = undef,
  $neutron_project_domain_name     = undef,
  $neutron_username                = undef,
  $neutron_user_domain_name        = undef,
  $neutron_auth_url                = undef,
  $neutron_valid_interfaces        = undef,
  $neutron_endpoint_override       = undef,
  $neutron_timeout                 = undef,
  $neutron_region_name             = undef,
  $neutron_ovs_bridge              = undef,
  $neutron_extension_sync_interval = undef,
) {

  include nova::deps

  if $neutron_password != undef {
    warning('The neutron_password parameter was deprecated. Use password instead')
    $password_real = $neutron_password
  } else {
    $password_real = $password
  }

  if $neutron_auth_type != undef {
    warning('The neutron_auth_type parameter was deprecated. Use auth_type instead')
    $auth_type_real = $neutron_auth_type
  } else {
    $auth_type_real = $auth_type
  }

  if $neutron_project_name != undef {
    warning('The neutron_project_name parameter was deprecated. Use project_name instead')
    $project_name_real = $neutron_project_name
  } else {
    $project_name_real = $project_name
  }

  if $neutron_project_domain_name != undef {
    warning('The neutron_project_domain_name parameter was deprecated. Use project_domain_name instead')
    $project_domain_name_real = $neutron_project_domain_name
  } else {
    $project_domain_name_real = $project_domain_name
  }

  if $neutron_username != undef {
    warning('The neutron_username parameter was deprecated. Use username instead')
    $username_real = $neutron_username
  } else {
    $username_real = $username
  }

  if $neutron_user_domain_name != undef {
    warning('The neutron_user_domain_name parameter was deprecated. Use user_domain_name_name instead')
    $user_domain_name_real = $neutron_user_domain_name
  } else {
    $user_domain_name_real = $user_domain_name
  }

  if $neutron_auth_url != undef {
    warning('The neutron_auth_url parameter was deprecated. Use auth_url instead')
    $auth_url_real = $neutron_auth_url
  } else {
    $auth_url_real = $auth_url
  }

  if $neutron_valid_interfaces != undef {
    warning('The neutron_valid_interfaces parameter was deprecated. Use valid_interfaces instead')
    $valid_interfaces_real = $neutron_valid_interfaces
  } else {
    $valid_interfaces_real = $valid_interfaces
  }

  if $neutron_endpoint_override != undef {
    warning('The neutron_endpoint_override parameter was deprecated. Use endpoint_override instead')
    $endpoint_override_real = $neutron_endpoint_override
  } else {
    $endpoint_override_real = $endpoint_override
  }

  if $neutron_timeout != undef {
    warning('The neutron_timeout parameter was deprecated. Use timeout instead')
    $timeout_real = $neutron_timeout
  } else {
    $timeout_real = $timeout
  }

  if $neutron_region_name != undef {
    warning('The neutron_region_name parameter was deprecated. Use region_name instead')
    $region_name_real = $neutron_region_name
  } else {
    $region_name_real = $region_name
  }

  if $neutron_ovs_bridge != undef {
    warning('The neutron_ovs_bridge parameter was deprecated. Use ovs_bridge instead')
    $ovs_bridge_real = $neutron_ovs_bridge
  } else {
    $ovs_bridge_real = $ovs_bridge
  }

  if $neutron_extension_sync_interval != undef {
    warning('The neutron_extension_sync_interval parameter was deprecated. Use extension_sync_interval instead')
    $extension_sync_interval_real = $neutron_extension_sync_interval
  } else {
    $extension_sync_interval_real = $extension_sync_interval
  }

  nova_config {
    'DEFAULT/vif_plugging_is_fatal':   value => $vif_plugging_is_fatal;
    'DEFAULT/vif_plugging_timeout':    value => $vif_plugging_timeout;
    'neutron/default_floating_pool':   value => $default_floating_pool;
    'neutron/timeout':                 value => $timeout_real;
    'neutron/project_name':            value => $project_name_real;
    'neutron/project_domain_name':     value => $project_domain_name_real;
    'neutron/region_name':             value => $region_name_real;
    'neutron/username':                value => $username_real;
    'neutron/user_domain_name':        value => $user_domain_name_real;
    'neutron/password':                value => $password_real, secret => true;
    'neutron/auth_url':                value => $auth_url_real;
    'neutron/valid_interfaces':        value => $valid_interfaces_real;
    'neutron/endpoint_override':       value => $endpoint_override_real;
    'neutron/ovs_bridge':              value => $ovs_bridge_real;
    'neutron/extension_sync_interval': value => $extension_sync_interval_real;
    'neutron/auth_type':               value => $auth_type_real;
  }
}
