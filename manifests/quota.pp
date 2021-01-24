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
  # DEPRECATED PARAMETERS
  $reservation_expire                = undef,
  $until_refresh                     = undef,
  $max_age                           = undef,
) {

  include nova::deps

  [
    'reservation_expire',
    'until_refresh',
    'max_age',
  ].each |String $removed_opt| {
    if getvar("${removed_opt}") != undef {
      warning("The ${removed_opt} parameter is deprecated and has no effect")
    }
  }

  nova_config {
    'quota/instances':                   value => $instances;
    'quota/cores':                       value => $cores;
    'quota/ram':                         value => $ram;
    'quota/floating_ips':                value => $floating_ips;
    'quota/fixed_ips':                   value => $fixed_ips;
    'quota/metadata_items':              value => $metadata_items;
    'quota/injected_files':              value => $injected_files;
    'quota/injected_file_content_bytes': value => $injected_file_content_bytes;
    'quota/injected_file_path_length':   value => $injected_file_path_length;
    'quota/security_groups':             value => $security_groups;
    'quota/security_group_rules':        value => $security_group_rules;
    'quota/key_pairs':                   value => $key_pairs;
    'quota/server_groups':               value => $server_groups;
    'quota/server_group_members':        value => $server_group_members;
  }

  nova_config {
    'quota/reservation_expire': ensure => absent;
    'quota/until_refresh':      ensure => absent;
    'quota/max_age':            ensure => absent;
  }
}
