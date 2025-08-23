# == Class: nova::glance
#
# Configure usage of the glance service in nova
#
# === Parameters
#
# [*endpoint_override*]
#   (optional) Override the endpoint to use to talk to Glance.
#   Defaults to $facts['os_service_default']
#
# [*valid_interfaces*]
#   (optional) List of interfaces, in order of preference.
#   Defaults to $facts['os_service_default']
#
# [*num_retries*]
#   (optional) Number of retries in glance operation
#   Defaults to $facts['os_service_default']
#
# [*verify_glance_signatures*]
#   (optional) Whether to verify image signatures. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*enable_rbd_download*]
#   (optional) Enable download of Glance images directly via RBD
#   Defaults to $facts['os_service_default']
#
# [*rbd_user*]
#   (optional) The RADOS client name for accessing Glance images stored as
#   rbd volumes.
#   Defaults to $facts['os_service_default']
#
# [*rbd_connect_timeout*]
#   (optional) THe RADOS client timeout in seconds when initially connecting
#   to the cluster.
#   Defaults to $facts['os_service_default']
#
# [*rbd_pool*]
#   (optional) The RADOS pool in which the Glance images are stored as rbd
#   volumes.
#   Defaults to $facts['os_service_default']
#
# [*rbd_ceph_conf*]
#   (optional) Path to the ceph configuration file to use.
#   Defaults to $facts['os_service_default']
#
class nova::glance (
  $endpoint_override        = $facts['os_service_default'],
  $valid_interfaces         = $facts['os_service_default'],
  $num_retries              = $facts['os_service_default'],
  $verify_glance_signatures = $facts['os_service_default'],
  $enable_rbd_download      = $facts['os_service_default'],
  $rbd_user                 = $facts['os_service_default'],
  $rbd_connect_timeout      = $facts['os_service_default'],
  $rbd_pool                 = $facts['os_service_default'],
  $rbd_ceph_conf            = $facts['os_service_default'],
) {
  include nova::deps

  nova_config {
    'glance/endpoint_override':        value => $endpoint_override;
    'glance/valid_interfaces':         value => join(any2array($valid_interfaces), ',');
    'glance/num_retries':              value => $num_retries;
    'glance/verify_glance_signatures': value => $verify_glance_signatures;
    'glance/enable_rbd_download':      value => $enable_rbd_download;
    'glance/rbd_user':                 value => $rbd_user;
    'glance/rbd_connect_timeout':      value => $rbd_connect_timeout;
    'glance/rbd_pool':                 value => $rbd_pool;
    'glance/rbd_ceph_conf':            value => $rbd_ceph_conf;
  }
}
