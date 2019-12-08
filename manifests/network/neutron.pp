# == Class: nova::network::neutron
#
# Configures Nova network to use Neutron.
#
# === Parameters:
#
# [*neutron_password*]
#   (required) Password for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#
# [*neutron_auth_type*]
#   Name of the auth type to load (string value)
#   Defaults to 'v3password'
#
# [*neutron_project_name*]
#   (optional) Project name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*neutron_project_domain_name*]
#   (optional) Project Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*neutron_username*]
#   (optional) Username for connecting to Neutron network services in admin context
#   through the OpenStack Identity service.
#   Defaults to 'neutron'
#
# [*neutron_user_domain_name*]
#   (optional) User Domain name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*neutron_auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:5000/v3'
#
# [*neutron_valid_interfaces*]
#   (optional) The endpoint type to lookup when talking to Neutron.
#   Defaults to $::os_service_default
#
# [*neutron_endpoint_override*]
#   (optional) Override the endpoint to use to talk to Neutron.
#   Defaults to $::os_service_default
#
# [*neutron_timeout*]
#   (optional) Timeout value for connecting to neutron in seconds.
#   Defaults to '30'
#
# [*neutron_region_name*]
#   (optional) Region name for connecting to neutron in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*neutron_ovs_bridge*]
#   (optional) Name of Integration Bridge used by Open vSwitch
#   Defaults to 'br-int'
#
# [*neutron_extension_sync_interval*]
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
### DEPRECATED PARAMS
#
# [*neutron_url*]
#   (optional) URL for connecting to the Neutron networking service.
#   Defaults to undef
#
# [*neutron_url_timeout*]
#   (optional) Timeout value for connecting to neutron in seconds.
#   Defaults to undef
#
# [*firewall_driver*]
#   (optional) Firewall driver.
#   This prevents nova from maintaining a firewall so it does not interfere
#   with Neutron's. Set to 'nova.virt.firewall.IptablesFirewallDriver'
#   to re-enable the Nova firewall.
#   Defaults to undef
#
# [*dhcp_domain*]
#   (optional) domain to use for building the hostnames
#   Defaults to undef
#
class nova::network::neutron (
  $neutron_password                = false,
  $neutron_auth_type               = 'v3password',
  $neutron_project_name            = 'services',
  $neutron_project_domain_name     = 'Default',
  $neutron_username                = 'neutron',
  $neutron_user_domain_name        = 'Default',
  $neutron_auth_url                = 'http://127.0.0.1:5000/v3',
  $neutron_valid_interfaces        = $::os_service_default,
  $neutron_endpoint_override       = $::os_service_default,
  $neutron_timeout                 = '30',
  $neutron_region_name             = 'RegionOne',
  $neutron_ovs_bridge              = 'br-int',
  $neutron_extension_sync_interval = '600',
  $vif_plugging_is_fatal           = true,
  $vif_plugging_timeout            = '300',
  $default_floating_pool           = 'nova',
  # DEPRECATED PARAMS
  $neutron_url                     = undef,
  $neutron_url_timeout             = undef,
  $firewall_driver                 = undef,
  $dhcp_domain                     = undef,
) {

  include nova::deps

  if $neutron_url {
    warning('nova::network::neutron::neutron_url is deprecated, nova behaviour will be default to looking up \
    the neutron endpoint in the keystone catalog, please use nova::network::neutron::neutron_endpoint_override to override')
  }

  if $neutron_url_timeout {
    warning('nova::network::neutron::neutron_url_timeout is deprecated, please use neutron_timeout instead.')
  }

  if $firewall_driver {
    warning('nova::network::neutron::firewall_driver is deprecated and will be removed in a future release')
  }


  # TODO(mwhahaha): remove me when tripleo switches to use the metadata version
  # of dhcp_domain
  if $dhcp_domain != undef {
    ensure_resource('nova_config', 'api/dhcp_domain', {
      value => $dhcp_domain
    })
  }

  # TODO(tobias-urdin): Remove these in the T release.
  nova_config {
    'DEFAULT/firewall_driver': value => $firewall_driver;
  }

  nova_config {
    'neutron/url': value => $neutron_url;
  }

  $neutron_timeout_real = pick($neutron_url_timeout, $neutron_timeout)

  nova_config {
    'DEFAULT/vif_plugging_is_fatal':   value => $vif_plugging_is_fatal;
    'DEFAULT/vif_plugging_timeout':    value => $vif_plugging_timeout;
    'neutron/default_floating_pool':   value => $default_floating_pool;
    'neutron/timeout':                 value => $neutron_timeout_real;
    'neutron/project_name':            value => $neutron_project_name;
    'neutron/project_domain_name':     value => $neutron_project_domain_name;
    'neutron/region_name':             value => $neutron_region_name;
    'neutron/username':                value => $neutron_username;
    'neutron/user_domain_name':        value => $neutron_user_domain_name;
    'neutron/password':                value => $neutron_password, secret => true;
    'neutron/auth_url':                value => $neutron_auth_url;
    'neutron/valid_interfaces':        value => $neutron_valid_interfaces;
    'neutron/endpoint_override':       value => $neutron_endpoint_override;
    'neutron/ovs_bridge':              value => $neutron_ovs_bridge;
    'neutron/extension_sync_interval': value => $neutron_extension_sync_interval;
    'neutron/auth_type':               value => $neutron_auth_type;
  }

}
