# Class: nova::compute::libvirt::version
#
# Try to detect the version by OS
# Right now this is only used by nova::compute::libvirt::qemu and the
# interesting version is with which release there will be libvirt 4.5
# or higher.
#
class nova::compute::libvirt::version {
  # This will be 7.5 or 7.6 on RedHat, 9 on Debian, 18.10 or cosmic on Ubuntu, etc.
  case $facts['os']['family'] {
    'RedHat': {
      case $facts['os']['name'] {
        'RedHat', 'CentOS': {
          if versioncmp($facts['os']['release']['full'], '8.1') >= 0 {
            $default = '5.6'
          } elsif versioncmp($facts['os']['release']['full'], '7.6') >= 0 {
            $default = '4.5'
          } else {
            $default = '3.9'
          }
        }
        'Fedora': {
          if versioncmp($facts['os']['release']['full'], '29') >= 0 {
            $default = '4.5'
          } else {
            $default = '3.9'
          }
        }
        default: {
          $default = '3.9'
        }
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
