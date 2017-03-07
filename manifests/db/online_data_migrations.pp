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
# [*db_sync_timeout*]
#   (optional) Timeout for the execution of the db_sync
#   Defaults to 300.
#
class nova::db::online_data_migrations(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-db-online-data-migrations':
    command     => "/usr/bin/nova-manage ${extra_params} db online_data_migrations",
    user        => $::nova::params::nova_user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['nova::install::end'],
      Anchor['nova::config::end'],
      Anchor['nova::dbsync_api::end'],
      Anchor['nova::db_online_data_migrations::begin']
    ],
    notify      => Anchor['nova::db_online_data_migrations::end'],
  }
}
