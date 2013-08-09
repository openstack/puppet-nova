# unzip swig screen parted curl euca2ools - extra packages
class nova::utilities {
  if $::osfamily == 'Debian' {
    ensure_packages(['unzip', 'screen', 'parted', 'curl', 'euca2ools'])
  }
}
