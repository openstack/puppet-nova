# == Class: nova::workarounds
#
# nova workarounds configuration
#
# === Parameters:
#
#  [*enable_numa_live_migration*]
#   (optional) Whether to enable live migration for NUMA topology instances.
#   Defaults to false
#
class nova::workarounds (
  $enable_numa_live_migration = false,
) {

  nova_config {
    'workarounds/enable_numa_live_migration': value => $enable_numa_live_migration;
  }

}

