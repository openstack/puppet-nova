# Class nova::compute::mdev
#
# Configures nova compute mdev options
#
# === Parameters:
#
# [*mdev_types*]
#   (Optional) A hash to define the nova::compute::mdev_type resources.
#   Defaults to {}
#
class nova::compute::mdev(
  $mdev_types = {},
) {
  include nova::deps

  validate_legacy(Hash, 'validate_hash', $mdev_types)

  if !empty($mdev_types) {
    nova_config {
      'devices/enabled_mdev_types': value => join(keys($mdev_types), ',')
    }
    create_resources('nova::compute::mdev_type', $mdev_types)
  } else {
    nova_config {
      'devices/enabled_mdev_types': ensure => absent;
    }
  }
}
