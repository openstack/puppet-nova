# Class nova::compute::vgpu
#
# Configures nova compute vgpu options
#
# === Parameters:
#
#  [*enabled_vgpu_types*]
#   (optional) Specify which specific GPU type(s) the instances can get
#   Defaults to $::os_service_default
#   Example: 'nvidia-35' or ['nvidia-35', 'nvidia-36']

class nova::compute::vgpu(
  $enabled_vgpu_types = $::os_service_default
) {
  include ::nova::deps

  nova_config {
    'devices/enabled_vgpu_types': value => join(any2array($enabled_vgpu_types), ',');
  }
}
