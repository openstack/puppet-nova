# Class nova::compute::mdev
#
# Configures nova compute mdev options
#
# === Parameters:
#
# [*mdev_types_device_addresses_mapping*]
#   (optional) Map of mdev type(s) the instances can get as key and list of
#   corresponding device addresses as value.
#   Defaults to {}
#
class nova::compute::mdev(
  $mdev_types_device_addresses_mapping = {},
) {
  include nova::deps

  # TODO(tkajinam): Remove this when we remove nova::compute::vgpu
  $mdev_types_device_addresses_mapping_real = pick(
    $::nova::compute::vgpu::vgpu_types_device_addresses_mapping,
    $mdev_types_device_addresses_mapping)

  if !empty($mdev_types_device_addresses_mapping_real) {
    validate_legacy(Hash, 'validate_hash', $mdev_types_device_addresses_mapping_real)
    $mdev_types_real = keys($mdev_types_device_addresses_mapping_real)
    nova_config {
      'devices/enabled_mdev_types': value  => join(any2array($mdev_types_real), ',');
    }

    # TODO(tkajinam): Remove this when we remove nova::compute::vgpu
    nova_config {
      'devices/enabled_vgpu_types': ensure => absent;
    }

    $mdev_types_device_addresses_mapping_real.each |$mdev_type, $device_addresses| {
      if !empty($device_addresses) {
        nova_config {
          "mdev_${mdev_type}/device_addresses": value => join(any2array($device_addresses), ',');
        }

        # TODO(tkajinam): Remove this when we remove nova::compute::vgpu
        nova_config {
          "vgpu_${mdev_type}/device_addresses": ensure => absent;
        }
      } else {
        nova_config {
          "mdev_${mdev_type}/device_addresses": ensure => absent;
        }
      }
    }
  } else {
    nova_config {
      'devices/enabled_mdev_types': ensure => absent;
    }
  }
}
