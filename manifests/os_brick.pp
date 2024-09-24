# == Class: nova::os_brick
#
# Configure os_brick options
#
# === Parameters:
#
# [*lock_path*]
#   (Optional) Directory to use for os-brick lock files.
#   Defaults to $facts['os_service_default']
#
# [*wait_mpath_device_attempts*]
#   (Optional) Number of attempts for the multipath device to be ready for I/O
#   after it was created.
#   Defaults to $facts['os_service_default']
#
# [*wait_mpath_device_interval*]
#   (Optional) Interval value to wait for multipath device to be ready for I/O.
#   Defaults to $facts['os_service_default']
#
class nova::os_brick(
  $lock_path                  = $facts['os_service_default'],
  $wait_mpath_device_attempts = $facts['os_service_default'],
  $wait_mpath_device_interval = $facts['os_service_default'],
) {

  oslo::os_brick { 'nova_config':
    lock_path                  => $lock_path,
    wait_mpath_device_attempts => $wait_mpath_device_attempts,
    wait_mpath_device_interval => $wait_mpath_device_interval,
  }
}
