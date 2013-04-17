#
# == parameters
#  * quantum_admin_password: password for quantum keystone user.
#  * quantum_auth_strategy: auth strategy used by quantum.
#  * quantum_url
#  * quantum_admin_tenant_name
#  * quantum_admin_username
#  * quantum_admin_auth_url
#
class nova::network::quantum (
  $quantum_admin_password,
  $quantum_auth_strategy     = 'keystone',
  $quantum_url               = 'http://127.0.0.1:9696',
  $quantum_admin_tenant_name = 'services',
  $quantum_admin_username    = 'quantum',
  $quantum_admin_auth_url    = 'http://127.0.0.1:35357/v2.0'
) {

  nova_config {
    'DEFAULT/quantum_auth_strategy':     value => $quantum_auth_strategy;
    'DEFAULT/network_api_class':         value => 'nova.network.quantumv2.api.API';
    'DEFAULT/quantum_url':               value => $quantum_url;
    'DEFAULT/quantum_admin_tenant_name': value => $quantum_admin_tenant_name;
    'DEFAULT/quantum_admin_username':    value => $quantum_admin_username;
    'DEFAULT/quantum_admin_password':    value => $quantum_admin_password;
    'DEFAULT/quantum_admin_auth_url':    value => $quantum_admin_auth_url;
  }
}
