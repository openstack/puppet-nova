# == Class: nova::consoleauth
#
# Configure the consoleauth options
#
# === Parameters
#
# [*token_ttl*]
#  (Optional) The lifetime of a console auth token (in seconds).
#  Defaults to $facts['os_service_default'].
#
# [*enforce_session_timeout*]
#  (Optional) Enable ot disable enforce session timeout for VM console.
#  Defaults to $facts['os_service_default'].
#
class nova::consoleauth (
  $token_ttl               = $facts['os_service_default'],
  $enforce_session_timeout = $facts['os_service_default'],
) {

  include nova::deps

  nova_config {
    'consoleauth/token_ttl':               value => $token_ttl;
    'consoleauth/enforce_session_timeout': value => $enforce_session_timeout;
  }
}
