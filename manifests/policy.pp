# == Class: nova::policy
#
# Configure the nova policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for nova
#   Example :
#     {
#       'nova-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'nova-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.yaml file
#   Defaults to /etc/nova/policy.yaml
#
class nova::policy (
  $policies    = {},
  $policy_path = '/etc/nova/policy.yaml',
) {

  include nova::deps
  include nova::params

  validate_legacy(Hash, 'validate_hash', $policies)

  $policy_defaults = {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::nova::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies, $policy_defaults)

  oslo::policy { 'nova_config': policy_file => $policy_path }

}
