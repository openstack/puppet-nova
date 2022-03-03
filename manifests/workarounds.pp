# == Class: nova::workarounds
#
# nova workarounds configuration
#
# === Parameters:
#
# [*never_download_image_if_on_rbd*]
#  (Optional) refuse to boot an instance if it would require downloading from
#  glance and uploading to ceph instead of a COW clone
#  Defaults to $::os_service_default
#
# [*ensure_libvirt_rbd_instance_dir_cleanup*]
#  (Optional) Ensure the instance directory is removed during clean up when using
#  rbd. When enabled this workaround will ensure that the instance directory is
#  always removed during cleanup on hosts using ``[libvirt]/images_type=rbd``
#  Defaults to $::os_service_default
#
# [*enable_qemu_monitor_announce_self*]
#   (Optional) If it is set to True the libvirt driver will try as a best effort to
#   send the announce-self command to the QEMU monitor so that it generates RARP frames
#   to update network switches in the post live migration phase on the destination.
#   Defaults to $::os_service_default
#
# [*wait_for_vif_plugged_event_during_hard_reboot*]
#   (Optional) If set Nova will wait for the Neutron ML2 backend to sent vif
#   plugged events when performing hard reboot.
#   Defaults to $::os_service_default
#
# [*disable_compute_service_check_for_ffu*]
#   (Optional) If this is set, the normal safety check for old compute services will
#   be treated as a warning instead of an error. This is only to be enabled to
#   facilitate a Fast-Forward upgrade where new control services are being started
#   before compute nodes have been able to update their service record.
#   Defaults to $::os_service_default
#
# DEPRECATED
#
#  [*enable_numa_live_migration*]
#   (optional) Whether to enable live migration for NUMA topology instances.
#   Defaults to undef
#
class nova::workarounds (
  $never_download_image_if_on_rbd                = $::os_service_default,
  $ensure_libvirt_rbd_instance_dir_cleanup       = $::os_service_default,
  $enable_qemu_monitor_announce_self             = $::os_service_default,
  $wait_for_vif_plugged_event_during_hard_reboot = $::os_service_default,
  $disable_compute_service_check_for_ffu         = $::os_service_default,
  # DEPRECATED PARAMETER
  $enable_numa_live_migration              = undef,
) {

  if $enable_numa_live_migration != undef {
    warning('The enable_numa_live_migration parameter is deprecated')
    nova_config {
      'workarounds/enable_numa_live_migration': value => $enable_numa_live_migration;
    }
  }

  nova_config {
    'workarounds/never_download_image_if_on_rbd':
      value => $never_download_image_if_on_rbd;
    'workarounds/ensure_libvirt_rbd_instance_dir_cleanup':
      value => $ensure_libvirt_rbd_instance_dir_cleanup;
    'workarounds/enable_qemu_monitor_announce_self':
      value => $enable_qemu_monitor_announce_self;
    'workarounds/wait_for_vif_plugged_event_during_hard_reboot':
      value => join(any2array($wait_for_vif_plugged_event_during_hard_reboot), ',');
    'workarounds/disable_compute_service_check_for_ffu':
      value => $disable_compute_service_check_for_ffu;
  }

}
