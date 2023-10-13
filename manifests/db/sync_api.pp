#
# Class to execute nova api_db sync
#
# ==Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the nova-manage db sync command. These will be inserted in
#   the command line between 'nova-manage' and 'db sync'.
#   Defaults to undef
#
# [*cellv2_setup*]
#   (Optional) This flag toggles if we preform a minimal cell_v2 setup of a
#   a single cell.
#   NOTE: 'nova-manage cell_v2 discover_hosts' must be
#   run after any nova-compute hosts have been deployed.
#   This flag will be set to true in Ocata when the cell v2 setup is mandatory.
#   Defaults to false.
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300.
#
class nova::db::sync_api(
  $extra_params         = undef,
  Boolean $cellv2_setup = false,
  $db_sync_timeout      = 300,
) {

  include nova::deps
  include nova::params

  exec { 'nova-db-sync-api':
    command     => "/usr/bin/nova-manage ${extra_params} api_db sync",
    user        => $::nova::params::user,
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
    tag         => 'openstack-db',
  }

  if $cellv2_setup {
    include nova::cell_v2::simple_setup
  }
}
