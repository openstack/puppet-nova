# == Class: nova::glance
#
# Configure usage of the glance service in nova
#
# === Parameters
#
# [*endpoint_override*]
#   (optional) Override the endpoint to use to talk to Glance.
#   Defaults to $::os_service_default
#
# [*valid_interfaces*]
#   (optional) List of interfaces, in order of preference.
#   Defaults to $::os_service_default
#
# [*num_retries*]
#   (optional) Number of retries in glance operation
#   Defaults to $::os_service_default
#
# [*verify_glance_signatures*]
#   (optional) Whether to verify image signatures. (boolean value)
#   Defaults to $::os_service_default
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
  $endpoint_override        = $::os_service_default,
  $valid_interfaces         = $::os_service_default,
  $num_retries              = $::os_service_default,
  $verify_glance_signatures = $::os_service_default,
  $enable_rbd_download      = $::os_service_default,
  $rbd_user                 = $::os_service_default,
  $rbd_connect_timeout      = $::os_service_default,
  $rbd_pool                 = $::os_service_default,
  $rbd_ceph_conf            = $::os_service_default,
) {

  include nova::deps

  $endpoint_override_real = pick($::nova::glance_endpoint_override, $endpoint_override)
  $num_retries_real = pick($::nova::glance_num_retries, $num_retries)
  $verify_glance_signatures_real = pick($::nova::compute::verify_glance_signatures, $verify_glance_signatures)

  nova_config {
    'glance/endpoint_override':        value => $endpoint_override_real;
    'glance/valid_interfaces':         value => join(any2array($valid_interfaces), ',');
    'glance/num_retries':              value => $num_retries_real;
    'glance/verify_glance_signatures': value => $verify_glance_signatures_real;
    'glance/enable_rbd_download':      value => $enable_rbd_download;
    'glance/rbd_user':                 value => $rbd_user;
    'glance/rbd_connect_timeout':      value => $rbd_connect_timeout;
    'glance/rbd_pool':                 value => $rbd_pool;
    'glance/rbd_ceph_conf':            value => $rbd_ceph_conf;
  }
}
