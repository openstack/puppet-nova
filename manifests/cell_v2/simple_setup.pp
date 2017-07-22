# == Class: nova::cell_v2::simple_setup
#
# Class to execute minimal nova cell_v2 setup. This is a manual implementation
# of the cell_v2 simple_cell_setup in puppet.
#
# === Parameters
#
# [*transport_url*]
#   (optional) This is the transport url to use for the cell_v2 commands.
#   By default the command should look for the DEFAULT/transport_url from
#   the nova configuration. If not available, you need to provide the
#   transport url via the parameters. Prior to Ocata, the transport-url
#   was a required parameter.
#   Defaults to 'default' (nova.conf value).
#
# [*database_connection*]
#   (optional) This is the database url to use for the cell_v2 create command
#   for the initial cell1 cell.
#   By default the command should look for the DEFAULT/database_connection from
#   the nova configuration. If not available, you need to provide the database
#   url via the parameters.
#   Defaults to 'default' (nova.conf value).
#
# [*database_connection_cell0*]
#   (optional) This is the database url to use for the cell_v2 cell0.
#   By default the command should look for the DEFAULT/database_connection from
#   the nova configuration and append '_cell0'. If not available, you need to provide the database
#   url via the parameters.
#   Defaults to 'default' (nova.conf value).
#
class nova::cell_v2::simple_setup (
  $transport_url       = 'default',
  $database_connection = 'default',
  $database_connection_cell0 = 'default',
) {

  include ::nova::deps

  include ::nova::cell_v2::map_cell0

  nova_cell_v2 { 'cell0':
    database_connection => $database_connection_cell0
  }

  nova_cell_v2 { 'default':
    transport_url       => $transport_url,
    database_connection => $database_connection
  }

  include ::nova::cell_v2::discover_hosts

  Class['nova::cell_v2::map_cell0']
    -> Nova_cell_v2 <| |>
      ~> Class['nova::cell_v2::discover_hosts']

}
