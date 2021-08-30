# == Class: nova::metadata::novajoin::policy
#
# Configure the nova policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for novajoin
#   Example :
#     {
#       'novajoin-compute_service_user' => {
#         'key' => 'compute_service_user',
#         'value' => 'role:admin'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the novajoin policy.yaml file
#   Defaults to /etc/novajoin/policy.yaml
#
# [*purge_config*]
#   (optional) Whether to set only the specified policy rules in the policy
#    file.
#    Defaults to false.
#
class nova::metadata::novajoin::policy (
  $policies     = {},
  $policy_path  = '/etc/novajoin/policy.yaml',
  $purge_config = false,
) {

  validate_legacy(Hash, 'validate_hash', $policies)

  openstacklib::policy { $policy_path:
    policies     => $policies,
    policy_path  => $policy_path,
    file_user    => 'root',
    file_format  => 'yaml',
    purge_config => $purge_config,
  }

  oslo::policy { 'novajoin_config': policy_file => $policy_path }

}
