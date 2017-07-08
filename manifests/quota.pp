# == Class: nova::quota
#
# Class for overriding the default quota settings.
#
# === Parameters:
#
# [*quota_instances*]
#   (optional) Number of instances
#   Defaults to 10
#
# [*quota_cores*]
#   (optional) Number of cores
#   Defaults to 20
#
# [*quota_ram*]
#   (optional) Ram in MB
#   Defaults to 51200
#
# [*quota_floating_ips*]
#   (optional) Number of floating IPs
#   Defaults to 10
#
# [*quota_fixed_ips*]
#   (optional) Number of fixed IPs (this should be at least the number of instances allowed)
#   Defaults to -1
#
# [*quota_metadata_items*]
#   (optional) Number of metadata items per instance
#   Defaults to 128
#
# [*quota_injected_files*]
#   (optional) Number of files that can be injected per instance
#   Defaults to 5
#
# [*quota_injected_file_content_bytes*]
#   (optional) Maximum size in bytes of injected files
#   Defaults to 10240
#
#
# [*quota_injected_file_path_length*]
#   (optional) Maximum size in bytes of injected file path
#   Defaults to 255
#
# [*quota_security_groups*]
#   (optional) Number of security groups
#   Defaults to 10
#
# [*quota_security_group_rules*]
#   (optional) Number of security group rules
#   Defaults to 20
#
# [*quota_key_pairs*]
#   (optional) Number of key pairs
#   Defaults to 100
#
# [*quota_server_groups*]
#   (optional) Number of server groups per project
#   Defaults to 10
#
# [*quota_server_group_members*]
#   (optional) Number of servers per server group
#   Defaults to 10
#
# [*reservation_expire*]
#   (optional) Time until reservations expire in seconds
#   Defaults to 86400
#
# [*until_refresh*]
#   (optional) Count of reservations until usage is refreshed
#   Defaults to 0
#
# [*max_age*]
#   (optional) Number of seconds between subsequent usage refreshes
#   Defaults to 0
#
#
class nova::quota(
  $quota_instances = 10,
  $quota_cores = 20,
  $quota_ram = 51200,
  $quota_floating_ips = 10,
  $quota_fixed_ips = -1,
  $quota_metadata_items = 128,
  $quota_injected_files = 5,
  $quota_injected_file_content_bytes = 10240,
  $quota_injected_file_path_length = 255,
  $quota_security_groups = 10,
  $quota_security_group_rules = 20,
  $quota_key_pairs = 100,
  $quota_server_groups = 10,
  $quota_server_group_members = 10,
  $reservation_expire = 86400,
  $until_refresh = 0,
  $max_age = 0,
) {
  include ::nova::deps


  nova_config {
    'DEFAULT/quota_instances':                   value => $quota_instances;
    'DEFAULT/quota_cores':                       value => $quota_cores;
    'DEFAULT/quota_ram':                         value => $quota_ram;
    'DEFAULT/quota_floating_ips':                value => $quota_floating_ips;
    'DEFAULT/quota_fixed_ips':                   value => $quota_fixed_ips;
    'DEFAULT/quota_metadata_items':              value => $quota_metadata_items;
    'DEFAULT/quota_injected_files':              value => $quota_injected_files;
    'DEFAULT/quota_injected_file_content_bytes': value => $quota_injected_file_content_bytes;
    'DEFAULT/quota_injected_file_path_length':   value => $quota_injected_file_path_length;
    'DEFAULT/quota_security_groups':             value => $quota_security_groups;
    'DEFAULT/quota_security_group_rules':        value => $quota_security_group_rules;
    'DEFAULT/quota_key_pairs':                   value => $quota_key_pairs;
    'DEFAULT/quota_server_groups':               value => $quota_server_groups;
    'DEFAULT/quota_server_group_members':        value => $quota_server_group_members;
    'DEFAULT/reservation_expire':                value => $reservation_expire;
    'DEFAULT/until_refresh':                     value => $until_refresh;
    'DEFAULT/max_age':                           value => $max_age;
  }

}
