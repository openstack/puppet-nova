# == Class: nova::glance
#
# Configure usage of the glance service in nova
#
# === Parameters
#
# [*enable_rbd_download*]
#   (optional) Enable download of Glance images directly via RBD
#   Defaults to $::os_service_default
#
# [*rbd_user*]
#   (optional) The RADOS client name for accessing Glance images stored as
#   rbd volumes.
#   Defaults to $::os_service_default
#
# [*rbd_connect_timeout*]
#   (optional) THe RADOS client timeout in seconds when initially connecting
#   to the cluster.
#   Defaults to $::os_service_default
#
# [*rbd_pool*]
#   (optional) The RADOS pool in which the Glance images are stored as rbd
#   volumes.
#   Defaults to $::os_service_default
#
# [*rbd_ceph_conf*]
#   (optional) Path to the ceph configuration file to use.
#   Defaults to $::os_service_default
#
class nova::glance (
  $enable_rbd_download = $::os_service_default,
  $rbd_user            = $::os_service_default,
  $rbd_connect_timeout = $::os_service_default,
  $rbd_pool            = $::os_service_default,
  $rbd_ceph_conf       = $::os_service_default,
) {

  include nova::deps

  nova_config {
    'glance/enable_rbd_download': value => $enable_rbd_download;
    'glance/rbd_user':            value => $rbd_user;
    'glance/rbd_connect_timeout': value => $rbd_connect_timeout;
    'glance/rbd_pool':            value => $rbd_pool;
    'glance/rbd_ceph_conf':       value => $rbd_ceph_conf;
  }
}
