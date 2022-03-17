# Define nova::compute::mdev_type
#
# Configures nova compute mdev_<type> options
#
# === Parameters:
#
# [*mdev_type*]
#  (Optional) mdev type
#  Defaults to $name
#
# [*device_addresses*]
#  (Optional) A list of PCI addresses corresponding to the physical GPU(s) or
#  mdev-capable hardware.
#  Defaults to $::os_service_default
#
# [*mdev_class*]
#  (Optional) Class of mediated device to manage used to differentiate between
#  device type.
#  Defaults to $::os_service_default
#
define nova::compute::mdev_type (
  $mdev_type        = $name,
  $device_addresses = $::os_service_default,
  $mdev_class       = $::os_service_default,
) {

  if empty($device_addresses) {
    nova_config {
      "mdev_${mdev_type}/device_addresses": value => $::os_service_default
    }
  } else {
    nova_config {
      "mdev_${mdev_type}/device_addresses": value => join(any2array($device_addresses), ',');
    }
  }

  # TODO(tkajinam): Remove this when we remove nova::compute::vgpu
  nova_config {
    "vgpu_${mdev_type}/device_addresses": ensure => absent;
  }

  nova_config {
    "mdev_${mdev_type}/mdev_class": value => $mdev_class;
  }
}
