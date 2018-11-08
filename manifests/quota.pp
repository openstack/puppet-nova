# == Class: nova::quota
#
# Class for overriding the default quota settings.
#
# === Parameters:
#
# [*instances*]
#   (optional) Number of instances
#   Defaults to 10
#
# [*cores*]
#   (optional) Number of cores
#   Defaults to 20
#
# [*ram*]
#   (optional) Ram in MB
#   Defaults to 51200
#
# [*floating_ips*]
#   (optional) Number of floating IPs
#   Defaults to 10
#
# [*fixed_ips*]
#   (optional) Number of fixed IPs (this should be at least the number of instances allowed)
#   Defaults to -1
#
# [*metadata_items*]
#   (optional) Number of metadata items per instance
#   Defaults to 128
#
# [*injected_files*]
#   (optional) Number of files that can be injected per instance
#   Defaults to 5
#
# [*injected_file_content_bytes*]
#   (optional) Maximum size in bytes of injected files
#   Defaults to 10240
#
# [*injected_file_path_length*]
#   (optional) Maximum size in bytes of injected file path
#   Defaults to 255
#
# [*security_groups*]
#   (optional) Number of security groups
#   Defaults to 10
#
# [*security_group_rules*]
#   (optional) Number of security group rules
#   Defaults to 20
#
# [*key_pairs*]
#   (optional) Number of key pairs
#   Defaults to 100
#
# [*server_groups*]
#   (optional) Number of server groups per project
#   Defaults to 10
#
# [*server_group_members*]
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
#### DEPRECATED PARAMS
#
# [*quota_instances*]
#   (optional) Number of instances
#   Defaults to undef
#
# [*quota_cores*]
#   (optional) Number of cores
#   Defaults to undef
#
# [*quota_ram*]
#   (optional) Ram in MB
#   Defaults to undef
#
# [*quota_floating_ips*]
#   (optional) Number of floating IPs
#   Defaults to undef
#
# [*quota_fixed_ips*]
#   (optional) Number of fixed IPs (this should be at least the number of instances allowed)
#   Defaults to undef
#
# [*quota_metadata_items*]
#   (optional) Number of metadata items per instance
#   Defaults to undef
#
# [*quota_injected_files*]
#   (optional) Number of files that can be injected per instance
#   Defaults to undef
#
# [*quota_injected_file_content_bytes*]
#   (optional) Maximum size in bytes of injected files
#   Defaults to undef
#
# [*quota_injected_file_path_length*]
#   (optional) Maximum size in bytes of injected file path
#   Defaults to undef
#
# [*quota_security_groups*]
#   (optional) Number of security groups
#   Defaults to undef
#
# [*quota_security_group_rules*]
#   (optional) Number of security group rules
#   Defaults to undef
#
# [*quota_key_pairs*]
#   (optional) Number of key pairs
#   Defaults to undef
#
# [*quota_server_groups*]
#   (optional) Number of server groups per project
#   Defaults to undef
#
# [*quota_server_group_members*]
#   (optional) Number of servers per server group
#   Defaults to undef
#
class nova::quota(
  $instances                         = 10,
  $cores                             = 20,
  $ram                               = 51200,
  $floating_ips                      = 10,
  $fixed_ips                         = -1,
  $metadata_items                    = 128,
  $injected_files                    = 5,
  $injected_file_content_bytes       = 10240,
  $injected_file_path_length         = 255,
  $security_groups                   = 10,
  $security_group_rules              = 20,
  $key_pairs                         = 100,
  $server_groups                     = 10,
  $server_group_members              = 10,
  $reservation_expire                = 86400,
  $until_refresh                     = 0,
  $max_age                           = 0,
  # DEPRECATED PARAMS
  $quota_instances                   = undef,
  $quota_cores                       = undef,
  $quota_ram                         = undef,
  $quota_floating_ips                = undef,
  $quota_fixed_ips                   = undef,
  $quota_metadata_items              = undef,
  $quota_injected_files              = undef,
  $quota_injected_file_content_bytes = undef,
  $quota_injected_file_path_length   = undef,
  $quota_security_groups             = undef,
  $quota_security_group_rules        = undef,
  $quota_key_pairs                   = undef,
  $quota_server_groups               = undef,
  $quota_server_group_members        = undef,
) {

  include ::nova::deps

  # TODO(tobias-urdin): Remove these params and picks in the T release.
  $instances_real = pick($quota_instances, $instances)
  $cores_real = pick($quota_cores, $cores)
  $ram_real = pick($quota_ram, $ram)
  $floating_ips_real = pick($quota_floating_ips, $floating_ips)
  $fixed_ips_real = pick($quota_fixed_ips, $fixed_ips)
  $metadata_items_real = pick($quota_metadata_items, $metadata_items)
  $injected_files_real = pick($quota_injected_files, $injected_files)
  $injected_file_content_bytes_real = pick($quota_injected_file_content_bytes, $injected_file_content_bytes)
  $injected_file_path_length_real = pick($quota_injected_file_path_length, $injected_file_path_length)
  $security_groups_real = pick($quota_security_groups, $security_groups)
  $security_group_rules_real = pick($quota_security_group_rules, $security_group_rules)
  $key_pairs_real = pick($quota_key_pairs, $key_pairs)
  $server_groups_real = pick($quota_server_groups, $server_groups)
  $server_group_members_real = pick($quota_server_group_members, $server_group_members)

  nova_config {
    'quota/instances':                   value => $instances_real;
    'quota/cores':                       value => $cores_real;
    'quota/ram':                         value => $ram_real;
    'quota/floating_ips':                value => $floating_ips_real;
    'quota/fixed_ips':                   value => $fixed_ips_real;
    'quota/metadata_items':              value => $metadata_items_real;
    'quota/injected_files':              value => $injected_files_real;
    'quota/injected_file_content_bytes': value => $injected_file_content_bytes_real;
    'quota/injected_file_path_length':   value => $injected_file_path_length_real;
    'quota/security_groups':             value => $security_groups_real;
    'quota/security_group_rules':        value => $security_group_rules_real;
    'quota/key_pairs':                   value => $key_pairs_real;
    'quota/server_groups':               value => $server_groups_real;
    'quota/server_group_members':        value => $server_group_members_real;
    'quota/reservation_expire':          value => $reservation_expire;
    'quota/until_refresh':               value => $until_refresh;
    'quota/max_age':                     value => $max_age;
  }
}
