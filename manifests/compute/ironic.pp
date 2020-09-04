# == Class: nova::compute::ironic
#
# Configures Nova compute service to use Ironic.
#
# === Parameters:
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'ironic.IronicDriver'
#
# [*max_concurrent_builds*]
#   (optional) Maximum number of instance builds to run concurrently
#   Defaults to undef
#
class nova::compute::ironic (
  $compute_driver        = 'ironic.IronicDriver',
  # DEPRECATED PARAMETERS
  $max_concurrent_builds = undef,
) {

  include nova::deps
  require nova::ironic::common
  include ironic::client

  nova_config {
    'DEFAULT/compute_driver': value => $compute_driver;
  }

  if $max_concurrent_builds != undef {
    warn('The nova::compute::ironic::max_concurrent_builds parameter is deprecated \
and will be removed in a future release. Use nova::compute::max_concurrent_builds instead.')
    nova_config {
    'DEFAULT/max_concurrent_builds': value => $max_concurrent_builds;
    }
  }

}
