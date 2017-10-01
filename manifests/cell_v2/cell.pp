# == Type: nova::cell_v2::cell
#
# Resource for managing cell_v2 cells.
# DEPRECATED by the nova_cell_v2 type.
#
# === Parameters
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
  $transport_url       = 'default',
  $database_connection = 'default'
) {

  warning('nova::cell_v2::cell is deprecated by the nova_cell_v2 type in Pike and will be removed in the future.')

  include ::nova::deps

  nova_cell_v2 { "${title}":
    transport_url       => $transport_url,
    database_connection => $database_connection
  }
}
