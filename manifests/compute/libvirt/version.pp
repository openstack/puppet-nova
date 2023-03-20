# Class: nova::compute::libvirt::version
#
# Try to detect the version by OS
# Right now this is only used by nova::compute::libvirt::qemu and the
# interesting version is with which release there will be libvirt 4.5
# or higher.
#
class nova::compute::libvirt::version {
  case $facts['os']['family'] {
    'RedHat': {
      $default = '7.0'
    }
    'Debian': {
      $default = '6.0'
    }
    default: {
      fail("Unsupported osfamily: ${::facts['os']['family']}")
    }
  }
}
