# == Class: nova::workarounds
#
# nova workarounds configuration
#
# === Parameters:
#
# DEPRECATED
#
#  [*enable_numa_live_migration*]
#   (optional) Whether to enable live migration for NUMA topology instances.
#   Defaults to undef
#
class nova::workarounds (
  # DEPRECATED PARAMETER
  $enable_numa_live_migration = undef,
) {

  if $enable_numa_live_migration != undef {
    warning('The enable_numa_live_migration parameter is deprecated')
    nova_config {
      'workarounds/enable_numa_live_migration': value => $enable_numa_live_migration;
    }
  }

}
