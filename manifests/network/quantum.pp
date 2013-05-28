# == Class: nova::network::quantum
#
# Configures Nova network to use Quantum.
#
# === Parameters
#
# [*quantum_admin_password*]
#   (required) Password for connecting to Quantum network services in
#   admin context through the OpenStack Identity service.
#
# [*quantum_auth_strategy*]
#   (optional) Should be kept as default 'keystone' for all production deployments.
#
# [*quantum_url*]
#   (optional) URL for connecting to the Quantum networking service.
#   Defaults to 'http://127.0.0.1:9696'.
#
# [*quantum_admin_tenant_name*]
#   (optional) Tenant name for connecting to Quantum network services in
#   admin context through the OpenStack Identity service. Defaults to 'services'.
#
# [*quantum_region_name*]
#   (optional) Region name for connecting to quantum in admin context
#   through the OpenStack Identity service. Defaults to 'RegionOne'.
#
# [*quantum_admin_username*]
#   (optional) Username for connecting to Quantum network services in admin context
#   through the OpenStack Identity service. Defaults to 'quantum'.
#
# [*quantum_admin_auth_url*]
#   (optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:35357/v2.0'
#
# [*security_group_api*]
#   (optional) The full class name of the security API class.
#   Defaults to 'quantum' which configures Nova to use Quantum for
#   security groups. Set to 'nova' to use standard Nova security groups.
#
# [*firewall_driver*]
#   (optional) Firewall driver.
#   Defaults to nova.virt.firewall.NoopFirewallDriver. This prevents Nova
#   from maintaining a firewall so it does not interfere with Quantum's.
#   Set to 'nova.virt.firewall.IptablesFirewallDriver'
#   to re-enable the Nova firewall.
#
class nova::network::quantum (
  $quantum_admin_password,
  $quantum_auth_strategy     = 'keystone',
  $quantum_url               = 'http://127.0.0.1:9696',
  $quantum_admin_tenant_name = 'services',
  $quantum_region_name       = 'RegionOne',
  $quantum_admin_username    = 'quantum',
  $quantum_admin_auth_url    = 'http://127.0.0.1:35357/v2.0',
  $security_group_api        = 'quantum',
  $firewall_driver           = 'nova.virt.firewall.NoopFirewallDriver'
) {

  nova_config {
    'DEFAULT/quantum_auth_strategy':     value => $quantum_auth_strategy;
    'DEFAULT/network_api_class':         value => 'nova.network.quantumv2.api.API';
    'DEFAULT/quantum_url':               value => $quantum_url;
    'DEFAULT/quantum_admin_tenant_name': value => $quantum_admin_tenant_name;
    'DEFAULT/quantum_region_name':       value => $quantum_region_name;
    'DEFAULT/quantum_admin_username':    value => $quantum_admin_username;
    'DEFAULT/quantum_admin_password':    value => $quantum_admin_password, secret => true;
    'DEFAULT/quantum_admin_auth_url':    value => $quantum_admin_auth_url;
    'DEFAULT/security_group_api':        value => $security_group_api;
    'DEFAULT/firewall_driver':           value => $firewall_driver;
  }

}
