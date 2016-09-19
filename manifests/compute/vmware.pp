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
#   Defaults to 5.
#
# [*maximum_objects*]
#   (optional) The maximum number of ObjectContent data objects that should
#   be returned in a single result. A positive value will cause
#   the operation to suspend the retrieval when the count of
#   objects reaches the specified maximum. The server may still
#   limit the count to something less than the configured value.
#   Any remaining objects may be retrieved with additional requests.
#   Defaults to 100.
#
# [*task_poll_interval*]
#   (optional) The interval in seconds used for polling of remote tasks.
#   Defaults to 5.0
#
# [*use_linked_clone*]
#   (optional) Whether to use linked clone strategy while creating VM's.
#   Defaults to true.
#
# [*wsdl_location*]
#   (optional) VIM Service WSDL Location e.g
#   http://<server>/vimService.wsdl. Optional over-ride to
#   default location for bug work-arounds.
#   Defaults to $::os_service_default
#
# [*compute_driver*]
#   (optional) Compute driver.
#   Defaults to 'vmwareapi.VMwareVCDriver'
#
# [*insecure*]
#   (optional) Allow insecure conections.
#   If true, the vCenter server certificate is not verified. If
#   false, then the default CA truststore is used for verification. This
#   option is ignored if “ca_file” is set.
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) Specify a CA bundle file to use in verifying the vCenter server
#   certificate.
#   Defaults to $::os_service_default
#
# [*datastore_regex*]
#   (optional) Regex to match the name of a datastore.
#   Defaults to $::os_service_default
#
class nova::compute::vmware(
  $host_ip,
  $host_username,
  $host_password,
  $cluster_name,
  $api_retry_count    = 5,
  $maximum_objects    = 100,
  $task_poll_interval = 5.0,
  $use_linked_clone   = true,
  $wsdl_location      = $::os_service_default,
  $compute_driver     = 'vmwareapi.VMwareVCDriver',
  $insecure           = $::os_service_default,
  $ca_file            = $::os_service_default,
  $datastore_regex    = $::os_service_default,
) {

  include ::nova::deps

  nova_config {
    'DEFAULT/compute_driver':    value => $compute_driver;
    'vmware/host_ip':            value => $host_ip;
    'vmware/host_username':      value => $host_username;
    'vmware/host_password':      value => $host_password;
    'vmware/cluster_name':       value => $cluster_name;
    'vmware/api_retry_count':    value => $api_retry_count;
    'vmware/maximum_objects':    value => $maximum_objects;
    'vmware/task_poll_interval': value => $task_poll_interval;
    'vmware/use_linked_clone':   value => $use_linked_clone;
    'vmware/wsdl_location':      value => $wsdl_location;
    'vmware/insecure':           value => $insecure;
    'vmware/ca_file':            value => $ca_file;
    'vmware/datastore_regex':    value => $datastore_regex;
  }

  package { 'python-suds':
    ensure => present,
    tag    => ['openstack', 'nova-support-package'],
  }
}
