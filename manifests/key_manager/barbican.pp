# == Class: nova::key_manager::barbican
#
# Setup and configure Barbican Key Manager options
#
# === Parameters
#
# [*barbican_endpoint*]
#   (Optional) Use this endpoint to connect to Barbican.
#   Defaults to $facts['os_service_default']
#
# [*barbican_api_version*]
#   (Optional) Version of the Barbican API.
#   Defaults to $facts['os_service_default']
#
# [*auth_endpoint*]
#   (Optional) Use this endpoint to connect to Keystone.
#   Defaults to $facts['os_service_default']
#
# [*retry_delay*]
#   (Optional) Number of seconds to wait before retrying poll for key creation
#   completion.
#   Defaults to $facts['os_service_default']
#
# [*number_of_retries*]
#   (Optional) Number of times to retry poll fo key creation completion.
#   Defaults to $facts['os_service_default']
#
# [*barbican_endpoint_type*]
#   (Optional) Specifies the type of endpoint.
#   Defaults to $facts['os_service_default']
#
# [*barbican_region_name*]
#   (Optional) Specifies the region of the chosen endpoint.
#   Defaults to $facts['os_service_default']
#
# [*send_service_user_token*]
#   (Optional) The service uses service token feature when this is set as true.
#   Defaults to $facts['os_service_default']
#
class nova::key_manager::barbican (
  $barbican_endpoint       = $facts['os_service_default'],
  $barbican_api_version    = $facts['os_service_default'],
  $auth_endpoint           = $facts['os_service_default'],
  $retry_delay             = $facts['os_service_default'],
  $number_of_retries       = $facts['os_service_default'],
  $barbican_endpoint_type  = $facts['os_service_default'],
  $barbican_region_name    = $facts['os_service_default'],
  $send_service_user_token = $facts['os_service_default'],
) {

  include nova::deps

  # cryptsetup is required when Barbican is encrypting volumes
  ensure_packages('cryptsetup', {
    ensure => present,
    tag    => 'openstack',
  })

  oslo::key_manager::barbican { 'nova_config':
    barbican_endpoint       => $barbican_endpoint,
    barbican_api_version    => $barbican_api_version,
    auth_endpoint           => $auth_endpoint,
    retry_delay             => $retry_delay,
    number_of_retries       => $number_of_retries,
    barbican_endpoint_type  => $barbican_endpoint_type,
    barbican_region_name    => $barbican_region_name,
    send_service_user_token => $send_service_user_token,
  }
}
