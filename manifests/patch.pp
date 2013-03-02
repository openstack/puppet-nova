class nova::patch {
  if !defined(Package['patch']) {
    package { 'patch':
      ensure => present
    }
  }
}
