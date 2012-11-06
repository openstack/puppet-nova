# unzip swig screen parted curl euca2ools - extra packages
class nova::utilities {
  if $::osfamily == 'Debian' {
    package { ['unzip', 'screen', 'parted', 'curl', 'euca2ools']:
      ensure => present
    }
  }
}
