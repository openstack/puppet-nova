# == Class: nova::db::postgresql_api
#
# Class that configures postgresql for the nova_api database.
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'nova_api'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'nova_api'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class nova::db::postgresql_api(
  $password,
  $dbname     = 'nova_api',
  $user       = 'nova_api',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::nova::deps

  ::openstacklib::db::postgresql { 'nova_api':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['nova::db::begin']
  ~> Class['nova::db::postgresql_api']
  ~> Anchor['nova::db::end']
}
