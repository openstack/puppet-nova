# == Class: nova::db::mysql_placement
#
# Class that configures mysql for the nova_placement database.
#
# This class is deprecated and will be removed in a future release in favour of
# the puppet-placement module.
#
# === Parameters:
#
# DEPRECATED PARAMETERS
#
# [*password*]
#   (Required) Password to use for the nova user
#
# [*dbname*]
#   (Optional) The name of the database
#   Defaults to 'nova_placement'
#
# [*user*]
#   (Optional) The mysql user to create
#   Defaults to 'nova_placement'
#
# [*host*]
#   (Optional) The IP address of the mysql server
#   Defaults to '127.0.0.1'
#
# [*charset*]
#   (Optional) The charset to use for the nova database
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The collate to use for the nova database
#   Defaults to 'utf8_general_ci'
#
# [*allowed_hosts*]
#   (Optional) Additional hosts that are allowed to access this DB
#   Defaults to undef
#
class nova::db::mysql_placement(
  # DEPRECATED PARAMETERS
  $password,
  $dbname        = 'nova_placement',
  $user          = 'nova_placement',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef,
) {

  warning('nova::db::mysql_placement is deprecated and will be removed in a future release')

  include ::nova::deps

  ::openstacklib::db::mysql { 'nova_placement':
    user          => $user,
    password_hash => mysql::password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['nova::db::begin']
  ~> Class['nova::db::mysql_placement']
  ~> Anchor['nova::db::end']
}
