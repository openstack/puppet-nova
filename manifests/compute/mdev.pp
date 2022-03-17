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
# [*mdev_types_device_addresses_mapping*]
#   (Optional) Map of mdev type(s) the instances can get as key and list of
#   corresponding device addresses as value.
#   Defaults to undef
#
class nova::compute::mdev(
  $mdev_types                          = {},
  $mdev_types_device_addresses_mapping = undef,
) {
  include nova::deps

  validate_legacy(Hash, 'validate_hash', $mdev_types)
  if $mdev_types_device_addresses_mapping != undef {
    validate_legacy(Hash, 'validate_hash', $mdev_types_device_addresses_mapping)
  }

  $dev_addr_mapping_real = pick_default($mdev_types_device_addresses_mapping, {})

  if !empty($dev_addr_mapping_real) {
    nova_config {
      'devices/enabled_mdev_types': value => join(keys($dev_addr_mapping_real), ',');
    }

    $dev_addr_mapping_real.each |$mdev_type, $device_addresses| {
      nova::compute::mdev_type { $mdev_type :
        device_addresses => $device_addresses;
      }
    }
  } elsif !empty($mdev_types) {
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
