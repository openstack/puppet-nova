# == Class: nova::qpid
#
# Deprecated class for installing qpid server for nova
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the service
#   Defaults to true
#
# [*user*]
#   (optional) The user to create in qpid
#   Defaults to 'guest'
#
# [*password*]
#   (optional) The password to create for the user
#   Defaults to 'guest'
#
# [*file*]
#   (optional) Sasl file for the user
#   Defaults to '/var/lib/qpidd/qpidd.sasldb'
#
# [*realm*]
#   (optional) Realm for the user
#   Defaults to 'OPENSTACK'
#
class nova::qpid(
  $enabled  = undef,
  $user     = undef,
  $password = undef,
  $file     = undef,
  $realm    = undef
) {

  warning('Qpid driver is removed from Oslo.messaging in the Mitaka release')
}
