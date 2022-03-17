# Class nova::compute::vgpu
#
# DEPRECATED !!
# Configures nova compute vgpu options
#
# === Parameters:
#
# [*vgpu_types_device_addresses_mapping*]
#   (optional) Map of vgpu type(s) the instances can get as key and list of
#   corresponding device addresses as value.
#   Defaults to undef
#
class nova::compute::vgpu(
  $vgpu_types_device_addresses_mapping = undef,
) {
  include nova::deps

  if $vgpu_types_device_addresses_mapping != undef {
    validate_legacy(Hash, 'validate_hash', $vgpu_types_device_addresses_mapping)
  }

  if $vgpu_types_device_addresses_mapping != undef or ! defined(Class[nova::compute]) {
    # NOTE(tkajinam): If the nova::compute class is not yet included then it is
    #                 likely this class is included explicitly.
    warning('The nova::compute::vgpu class is deprecated. Use the nova::compute::mdev class instead')
  }
  include nova::compute::mdev
}
