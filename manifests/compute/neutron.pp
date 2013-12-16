# == Class: nova::compute::neutron
#
# Manage the network driver to use for compute guests
# This will use virtio for VM guests and the
# specified driver for the VIF
#
# === Parameters:
#
# [*libvirt_vif_driver*]
#   (optional) The vif driver to configure the VIFs
#   Defaults to 'nova.virt.libvirt.vif.LibvirtOpenVswitchDriver'
#
class nova::compute::neutron (
  $libvirt_vif_driver = 'nova.virt.libvirt.vif.LibvirtOpenVswitchDriver'
) {

  nova_config {
    'DEFAULT/libvirt_vif_driver':             value => $libvirt_vif_driver;
  }
}
