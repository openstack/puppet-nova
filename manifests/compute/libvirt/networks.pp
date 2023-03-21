# == Class: nova::compute::libvirt::networks
#
# Configures networks managed by libvirt
#
# === Parameters:
#
# [*disable_default_network*]
#   (optional) Whether or not delete the default network.
#   Defaults to true.
#
class nova::compute::libvirt::networks(
  $disable_default_network = true,
) {

  include nova::deps

  validate_legacy(Boolean, 'validate_bool', $disable_default_network)

  if $disable_default_network {
    exec { 'libvirt-default-net-disable-autostart':
      command => 'virsh net-autostart default --disable',
      path    => ['/bin', '/usr/bin'],
      onlyif  => [
        'virsh net-info default 2>/dev/null',
        'virsh net-info default 2>/dev/null | grep -i "^autostart:\s*yes"'
      ]
    }
    exec { 'libvirt-default-net-destroy':
      command => 'virsh net-destroy default',
      path    => ['/bin', '/usr/bin'],
      onlyif  => [
        'virsh net-info default 2>/dev/null',
        'virsh net-info default 2>/dev/null | grep -i "^active:\s*yes"'
      ]
    }

    Service<| tag == 'libvirt-service' |>
      -> Exec['libvirt-default-net-disable-autostart']
      -> Exec['libvirt-default-net-destroy']
      -> Service<| tag == 'nova-service' |>
  }
}
