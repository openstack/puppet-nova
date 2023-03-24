# == Class: nova::compute::vmware
#
# Configure the VMware compute driver for nova.
#
# === Parameters
#
# [*host_ip*]
#   The IP address of the VMware vCenter server.
#
# [*host_username*]
#   The username for connection to VMware vCenter server.
#
# [*host_password*]
#   The password for connection to VMware vCenter server.
#
# [*cluster_name*]
#   The name of a vCenter cluster compute resource.
#
# [*api_retry_count*]
#   (optional) The number of times we retry on failures,
#   e.g., socket error, etc.
#   Defaults to $facts['os_service_default'].
#
# [*maximum_objects*]
#   (optional) The maximum number of ObjectContent data objects that should
#   be returned in a single result. A positive value will cause
#   the operation to suspend the retrieval when the count of
#   objects reaches the specified maximum. The server may still
#   limit the count to something less than the configured value.
#   Any remaining objects may be retrieved with additional requests.
#   Defaults to $facts['os_service_default'].
#
# [*task_poll_interval*]
#   (optional) The interval in seconds used for polling of remote tasks.
#   Defaults to $facts['os_service_default'].
#
# [*use_linked_clone*]
#   (optional) Whether to use linked clone strategy while creating VM's.
#   Defaults to $facts['os_service_default'].
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'vmwareapi.VMwareVCDriver'
#
# [*insecure*]
#   (optional) Allow insecure connections.
#   If true, the vCenter server certificate is not verified. If
#   false, then the default CA truststore is used for verification. This
#   option is ignored if 'ca_file' is set.
#   Defaults to $facts['os_service_default']
#
# [*ca_file*]
#   (optional) Specify a CA bundle file to use in verifying the vCenter server
#   certificate.
#   Defaults to $facts['os_service_default']
#
# [*datastore_regex*]
#   (optional) Regex to match the name of a datastore.
#   Defaults to $facts['os_service_default']
#
class nova::compute::vmware(
  $host_ip,
  $host_username,
  $host_password,
  $cluster_name,
  $api_retry_count    = $facts['os_service_default'],
  $maximum_objects    = $facts['os_service_default'],
  $task_poll_interval = $facts['os_service_default'],
  $use_linked_clone   = $facts['os_service_default'],
  $compute_driver     = 'vmwareapi.VMwareVCDriver',
  $insecure           = $facts['os_service_default'],
  $ca_file            = $facts['os_service_default'],
  $datastore_regex    = $facts['os_service_default'],
) {

  include nova::deps
  include nova::params

  nova_config {
    'DEFAULT/compute_driver':    value => $compute_driver;
    'vmware/host_ip':            value => $host_ip;
    'vmware/host_username':      value => $host_username;
    'vmware/host_password':      value => $host_password, secret => true;
    'vmware/cluster_name':       value => $cluster_name;
    'vmware/api_retry_count':    value => $api_retry_count;
    'vmware/maximum_objects':    value => $maximum_objects;
    'vmware/task_poll_interval': value => $task_poll_interval;
    'vmware/use_linked_clone':   value => $use_linked_clone;
    'vmware/insecure':           value => $insecure;
    'vmware/ca_file':            value => $ca_file;
    'vmware/datastore_regex':    value => $datastore_regex;
  }

  package { 'python-oslo-vmware':
    ensure => present,
    name   => $::nova::params::oslo_vmware_package_name,
    tag    => ['openstack', 'nova-support-package'],
  }
}
