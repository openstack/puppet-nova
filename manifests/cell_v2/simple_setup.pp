# == Class: nova::cell_v2::simple_setup
#
# Class to execute minimal nova cell_v2 setup. This is a manual implementation
# of the cell_v2 simple_cell_setup in puppet.
#
# === Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to pass
#   to the nova-manage command. These will be inserted in
#   the command line between 'nova-manage' and 'cell_v2'.
#   Defaults to ''
#
# [*transport_url*]
#   (optional) This is the transport url to use for the cell_v2 commands.
#   By default the command should look for the DEFAULT/transport_url from
#   the nova configuration. If not available, you need to provide the
#   transport url via the parameters. Prior to Ocata, the transport-url
#   was a required parameter.
#   Defaults to undef.
#
# [*database_connection*]
#   (optional) This is the database url to use for the cell_v2 create command
#   for the initial cell1 cell.
#   By default the command should look for the DEFAULT/database_connection from
#   the nova configuration. If not available, you need to provide the database
#   url via the parameters.
#   Defaults to undef.
#
class nova::cell_v2::simple_setup (
  $extra_params        = '',
  $transport_url       = undef,
  $database_connection = undef,
) {

  include ::nova::deps

  include ::nova::cell_v2::map_cell0

  nova::cell_v2::cell { 'default':
    extra_params        => $extra_params,
    transport_url       => $transport_url,
    database_connection => $database_connection
  }

  include ::nova::cell_v2::discover_hosts

  Class['nova::cell_v2::map_cell0'] ->
    Nova::Cell_v2::Cell <| |> ~>
      Class['nova::cell_v2::discover_hosts']

}
