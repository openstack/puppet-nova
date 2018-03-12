#
# Class to execute nova dbsync
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
#   Defaults to 300
#
class nova::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-db-sync':
    command     => "/usr/bin/nova-manage ${extra_params} db sync",
    user        => $::nova::params::nova_user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['nova::install::end'],
      Anchor['nova::config::end'],
      Anchor['nova::db::end'],
      Anchor['nova::dbsync::begin']
    ],
    notify      => Anchor['nova::dbsync::end'],
    tag         => 'openstack-db',
  }
}
