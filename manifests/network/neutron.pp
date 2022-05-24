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
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $::os_service_default
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
# [*http_retries*]
#   (optional) Number of times neutronclient should retry on any failed http
#   call.
#   Defaults to $::os_service_default
#
# [*service_type*]
#   (optional) The default service_type for endpoint URL discovery.
#   Defaults to $::os_service_default
#
# [*ovs_bridge*]
#   (optional) Name of Integration Bridge used by Open vSwitch
#   Defaults to $::os_service_default
#
# [*extension_sync_interval*]
#   (optional) Number of seconds before querying neutron for extensions
#   Defaults to $::os_service_default
#
# [*vif_plugging_is_fatal*]
#   (optional) Fail to boot instance if vif plugging fails.
#   This prevents nova from booting an instance if vif plugging notification
#   is not received from neutron.
#   Defaults to $::os_service_default
#
# [*vif_plugging_timeout*]
#   (optional) Number of seconds to wait for neutron vif plugging events.
#   Set to '0' and vif_plugging_is_fatal to 'False' if vif plugging
#   notification is not being used.
#   Defaults to $::os_service_default
#
# [*default_floating_pool*]
#   (optional) Default pool for floating IPs
#   Defaults to $::os_service_default
#
class nova::network::neutron (
  $password,
  $auth_type               = 'v3password',
  $project_name            = 'services',
  $project_domain_name     = 'Default',
  $system_scope            = $::os_service_default,
  $username                = 'neutron',
  $user_domain_name        = 'Default',
  $auth_url                = 'http://127.0.0.1:5000/v3',
  $valid_interfaces        = $::os_service_default,
  $endpoint_override       = $::os_service_default,
  $timeout                 = '30',
  $region_name             = 'RegionOne',
  $http_retries            = $::os_service_default,
  $service_type            = $::os_service_default,
  $ovs_bridge              = $::os_service_default,
  $extension_sync_interval = $::os_service_default,
  $vif_plugging_is_fatal   = $::os_service_default,
  $vif_plugging_timeout    = $::os_service_default,
  $default_floating_pool   = $::os_service_default,
) {

  include nova::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $::os_service_default
    $project_domain_name_real = $::os_service_default
  }

  nova_config {
    'DEFAULT/vif_plugging_is_fatal':   value => $vif_plugging_is_fatal;
    'DEFAULT/vif_plugging_timeout':    value => $vif_plugging_timeout;
    'neutron/default_floating_pool':   value => $default_floating_pool;
    'neutron/timeout':                 value => $timeout;
    'neutron/project_name':            value => $project_name_real;
    'neutron/project_domain_name':     value => $project_domain_name_real;
    'neutron/system_scope':            value => $system_scope;
    'neutron/region_name':             value => $region_name;
    'neutron/username':                value => $username;
    'neutron/user_domain_name':        value => $user_domain_name;
    'neutron/password':                value => $password, secret => true;
    'neutron/auth_url':                value => $auth_url;
    'neutron/valid_interfaces':        value => join(any2array($valid_interfaces), ',');
    'neutron/endpoint_override':       value => $endpoint_override;
    'neutron/http_retries':            value => $http_retries;
    'neutron/service_type':            value => $service_type;
    'neutron/ovs_bridge':              value => $ovs_bridge;
    'neutron/extension_sync_interval': value => $extension_sync_interval;
    'neutron/auth_type':               value => $auth_type;
  }
}
