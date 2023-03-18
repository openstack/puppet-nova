# == Class: nova::db::postgresql
#
# Class that configures postgresql for nova
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'nova'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'nova'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
# [*setup_cell0*]
#   (Optional) Setup a cell0 for the cell_v2 functionality. This option will
#   be set to true by default in Ocata when the cell v2 setup is mandatory.
#   Defaults to true
#
class nova::db::postgresql(
  $password,
  $dbname      = 'nova',
  $user        = 'nova',
  $encoding    = undef,
  $privileges  = 'ALL',
  $setup_cell0 = true,
) {

  include nova::deps

  validate_legacy(Boolean, 'validate_bool', $setup_cell0)

  ::openstacklib::db::postgresql { 'nova':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  if $setup_cell0 {
    # need for cell_v2
    ::openstacklib::db::postgresql { 'nova_cell0':
      password   => $password,
      dbname     => "${dbname}_cell0",
      user       => $user,
      encoding   => $encoding,
      privileges => $privileges,
    }
  }

  Anchor['nova::db::begin']
  ~> Class['nova::db::postgresql']
  ~> Anchor['nova::db::end']
}
