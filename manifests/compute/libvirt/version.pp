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
      if versioncmp($facts['os']['release']['full'], '9') >= 0 {
        $default = '7.0'
      } else {
        $default = '5.6'
      }
    }
    'Debian': {
      $default = '6.0'
    }
    default: {
      fail("Class['nova::compute::libvirt::version']: Unsupported osfamily: ${::osfamily}")
    }
  }
}
