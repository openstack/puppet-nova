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
#   (Optional) Path to the novajoin policy.json file
#   Defaults to /etc/novajoin/policy.json
#
class nova::metadata::novajoin::policy (
  $policies    = {},
  $policy_path = '/etc/novajoin/policy.json',
) {

  validate_legacy(Hash, 'validate_hash', $policies)

  $policy_defaults = {
    file_path  => $policy_path,
    file_user  => 'root',
  }

  create_resources('openstacklib::policy::base', $policies, $policy_defaults)

  oslo::policy { 'novajoin_config': policy_file => $policy_path }

}
