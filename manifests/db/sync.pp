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
class nova::db::sync(
  $extra_params = undef,
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-db-sync':
    command     => "/usr/bin/nova-manage ${extra_params} db sync",
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['nova::install::end'],
      Anchor['nova::config::end'],
      Anchor['nova::dbsync::begin']
    ],
    notify      => Anchor['nova::dbsync::end'],
  }
}
