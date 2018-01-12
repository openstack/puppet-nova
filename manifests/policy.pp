# == Class: nova::policy
#
# Configure the nova policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for nova
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
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/nova/policy.json
#
class nova::policy (
  $policies    = {},
  $policy_path = '/etc/nova/policy.json',
) {

  include ::nova::deps
  include ::nova::params

  validate_hash($policies)

  $policy_defaults = {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::nova::params::group,
  }

  create_resources('openstacklib::policy::base', $policies, $policy_defaults)

  oslo::policy { 'nova_config': policy_file => $policy_path }

}
