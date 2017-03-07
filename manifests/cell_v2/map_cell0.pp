# == Class: nova::cell_v2::map_cell0
#
# Class to execute nova cell_v2 map_cell0
#
# === Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to pass
#   to the nova-manage command. These will be inserted in
#   the command line between 'nova-manage' and 'cell_v2'.
#   Defaults to ''
#
#
class nova::cell_v2::map_cell0 (
  $extra_params = '',
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-cell_v2-map_cell0':
    path        => ['/bin', '/usr/bin'],
    command     => "nova-manage ${extra_params} cell_v2 map_cell0",
    user        => $::nova::params::nova_user,
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => Anchor['nova::cell_v2::begin'],
    notify      => Anchor['nova::cell_v2::end'],
  }
}
