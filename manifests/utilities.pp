# == Class nova::utilities
#
# Extra packages used by nova tools
# unzip swig screen parted curl euca2ools - extra packages
class nova::utilities {
  if $::osfamily == 'Debian' {
    ensure_packages(['unzip', 'screen', 'parted', 'curl', 'euca2ools'])
  }
}
