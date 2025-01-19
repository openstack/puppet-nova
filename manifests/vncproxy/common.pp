# == Class: nova::vncproxy::common
#
# [*vncproxy_host*]
#   (optional) The host of the VNC proxy server
#   Defaults to undef
#
# [*vncproxy_protocol*]
#   (optional) The protocol to communicate with the VNC proxy server
#   Defaults to undef
#
# [*vncproxy_port*]
#   (optional) The port to communicate with the VNC proxy server
#   Defaults to undef
#
# [*vncproxy_path*]
#   (optional) The path at the end of the uri for communication with the VNC proxy server
#   Defaults to undef
#
class nova::vncproxy::common (
  Optional[String[1]] $vncproxy_host                 = undef,
  Optional[Enum['http', 'https']] $vncproxy_protocol = undef,
  Optional[Stdlib::Port] $vncproxy_port              = undef,
  Optional[String] $vncproxy_path                    = undef,
) {

  include nova::deps

  if defined('$::nova::compute::vncproxy_host') {
    $compute_vncproxy_host_real = $::nova::compute::vncproxy_host
  } else {
    $compute_vncproxy_host_real = undef
  }

  if defined('$::nova::vncproxy::host') {
    $compat_vncproxy_host_real = $::nova::vncproxy::host
  } else {
    $compat_vncproxy_host_real = undef
  }

  $vncproxy_host_real = normalize_ip_for_uri(pick(
    $vncproxy_host,
    $compute_vncproxy_host_real,
    $compat_vncproxy_host_real,
    false))

  if defined('$::nova::compute::vncproxy_protocol') {
    $compute_vncproxy_protocol_real = $::nova::compute::vncproxy_protocol
  } else {
    $compute_vncproxy_protocol_real = undef
  }

  if defined('$::nova::vncproxy::vncproxy_protocol') {
    $compat_vncproxy_protocol_real = $::nova::vncproxy::vncproxy_protocol
  } else {
    $compat_vncproxy_protocol_real = undef
  }

  $vncproxy_protocol_real = pick(
    $vncproxy_protocol,
    $compute_vncproxy_protocol_real,
    $compat_vncproxy_protocol_real,
    'http')

  if defined('$::nova::compute::vncproxy_port') {
    $compute_vncproxy_port_real = $::nova::compute::vncproxy_port
  } else {
    $compute_vncproxy_port_real = undef
  }

  if defined('$::nova::vncproxy::port') {
    $compat_vncproxy_port_real = $::nova::vncproxy::port
  } else {
    $compat_vncproxy_port_real = undef
  }

  $vncproxy_port_real = pick(
    $vncproxy_port,
    $compute_vncproxy_port_real,
    $compat_vncproxy_port_real,
    6080)

  if defined('$::nova::compute::vncproxy_path') {
    $compute_vncproxy_path_real = $::nova::compute::vncproxy_path
  } else {
    $compute_vncproxy_path_real = undef
  }

  if defined('$::nova::vncproxy::vncproxy_path') {
    $compat_vncproxy_path_real = $::nova::vncproxy::vncproxy_path
  } else {
    $compat_vncproxy_path_real = undef
  }

  $vncproxy_path_real = pick(
    $vncproxy_path,
    $compute_vncproxy_path_real,
    $compat_vncproxy_path_real,
    '/vnc_auto.html')

  if ($vncproxy_host_real) {
    $vncproxy_base_url = "${vncproxy_protocol_real}://${vncproxy_host_real}:${vncproxy_port_real}${vncproxy_path_real}"
    # config for vnc proxy
    nova_config {
      'vnc/novncproxy_base_url': value => $vncproxy_base_url;
    }
  }
}
