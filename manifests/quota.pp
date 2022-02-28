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
# DEPRECATED PARAMETERS
#
# [*reservation_expire*]
#   (optional) Time until reservations expire in seconds
#   Defaults to undef
#
# [*until_refresh*]
#   (optional) Count of reservations until usage is refreshed
#   Defaults to undef
#
# [*max_age*]
#   (optional) Number of seconds between subsequent usage refreshes
#   Defaults to undef
#
# [*floating_ips*]
#   (optional) Number of floating IPs
#   Defaults to undef
#
# [*fixed_ips*]
#   (optional) Number of fixed IPs (this should be at least the number of instances allowed)
#   Defaults to undef
#
# [*security_groups*]
#   (optional) Number of security groups
#   Defaults to undef
#
# [*security_group_rules*]
#   (optional) Number of security group rules
#   Defaults to undef
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
  # DEPRECATED PARAMETERS
  $reservation_expire                = undef,
  $until_refresh                     = undef,
  $max_age                           = undef,
  $floating_ips                      = undef,
  $fixed_ips                         = undef,
  $security_groups                   = undef,
  $security_group_rules              = undef,
) {

  include nova::deps

  [
    'reservation_expire',
    'until_refresh',
    'max_age',
    'floating_ips',
    'fixed_ips',
    'security_groups',
    'security_group_rules',
  ].each |String $removed_opt| {
    if getvar("${removed_opt}") != undef {
      warning("The ${removed_opt} parameter is deprecated and has no effect")
    }
  }

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
  }

  nova_config {
    'quota/reservation_expire':   ensure => absent;
    'quota/until_refresh':        ensure => absent;
    'quota/max_age':              ensure => absent;
    'quota/floating_ips':         ensure => absent;
    'quota/fixed_ips':            ensure => absent;
    'quota/security_groups':      ensure => absent;
    'quota/security_group_rules': ensure => absent;
  }
}
