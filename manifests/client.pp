# == Class nova::client
#
# installs nova client
#
# === Parameters:
#
# [*ensure*]
#   (optional) The state for the nova client package
#   Defaults to 'present'
#
class nova::client(
  $ensure = 'present'
) {
  include ::nova::deps
  include ::nova::params

  package { 'python-novaclient':
    ensure => $ensure,
    name   => $::nova::params::client_package,
    tag    => ['openstack', 'nova-support-package'],
  }

}
