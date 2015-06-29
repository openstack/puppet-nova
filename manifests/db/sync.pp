#
# Class to execute nova dbsync
#
class nova::db::sync {

  include ::nova::params

  Package<| tag =='nova-package'  |> ~> Exec['nova-db-sync']
  Exec['nova-db-sync'] ~> Service <| tag == 'nova-service' |>

  Nova_config <||> -> Exec['nova-db-sync']
  Nova_config <| title == 'database/connection' |> ~> Exec['nova-db-sync']

  Exec<| title == 'post-nova_config' |> ~> Exec['nova-db-sync']

  exec { 'nova-db-sync':
    command     => '/usr/bin/nova-manage db sync',
    refreshonly => true,
    logoutput   => on_failure,
  }

}
