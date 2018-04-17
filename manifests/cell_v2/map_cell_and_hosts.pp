# == Class: nova::cell_v2::map_cell_and_hosts
#
#  Class to run the map_cell_and_hosts action for cell v2
#
# === Parameters
#
# [*extra_params*]
#  (String) Extra parameters to pass to the nova-manage commands.
#  Defaults to ''.
#
class nova::cell_v2::map_cell_and_hosts (
  $extra_params = '',
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-cell_v2-map_cell_and_hosts':
    path        => ['/bin', '/usr/bin'],
    command     => "nova-manage ${extra_params} cell_v2 map_cell_and_hosts",
    user        => $::nova::params::nova_user,
    refreshonly => true,
  }
}
