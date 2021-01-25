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
# [*num_retries*]
#   (optional) Number of retries in glance operation
#   Defaults to $::os_service_default
#
class nova::glance (
  $endpoint_override = $::os_service_default,
  $num_retries       = $::os_service_default,
) {

  include nova::deps

  $endpoint_override_real = pick($::nova::glance_endpoint_override, $endpoint_override)
  $num_retries_real = pick($::nova::glance_num_retries, $num_retries)

  nova_config {
    'glance/endpoint_override': value => $endpoint_override_real;
    'glance/num_retries':       value => $num_retries_real;
  }
}
