# == Class: nova::quota
#
# Class for overriding the default quota settings.
#
# === Parameters:
#
# [*driver*]
#   (optional) Driver to use for quota checks.
#   Defaults to $::os_service_default
#
# [*instances*]
#   (optional) Number of instances
#   Defaults to $::os_service_default
#
# [*cores*]
#   (optional) Number of cores
#   Defaults to $::os_service_default
#
# [*ram*]
#   (optional) Ram in MB
#   Defaults to $::os_service_default
#
# [*metadata_items*]
#   (optional) Number of metadata items per instance
#   Defaults to $::os_service_default
#
# [*injected_files*]
#   (optional) Number of files that can be injected per instance
#   Defaults to $::os_service_default
#
# [*injected_file_content_bytes*]
#   (optional) Maximum size in bytes of injected files
#   Defaults to $::os_service_default
#
# [*injected_file_path_length*]
#   (optional) Maximum size in bytes of injected file path
#   Defaults to $::os_service_default
#
# [*key_pairs*]
#   (optional) Number of key pairs
#   Defaults to $::os_service_default
#
# [*server_groups*]
#   (optional) Number of server groups per project
#   Defaults to $::os_service_default
#
# [*server_group_members*]
#   (optional) Number of servers per server group
#   Defaults to $::os_service_default
#
# [*recheck_quota*]
#   (optional) Recheck quota after resource creation to prevent allowing
#   quota to be exceeded.
#   Defaults to $::os_service_default
#
# [*count_usage_from_placement*]
#   (optional Enable the counting of quota usage from the placement service.
#   Defaults to $::os_service_default
#
class nova::quota(
  $driver                            = $::os_service_default,
  $instances                         = $::os_service_default,
  $cores                             = $::os_service_default,
  $ram                               = $::os_service_default,
  $metadata_items                    = $::os_service_default,
  $injected_files                    = $::os_service_default,
  $injected_file_content_bytes       = $::os_service_default,
  $injected_file_path_length         = $::os_service_default,
  $key_pairs                         = $::os_service_default,
  $server_groups                     = $::os_service_default,
  $server_group_members              = $::os_service_default,
  $recheck_quota                     = $::os_service_default,
  $count_usage_from_placement        = $::os_service_default,
) {

  include nova::deps

  nova_config {
    'quota/driver':                      value => $driver;
    'quota/instances':                   value => $instances;
    'quota/cores':                       value => $cores;
    'quota/ram':                         value => $ram;
    'quota/metadata_items':              value => $metadata_items;
    'quota/injected_files':              value => $injected_files;
    'quota/injected_file_content_bytes': value => $injected_file_content_bytes;
    'quota/injected_file_path_length':   value => $injected_file_path_length;
    'quota/key_pairs':                   value => $key_pairs;
    'quota/server_groups':               value => $server_groups;
    'quota/server_group_members':        value => $server_group_members;
    'quota/recheck_quota':               value => $recheck_quota;
    'quota/count_usage_from_placement':  value => $count_usage_from_placement;
  }
}
