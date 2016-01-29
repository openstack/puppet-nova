# == Class: nova::db::mysql_api
#
# Class that configures mysql for the nova_api database.
#
# === Parameters:
#
# [*password*]
#   Password to use for the nova user
#
# [*dbname*]
#   (optional) The name of the database
#   Defaults to 'nova_api'
#
# [*user*]
#   (optional) The mysql user to create
#   Defaults to 'nova_api'
#
# [*host*]
#   (optional) The IP address of the mysql server
#   Defaults to '127.0.0.1'
#
# [*charset*]
#   (optional) The charset to use for the nova database
#   Defaults to 'utf8'
#
# [*collate*]
#   (optional) The collate to use for the nova database
#   Defaults to 'utf8_general_ci'
#
# [*allowed_hosts*]
#   (optional) Additional hosts that are allowed to access this DB
#   Defaults to undef
#
class nova::db::mysql_api(
  $password,
  $dbname        = 'nova_api',
  $user          = 'nova_api',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef,
) {

  include ::nova::deps

  ::openstacklib::db::mysql { 'nova_api':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['nova::db::begin']
  ~> Class['nova::db::mysql_api']
  ~> Anchor['nova::db::end']
}
