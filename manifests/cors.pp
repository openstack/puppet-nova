# == Class: nova::cors
#
# Configure the nova cors
#
# === Parameters
#
# [*allowed_origin*]
#   (Optional) Indicate whether this resource may be shared with the domain
#   received in the requests "origin" header.
#   (string value)
#   Defaults to $::os_service_default.
#
# [*allow_credentials*]
#   (Optional) Indicate that the actual request can include user credentials.
#   (boolean value)
#   Defaults to $::os_service_default.
#
# [*expose_headers*]
#   (Optional) Indicate which headers are safe to expose to the API.
#   (list value)
#   Defaults to $::os_service_default.
#
# [*max_age*]
#   (Optional) Maximum cache age of CORS preflight requests.
#   (integer value)
#   Defaults to $::os_service_default.
#
# [*allow_methods*]
#   (Optional) Indicate which methods can be used during the actual request.
#   (list value)
#   Defaults to $::os_service_default.
#
# [*allow_headers*]
#   (Optional) Indicate which header field names may be used during the actual
#   request.
#   (list value)
#   Defaults to $::os_service_default.
#
class nova::cors (
  $allowed_origin    = $::os_service_default,
  $allow_credentials = $::os_service_default,
  $expose_headers    = $::os_service_default,
  $max_age           = $::os_service_default,
  $allow_methods     = $::os_service_default,
  $allow_headers     = $::os_service_default,
) {

  include ::nova::deps

  oslo::cors { 'nova_config':
    allowed_origin    => $allowed_origin,
    allow_credentials => $allow_credentials,
    expose_headers    => $expose_headers,
    max_age           => $max_age,
    allow_methods     => $allow_methods,
    allow_headers     => $allow_headers,
  }
}
