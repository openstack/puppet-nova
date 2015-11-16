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

  package { 'python-novaclient':
    ensure => $ensure,
    tag    => ['openstack', 'nova-support-package'],
  }

}
