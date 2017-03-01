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
# DEPRECATED
#
# [*extra_params*]
#   This parameter is deprecated and will be ignored
#
define nova::cell_v2::cell (
  $extra_params        = undef,
  $transport_url       = 'default',
  $database_connection = 'default'
) {

  warning('nova::cell_v2::cell is deprecated by the nova_cell_v2 type in Pike and will be removed in the future.')
  if $extra_params {
    warning('The nova::cell_v2::cell::extra_params parameter is deprecated and will be ignored')
  }

  include ::nova::deps

  nova_cell_v2 { "${title}":
    transport_url       => $transport_url,
    database_connection => $database_connection
  }
}
