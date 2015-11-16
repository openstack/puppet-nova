# Creates floating networks
#
# === Parameters:
#
# [*network*]
#  (mandatory) The network name to work on
#
define nova::manage::floating ( $network ) {

  include ::nova::deps

  nova_floating { $name:
    ensure   => present,
    network  => $network,
    provider => 'nova_manage',
  }
}
