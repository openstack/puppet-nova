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
      if versioncmp($facts['os']['release']['full'], '8') >= 0 {
        $default = '5.6'
      } elsif versioncmp($facts['os']['release']['full'], '7.6') >= 0 {
        $default = '4.5'
      } else {
        $default = '3.9'
      }
    }
    'Debian': {
      if versioncmp($facts['os']['release']['full'], '18.04') >= 0 {
        $default = '6.0'
      } else {
        $default = '4.0'
      }
    }
    default: {
      fail("Class['nova::compute::libvirt::version']: Unsupported osfamily: ${::osfamily}")
    }
  }
}
