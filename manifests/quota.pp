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
  $instances                         = 10,
  $cores                             = 20,
  $ram                               = 51200,
  $metadata_items                    = 128,
  $injected_files                    = 5,
  $injected_file_content_bytes       = 10240,
  $injected_file_path_length         = 255,
  $key_pairs                         = 100,
  $server_groups                     = 10,
  $server_group_members              = 10,
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
