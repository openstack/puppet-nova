# == Type: nova::cell_v2::cell
#
# Resource for managing cell_v2 cells.
#
# === Parameters
#
# [*extra_params*]
#  (String) Extra parameters to pass to the nova-manage commands.
#  Defaults to ''.
#
# [*transport_url*]
#  (String) AMQP transport url for the cell.
#  If not defined, the [DEFAULT]/transport_url is used from the nova
#  configuration file.
#  Defaults to undef.
#
# [*database_connection*]
#  (String)  Database connection url for the cell.
#  If not defined, the [DEFAULT]/database_connection is used from the nova
#  configuration file.
#  Defaults to undef.
#
define nova::cell_v2::cell (
  $extra_params        = '',
  $transport_url       = undef,
  $database_connection = undef
) {

  include ::nova::deps

  if $transport_url {
    $transport_url_real = "--transport-url=${transport_url}"
  } else {
    $transport_url_real = ''
  }

  if $database_connection {
    $database_connection_real = "--database_connection=${database_connection}"
  } else {
    $database_connection_real = ''
  }

  exec { "nova-cell_v2-cell-${title}":
    path      => [ '/bin', '/usr/bin' ],
    command   => "nova-manage ${extra_params} cell_v2 create_cell --name=${title} ${transport_url_real} ${database_connection_real}",
    unless    => "nova-manage ${extra_params} cell_v2 list_cells | grep -q ${title}",
    logoutput => on_failure,
    subscribe => Anchor['nova::cell_v2::begin'],
    notify    => Anchor['nova::cell_v2::end'],
  }
}
