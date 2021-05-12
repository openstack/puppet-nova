# == Class: nova::key_manager::barbican
#
# Setup and configure Barbican Key Manager options
#
# === Parameters
#
# [*barbican_endpoint*]
#   (Optional) Use this endpoint to connect to Barbican.
#   Defaults to $::os_service_default
#
# [*barbican_api_version*]
#   (Optional) Version of the Barbican API.
#   Defaults to $::os_service_default
#
# [*auth_endpoint*]
#   (Optional) Use this endpoint to connect to Keystone.
#   Defaults to $::os_service_default
#
# [*retry_delay*]
#   (Optional) Number of seconds to wait before retrying poll for key creation
#   completion.
#   Defaults to $::os_service_default
#
# [*number_of_retries*]
#   (Optional) Number of times to retry poll fo key creation completion.
#   Defaults to $::os_service_default
#
# [*barbican_endpoint_type*]
#   (Optional) Specifies the type of endpoint.
#   Defaults to $::os_service_default
#
# [*barbican_region_name*]
#   (Optional) Specifies the region of the chosen endpoint.
#   Defaults to $::os_service_default
#
class nova::key_manager::barbican (
  $barbican_endpoint      = $::os_service_default,
  $barbican_api_version   = $::os_service_default,
  $auth_endpoint          = $::os_service_default,
  $retry_delay            = $::os_service_default,
  $number_of_retries      = $::os_service_default,
  $barbican_endpoint_type = $::os_service_default,
  $barbican_region_name   = $::os_service_default,
) {

  include nova::deps

  $barbican_endpoint_real = pick($nova::compute::barbican_endpoint, $barbican_endpoint)
  $auth_endpoint_real = pick($nova::compute::barbican_auth_endpoint, $auth_endpoint)
  $barbican_api_version_real = pick($nova::compute::barbican_api_version, $barbican_api_version)

  # cryptsetup is required when Barbican is encrypting volumes
  ensure_packages('cryptsetup', {
    ensure => present,
    tag    => 'openstack',
  })

  oslo::key_manager::barbican { 'nova_config':
    barbican_endpoint      => $barbican_endpoint_real,
    barbican_api_version   => $barbican_api_version_real,
    auth_endpoint          => $auth_endpoint_real,
    retry_delay            => $retry_delay,
    number_of_retries      => $number_of_retries,
    barbican_endpoint_type => $barbican_endpoint_type,
    barbican_region_name   => $barbican_region_name,
  }
}
