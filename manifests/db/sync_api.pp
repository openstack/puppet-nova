#
# Class to execute nova api_db sync
#
# ==Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the nova-manage db sync command. These will be inserted in
#   the command line between 'nova-manage' and 'db sync'.
#   Defaults to undef
#
# [*cellv2_setup*]
#   (optional) This flag toggles if we run the cell_v2 simple_cell_setup action
#   with nova-manage.
#   Defaults to true.
#
# [*db_sync_timeout*]
#   (optional) Timeout for the execution of the db_sync
#   Defaults to 300.
#
class nova::db::sync_api(
  $extra_params    = undef,
  $db_sync_timeout = 300,
  $cellv2_setup    = true,
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-db-sync-api':
    command     => "/usr/bin/nova-manage ${extra_params} api_db sync",
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['nova::install::end'],
      Anchor['nova::config::end'],
      Anchor['nova::dbsync_api::begin']
    ],
    notify      => Anchor['nova::dbsync_api::end'],
  }

  if $cellv2_setup {
    include ::nova::db::sync_cell_v2
  }
}
