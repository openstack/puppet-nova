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
# [*neutron_auth_plugin*]
#   Name of the plugin to load (string value)
#   Defaults to 'password'
#
# [*neutron_url*]
#   (optional) URL for connecting to the Neutron networking service.
#   Defaults to 'http://127.0.0.1:9696'
#
# [*neutron_url_timeout*]
#   (optional) Timeout value for connecting to neutron in seconds.
#   Defaults to '30'
#
# [*neutron_tenant_name*]
#   (optional) Tenant name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*neutron_default_tenant_id*]
#   (optional) Default tenant id when creating neutron networks
#   Defaults to 'default'
#
# [*neutron_region_name*]
#   (optional) Region name for connecting to neutron in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*neutron_username*]
#   (optional) Username for connecting to Neutron network services in admin context
#   through the OpenStack Identity service.
#   Defaults to 'neutron'
#
# [*neutron_ovs_bridge*]
#   (optional) Name of Integration Bridge used by Open vSwitch
#   Defaults to 'br-int'
#
# [*neutron_extension_sync_interval*]
#   (optional) Number of seconds before querying neutron for extensions
#   Defaults to '600'
#
# [*neutron_ca_certificates_file*]
#   (optional) Location of ca certicates file to use for neutronclient requests.
#   Defaults to 'None'
#
# [*neutron_auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:35357'
#
# [*network_api_class*]
#   (optional) The full class name of the network API class.
#   The default configures Nova to use Neutron for the network API.
#   Defaults to 'nova.network.neutronv2.api.API'
#
# [*security_group_api*]
#   (optional) The full class name of the security API class.
#   The default configures Nova to use Neutron for security groups.
#   Set to 'nova' to use standard Nova security groups.
#   Defaults to 'neutron'
#
# [*firewall_driver*]
#   (optional) Firewall driver.
#   This prevents nova from maintaining a firewall so it does not interfere
#   with Neutron's. Set to 'nova.virt.firewall.IptablesFirewallDriver'
#   to re-enable the Nova firewall.
#   Defaults to 'nova.virt.firewall.NoopFirewallDriver'
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
# [*dhcp_domain*]
#   (optional) domain to use for building the hostnames
#   Defaults to 'novalocal'
#
# DEPRECATED PARAMETERS
# [*neutron_auth_strategy*]
#   (optional) DEPRECATED.
#
# [*neutron_admin_password*]
#   DEPRECATED. Password for connecting to Neutron network services
#   in admin context through the OpenStack Identity service.
#   Use neutron_password instead.
#
# [*neutron_admin_tenant_name*]
#   (optional) DEPRECATED. Tenant name for connecting to Neutron network
#   services in admin context through the OpenStack Identity service.
#   Use neutron_tenant_name instead.
#
# [*neutron_admin_username*]
#   (optional) DEPRECATED. Username for connecting to Neutron network services
#   in admin context through the OpenStack Identity service.
#   Use neutron_username instead.
#
# [*neutron_admin_auth_url*]
#   (optional) DEPRECATED. Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Use neutron_auth_url instead.
#
class nova::network::neutron (
  $neutron_password                = false,
  $neutron_auth_plugin             = 'password',
  $neutron_tenant_name             = 'services',
  $neutron_username                = 'neutron',
  $neutron_auth_url                = 'http://127.0.0.1:35357',
  $neutron_url                     = 'http://127.0.0.1:9696',
  $neutron_url_timeout             = '30',
  $neutron_default_tenant_id       = 'default',
  $neutron_region_name             = 'RegionOne',
  $neutron_ovs_bridge              = 'br-int',
  $neutron_extension_sync_interval = '600',
  $neutron_ca_certificates_file    = undef,
  $network_api_class               = 'nova.network.neutronv2.api.API',
  $security_group_api              = 'neutron',
  $firewall_driver                 = 'nova.virt.firewall.NoopFirewallDriver',
  $vif_plugging_is_fatal           = true,
  $vif_plugging_timeout            = '300',
  $dhcp_domain                     = 'novalocal',
  # DEPRECATED PARAMETERS
  $neutron_admin_password          = false,
  $neutron_auth_strategy           = undef,
  $neutron_admin_tenant_name       = undef,
  $neutron_admin_username          = undef,
  $neutron_admin_auth_url          = undef,
) {

  include ::nova::deps

  # neutron_admin params removed in Mitaka
  if $neutron_password {
    $neutron_password_real = $neutron_password
  } else {
    if $neutron_admin_password {
      warning('neutron_admin_password is deprecated. Use neutron_password')
      $neutron_password_real = $neutron_admin_password
    } else {
      fail('neutron_password is required')
    }
  }

  if $neutron_admin_tenant_name {
    warning('neutron_admin_tenant_name is deprecated. Use neutron_tenant_name')
    $neutron_tenant_name_real = $neutron_admin_tenant_name
  } else {
    $neutron_tenant_name_real = $neutron_tenant_name
  }

  if $neutron_admin_username {
    warning('neutron_admin_username is deprecated. Use neutron_username')
    $neutron_username_real = $neutron_admin_username
  } else {
    $neutron_username_real = $neutron_username
  }

  if $neutron_admin_auth_url {
    warning('neutron_admin_auth_url is deprecated. Use neutron_auth_url')
    $neutron_auth_url_real = $neutron_admin_auth_url
  } else {
    $neutron_auth_url_real = $neutron_auth_url
  }

  # neutron_auth_strategy removed in Mitaka
  if $neutron_auth_strategy {
    warning('neutron_auth_strategy is deprecated')
  }
  nova_config {
    'neutron/auth_strategy': ensure => absent;
  }

  nova_config {
    'DEFAULT/dhcp_domain':             value => $dhcp_domain;
    'DEFAULT/firewall_driver':         value => $firewall_driver;
    'DEFAULT/network_api_class':       value => $network_api_class;
    'DEFAULT/security_group_api':      value => $security_group_api;
    'DEFAULT/vif_plugging_is_fatal':   value => $vif_plugging_is_fatal;
    'DEFAULT/vif_plugging_timeout':    value => $vif_plugging_timeout;
    'neutron/url':                     value => $neutron_url;
    'neutron/timeout':                 value => $neutron_url_timeout;
    'neutron/tenant_name':             value => $neutron_tenant_name_real;
    'neutron/default_tenant_id':       value => $neutron_default_tenant_id;
    'neutron/region_name':             value => $neutron_region_name;
    'neutron/username':                value => $neutron_username_real;
    'neutron/password':                value => $neutron_password_real, secret => true;
    'neutron/auth_url':                value => $neutron_auth_url_real;
    'neutron/ovs_bridge':              value => $neutron_ovs_bridge;
    'neutron/extension_sync_interval': value => $neutron_extension_sync_interval;
    'neutron/auth_plugin':             value => $neutron_auth_plugin;
  }

  if ! $neutron_ca_certificates_file {
    nova_config { 'neutron/ca_certificates_file': ensure => absent }
  } else {
    nova_config { 'neutron/ca_certificates_file': value => $neutron_ca_certificates_file }
  }

}
