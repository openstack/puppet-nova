# Class nova::compute::vgpu
#
# Configures nova compute vgpu options
#
# === Parameters:
#
# [*vgpu_types_device_addresses_mapping*]
#   (optional) Map of vgpu type(s) the instances can get as key and list of
#   corresponding device addresses as value.
#   Defaults to {}
#
#  DEPRECATED PARAMETERS
#
# [*enabled_vgpu_types*]
#   (optional) Specify which specific GPU type(s) the instances can get
#   Defaults to undef
#

class nova::compute::vgpu(
  $vgpu_types_device_addresses_mapping      = {},
  # DEPRECATED PARAMETERS
  $enabled_vgpu_types                       = undef,
) {
  include nova::deps

  if $enabled_vgpu_types {
    warning('enabled_vgpu_types is deprecated, instead use vgpu_types_device_addresses_mapping parameter.')

    if !empty($vgpu_types_device_addresses_mapping) {
      warning('vgpu_types_device_addresses_mapping is ignored, when both enabled_vgpu_types \
and vgpu_types_device_addresses_mapping are defined.')
    }
  }

  if $enabled_vgpu_types != undef and !empty($enabled_vgpu_types) {
    nova_config {
      'devices/enabled_vgpu_types': value => join(any2array($enabled_vgpu_types), ',');
    }
  } elsif !empty($vgpu_types_device_addresses_mapping) {
    validate_legacy(Hash, 'validate_hash', $vgpu_types_device_addresses_mapping)
    $vgpu_types_real = keys($vgpu_types_device_addresses_mapping)
    nova_config {
      'devices/enabled_vgpu_types': value => join(any2array($vgpu_types_real), ',');
    }

    $vgpu_types_device_addresses_mapping.each |$vgpu_type, $device_addresses| {
      if !empty($device_addresses) {
        nova_config {
          "vgpu_${vgpu_type}/device_addresses": value => join(any2array($device_addresses), ',');
        }
      } else {
        nova_config {
          "vgpu_${vgpu_type}/device_addresses": ensure => absent;
        }
      }
    }
  } else {
    nova_config {
      'devices/enabled_vgpu_types': ensure => absent;
    }
  }
}
