#  == Class: nova::spice
#
# Configure spicehtml5 proxy
#
# SPICE is a new protocol which aims to address all the limitations in VNC,
# to provide good remote desktop support. This class aim to configure the nova
# services in charge of proxing websocket spicehtml5 request to kvm spice
#
# === Parameters:
#
# [*enabled*]
#   (optional) enable spicehtml5proxy service
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*host*]
#   (optional) Listen address for the html5 console proxy
#   Defaults to 0.0.0.0
#
# [*port*]
#   (optional) Listen port for the html5 console proxy
#   Defaults to 6082
#
# [*ensure_package*]
#   (optional) Ensure package state
#   Defaults to 'present'
#
class nova::spicehtml5proxy(
  $enabled        = true,
  $manage_service = true,
  $host           = '0.0.0.0',
  $port           = '6082',
  $ensure_package = 'present'
) {

  include ::nova::deps
  include ::nova::params

  # Nodes running spicehtml5proxy do *not* need (and in fact, don't care)
  # about [spice]/enable to be set. This setting is for compute nodes,
  # where we must select VNC or SPICE so that it can be passed on to
  # libvirt which passes it as parameter when starting VMs with KVM.
  # Therefore, this setting is set within compute.pp only.
  nova_config {
    'spice/agent_enabled':   value => $enabled;
    'spice/html5proxy_host': value => $host;
    'spice/html5proxy_port': value => $port;
  }

  # The Debian package needs some scheduling:
  # 1/ Install the packagin
  # 2/ Fix /etc/default/nova-consoleproxy
  # 3/ Start the service
  # Other OS don't need this scheduling and can use
  # the standard nova::generic_service
  if $::os_package_type == 'debian' {
    if $enabled {
      file_line { '/etc/default/nova-consoleproxy:NOVA_CONSOLE_PROXY_TYPE':
        path    => '/etc/default/nova-consoleproxy',
        match   => '^NOVA_CONSOLE_PROXY_TYPE=(.*)$',
        line    => 'NOVA_CONSOLE_PROXY_TYPE=spicehtml5',
        tag     => 'nova-consoleproxy',
        require => Anchor['nova::config::begin'],
        notify  => Anchor['nova::config::end'],
      }
    }
  }
  nova::generic_service { 'spicehtml5proxy':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::spicehtml5proxy_package_name,
    service_name   => $::nova::params::spicehtml5proxy_service_name,
    ensure_package => $ensure_package,
  }
}
