# == Class: nova::cell_v2::map_instances
#
#  Resource to run the map_instances action for cell v2
#
# === Parameters
#
# [*cell_uuid*]
#  (String) Cell UUID to map unmigrated instances to. It is recommended to use
#  this rather than cell name. Either cell_uuid or cell_name must be provided.
#  Defaults to undef.
#
# [*cell_name*]
#  (String) Cell name to map the unmigrated instances to. We will attempt to
#  extract the cell uuid using the name as the command requires a cell uuid.
#  NOTE: This will not work if you have multiple cells with the same name.
#  Defaults to undef.
#
# [*extra_params*]
#  (String) Extra parameters to pass to the nova-manage commands.
#  Defaults to ''.
#
class nova::cell_v2::map_instances (
  $cell_uuid    = undef,
  $cell_name    = undef,
  $extra_params = '',
) {

  include ::nova::deps
  include ::nova::params

  if (!$cell_uuid and !$cell_name) {
    fail('Either cell_uuid or cell_name must be provided')
  }

  if ($cell_uuid) {
    $cell_uuid_real = $cell_uuid
  } else {
    # NOTE(aschultz): This is what breaks if you have multiple cells with the
    # same name. So that's why using cell_uuid is better.
    $cell_uuid_real = "$(nova-manage cell_v2 list_cells | sed -e '1,3d' -e '\$d' | awk -F ' *| *' '\$2 == \"${cell_name}\" {print \$4}')"
  }

  exec { 'nova-cell_v2-map_instances':
    path        => ['/bin', '/usr/bin'],
    command     => "nova-manage ${extra_params} cell_v2 map_instances --cell_uuid=${cell_uuid_real}",
    user        => $::nova::params::nova_user,
    refreshonly => true,
  }
}
