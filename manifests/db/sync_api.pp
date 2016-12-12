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
#   with nova-manage. This flag will be set to true in Ocata when the cell v2
#   setup is mandatory.
#   Defaults to false.
#
class nova::db::sync_api(
  $extra_params = undef,
  $cellv2_setup = false,
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-db-sync-api':
    command     => "/usr/bin/nova-manage ${extra_params} api_db sync",
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
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
