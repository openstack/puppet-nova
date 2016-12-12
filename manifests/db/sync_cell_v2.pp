#
# Class to execute nova cell_v2 setup
#
# ==Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the nova-manage db sync command. These will be inserted in
#   the command line between 'nova-manage' and 'db sync'.
#   Defaults to ''
#
# [*transport_url*]
#   (optional) This is the transport url to use for the simple cell setup.
#   By default the command should look for the DEFAULT/transport_url from
#   the nova configuration. If not available, you need to provide the
#   transport url via the parameters. Prior to Ocata, the transport-url
#   was a required parameter.
#   Defaults to undef.
#
class nova::db::sync_cell_v2 (
  $extra_params  = '',
  $transport_url = undef,
) {

  include ::nova::deps

  if $transport_url {
    $transport_url_real = "--transport-url=${transport_url}"
  } else {
    $transport_url_real = ''
  }
  exec { 'nova-cell_v2-simple-cell-setup':
    command     => "/usr/bin/nova-manage ${extra_params} cell_v2 simple_cell_setup ${transport_url_real}",
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['nova::install::end'],
      Anchor['nova::config::end'],
      Anchor['nova::dbsync_api::end'],
      Anchor['nova::cell_v2::begin']
    ],
    notify      => Anchor['nova::cell_v2::end'],
  }
}
