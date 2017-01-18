# == Class: nova::db::mysql
#
# Class that configures mysql for nova
#
# === Parameters:
#
# [*password*]
#   Password to use for the nova user
#
# [*dbname*]
#   (optional) The name of the database
#   Defaults to 'nova'
#
# [*user*]
#   (optional) The mysql user to create
#   Defaults to 'nova'
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
# [*setup_cell0*]
#   (optional) Setup a cell0 for the cell_v2 functionality. This option will
#   be set to true by default in Ocata when the cell v2 setup is mandatory.
#   Defaults to false
#

class nova::db::mysql(
  $password,
  $dbname        = 'nova',
  $user          = 'nova',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef,
  $setup_cell0   = true,
) {

  include ::nova::deps

  $setup_cell0_real = pick($::nova::db::mysql_api::setup_cell0, $setup_cell0)

  ::openstacklib::db::mysql { 'nova':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  if $setup_cell0_real {
    # need for cell_v2
    ::openstacklib::db::mysql { 'nova_cell0':
      user          => $user,
      password_hash => mysql_password($password),
      dbname        => "${dbname}_cell0",
      host          => $host,
      charset       => $charset,
      collate       => $collate,
      allowed_hosts => $allowed_hosts,
      create_user   => false,
    }
  }

  Anchor['nova::db::begin']
  ~> Class['nova::db::mysql']
  ~> Anchor['nova::db::end']
}
