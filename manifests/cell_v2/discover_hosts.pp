# == Class: nova::cell_v2::discover_hosts
#
#  Class to run the discover_hosts action for cell v2
#
# === Parameters
#
# [*extra_params*]
#  (String) Extra parameters to pass to the nova-manage commands.
#  Defaults to ''.
#
class nova::cell_v2::discover_hosts (
  $extra_params = '',
) {

  include ::nova::deps
  include ::nova::params

  exec { 'nova-cell_v2-discover_hosts':
    path        => ['/bin', '/usr/bin'],
    command     => "nova-manage ${extra_params} cell_v2 discover_hosts",
    user        => $::nova::params::nova_user,
    refreshonly => true,
    subscribe   => Anchor['nova::service::end']
  }
}
