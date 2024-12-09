# == Class: nova::quota
#
# Class for overriding the default quota settings.
#
# === Parameters:
#
# [*driver*]
#   (optional) Driver to use for quota checks.
#   Defaults to $facts['os_service_default']
#
# [*instances*]
#   (optional) Number of instances
#   Defaults to $facts['os_service_default']
#
# [*cores*]
#   (optional) Number of cores
#   Defaults to $facts['os_service_default']
#
# [*ram*]
#   (optional) Ram in MB
#   Defaults to $facts['os_service_default']
#
# [*metadata_items*]
#   (optional) Number of metadata items per instance
#   Defaults to $facts['os_service_default']
#
# [*injected_files*]
#   (optional) Number of files that can be injected per instance
#   Defaults to $facts['os_service_default']
#
# [*injected_file_content_bytes*]
#   (optional) Maximum size in bytes of injected files
#   Defaults to $facts['os_service_default']
#
# [*injected_file_path_length*]
#   (optional) Maximum size in bytes of injected file path
#   Defaults to $facts['os_service_default']
#
# [*key_pairs*]
#   (optional) Number of key pairs
#   Defaults to $facts['os_service_default']
#
# [*server_groups*]
#   (optional) Number of server groups per project
#   Defaults to $facts['os_service_default']
#
# [*server_group_members*]
#   (optional) Number of servers per server group
#   Defaults to $facts['os_service_default']
#
# [*recheck_quota*]
#   (optional) Recheck quota after resource creation to prevent allowing
#   quota to be exceeded.
#   Defaults to $facts['os_service_default']
#
# [*count_usage_from_placement*]
#   (optional) Enable the counting of quota usage from the placement service.
#   Defaults to $facts['os_service_default']
#
# [*unified_limits_resource_strategy*]
#   (optional) Specify the semantics of the ``unified_limits_resource_list``.
#   Defaults to $facts['os_service_default']
#
# [*unified_limits_resource_list*]
#   (optional) Specify a list of resources to require or ignore registered
#   limits.
#   Defaults to $facts['os_service_default']
#
class nova::quota(
  $driver                           = $facts['os_service_default'],
  $instances                        = $facts['os_service_default'],
  $cores                            = $facts['os_service_default'],
  $ram                              = $facts['os_service_default'],
  $metadata_items                   = $facts['os_service_default'],
  $injected_files                   = $facts['os_service_default'],
  $injected_file_content_bytes      = $facts['os_service_default'],
  $injected_file_path_length        = $facts['os_service_default'],
  $key_pairs                        = $facts['os_service_default'],
  $server_groups                    = $facts['os_service_default'],
  $server_group_members             = $facts['os_service_default'],
  $recheck_quota                    = $facts['os_service_default'],
  $count_usage_from_placement       = $facts['os_service_default'],
  $unified_limits_resource_strategy = $facts['os_service_default'],
  $unified_limits_resource_list     = $facts['os_service_default'],
) {

  include nova::deps

  nova_config {
    'quota/driver':                           value => $driver;
    'quota/instances':                        value => $instances;
    'quota/cores':                            value => $cores;
    'quota/ram':                              value => $ram;
    'quota/metadata_items':                   value => $metadata_items;
    'quota/injected_files':                   value => $injected_files;
    'quota/injected_file_content_bytes':      value => $injected_file_content_bytes;
    'quota/injected_file_path_length':        value => $injected_file_path_length;
    'quota/key_pairs':                        value => $key_pairs;
    'quota/server_groups':                    value => $server_groups;
    'quota/server_group_members':             value => $server_group_members;
    'quota/recheck_quota':                    value => $recheck_quota;
    'quota/count_usage_from_placement':       value => $count_usage_from_placement;
    'quota/unified_limits_resource_strategy': value => $unified_limits_resource_strategy;
    'quota/unified_limits_resource_list':     value => join(any2array($unified_limits_resource_list), ',');
  }
}
