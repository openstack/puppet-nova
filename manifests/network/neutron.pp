# == Class: nova::network::neutron
#
# Configures Nova network to use Neutron.
#
# === Parameters
#
# [*neutron_admin_password*]
#   (required) Password for connecting to Neutron network services in
#   admin context through the OpenStack Identity service.
#
# [*neutron_auth_strategy*]
#   (optional) Should be kept as default 'keystone' for all production deployments.
#
# [*neutron_url*]
#   (optional) URL for connecting to the Neutron networking service.
#   Defaults to 'http://127.0.0.1:9696'.
#
# [*neutron_admin_tenant_name*]
#   (optional) Tenant name for connecting to Neutron network services in
#   admin context through the OpenStack Identity service. Defaults to 'services'.
#
# [*neutron_region_name*]
#   (optional) Region name for connecting to neutron in admin context
#   through the OpenStack Identity service. Defaults to 'RegionOne'.
#
# [*neutron_admin_username*]
#   (optional) Username for connecting to Neutron network services in admin context
#   through the OpenStack Identity service. Defaults to 'neutron'.
#
# [*neutron_admin_auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:35357/v2.0'
#
# [*security_group_api*]
#   (optional) The full class name of the security API class.
#   Defaults to 'neutron' which configures Nova to use Neutron for
#   security groups. Set to 'nova' to use standard Nova security groups.
#
# [*firewall_driver*]
#   (optional) Firewall driver.
#   Defaults to nova.virt.firewall.NoopFirewallDriver. This prevents Nova
#   from maintaining a firewall so it does not interfere with Neutron's.
#   Set to 'nova.virt.firewall.IptablesFirewallDriver'
#   to re-enable the Nova firewall.
#
class nova::network::neutron (
  $neutron_admin_password,
  $neutron_auth_strategy     = 'keystone',
  $neutron_url               = 'http://127.0.0.1:9696',
  $neutron_admin_tenant_name = 'services',
  $neutron_region_name       = 'RegionOne',
  $neutron_admin_username    = 'neutron',
  $neutron_admin_auth_url    = 'http://127.0.0.1:35357/v2.0',
  $security_group_api        = 'neutron',
  $firewall_driver           = 'nova.virt.firewall.NoopFirewallDriver'
) {

  nova_config {
    'DEFAULT/neutron_auth_strategy':     value => $neutron_auth_strategy;
    'DEFAULT/network_api_class':         value => 'nova.network.neutronv2.api.API';
    'DEFAULT/neutron_url':               value => $neutron_url;
    'DEFAULT/neutron_admin_tenant_name': value => $neutron_admin_tenant_name;
    'DEFAULT/neutron_region_name':       value => $neutron_region_name;
    'DEFAULT/neutron_admin_username':    value => $neutron_admin_username;
    'DEFAULT/neutron_admin_password':    value => $neutron_admin_password, secret => true;
    'DEFAULT/neutron_admin_auth_url':    value => $neutron_admin_auth_url;
    'DEFAULT/security_group_api':        value => $security_group_api;
    'DEFAULT/firewall_driver':           value => $firewall_driver;
  }

}
