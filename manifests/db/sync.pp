#
# Class to execute nova dbsync
#
# ==Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the nova-manage db sync command. These will be inserted in
#   the command line between 'nova-manage' and 'db sync'.
#   Defaults to undef
#
class nova::db::sync(
  $extra_params = undef,
) {

  include ::nova::params

  Package<| tag =='nova-package'  |> ~> Exec['nova-db-sync']
  Exec['nova-db-sync'] ~> Service <| tag == 'nova-service' |>

  Nova_config <||> -> Exec['nova-db-sync']
  Nova_config <| title == 'database/connection' |> ~> Exec['nova-db-sync']

  Exec<| title == 'post-nova_config' |> ~> Exec['nova-db-sync']

  exec { 'nova-db-sync':
    command     => "/usr/bin/nova-manage ${extra_params} db sync",
    refreshonly => true,
    logoutput   => on_failure,
  }

}
