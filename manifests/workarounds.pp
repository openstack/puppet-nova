# == Class: nova::workarounds
#
# nova workarounds configuration
#
# === Parameters:
#
# [*never_download_image_if_on_rbd*]
#  (Optional) refuse to boot an instance if it would require downloading from
#  glance and uploading to ceph instead of a COW clone
#  Defaults to $facts['os_service_default']
#
# [*ensure_libvirt_rbd_instance_dir_cleanup*]
#  (Optional) Ensure the instance directory is removed during clean up when using
#  rbd. When enabled this workaround will ensure that the instance directory is
#  always removed during cleanup on hosts using ``[libvirt]/images_type=rbd``
#  Defaults to $facts['os_service_default']
#
# [*enable_qemu_monitor_announce_self*]
#   (Optional) If it is set to True the libvirt driver will try as a best effort to
#   send the announce-self command to the QEMU monitor so that it generates RARP frames
#   to update network switches in the post live migration phase on the destination.
#   Defaults to $facts['os_service_default']
#
# [*qemu_monitor_announce_self_count*]
#   (Optional) The total number of times to send the announce_self command to
#   the QEMU monitor when enable_qemu_monitor_announce_self is enabled.
#   Defaults to $facts['os_service_default']
#
# [*qemu_monitor_announce_self_interval*]
#   (Optional) The number of seconds to wait before re-sending the announce_self
#   command to the QEMU monitor.
#   Defaults to $facts['os_service_default']
#
# [*wait_for_vif_plugged_event_during_hard_reboot*]
#   (Optional) If set Nova will wait for the Neutron ML2 backend to sent vif
#   plugged events when performing hard reboot.
#   Defaults to $facts['os_service_default']
#
# [*disable_compute_service_check_for_ffu*]
#   (Optional) If this is set, the normal safety check for old compute services will
#   be treated as a warning instead of an error. This is only to be enabled to
#   facilitate a Fast-Forward upgrade where new control services are being started
#   before compute nodes have been able to update their service record.
#   Defaults to $facts['os_service_default']
#
# [*skip_hypervisor_version_check_on_lm*]
#   (Optional) When this is enabled, it will skip version-checking of
#   hypervisors during live migration.
#   Defaults to $facts['os_service_default']
#
# [*skip_cpu_compare_on_dest*]
#   (Optional) With the libvirt driver, during live migration, skip comparing guest CPU
#   with the destination host. When using QEMU >= 2.9 and libvirt >=
#   4.4.0, libvirt will do the correct thing with respect to checking CPU
#   compatibility on the destination host during live migration.
#   Defaults to $facts['os_service_default']
#
# [*skip_cpu_compare_at_startup*]
#   (Optional) This will skip the CPU comparison call at the startup of Compute
#   service and lets libvirt handle it.
#   Defaults to $facts['os_service_default']
#
# DEPRECATED
#
#  [*enable_numa_live_migration*]
#   (optional) Whether to enable live migration for NUMA topology instances.
#   Defaults to undef
#
class nova::workarounds (
  $never_download_image_if_on_rbd                = $facts['os_service_default'],
  $ensure_libvirt_rbd_instance_dir_cleanup       = $facts['os_service_default'],
  $enable_qemu_monitor_announce_self             = $facts['os_service_default'],
  $qemu_monitor_announce_self_count              = $facts['os_service_default'],
  $qemu_monitor_announce_self_interval           = $facts['os_service_default'],
  $wait_for_vif_plugged_event_during_hard_reboot = $facts['os_service_default'],
  $disable_compute_service_check_for_ffu         = $facts['os_service_default'],
  $skip_hypervisor_version_check_on_lm           = $facts['os_service_default'],
  $skip_cpu_compare_on_dest                      = $facts['os_service_default'],
  $skip_cpu_compare_at_startup                   = $facts['os_service_default'],
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
    'workarounds/qemu_monitor_announce_self_count':
      value => $qemu_monitor_announce_self_count;
    'workarounds/qemu_monitor_announce_self_interval':
      value => $qemu_monitor_announce_self_interval;
    'workarounds/wait_for_vif_plugged_event_during_hard_reboot':
      value => join(any2array($wait_for_vif_plugged_event_during_hard_reboot), ',');
    'workarounds/disable_compute_service_check_for_ffu':
      value => $disable_compute_service_check_for_ffu;
    'workarounds/skip_hypervisor_version_check_on_lm':
      value => $skip_hypervisor_version_check_on_lm;
    'workarounds/skip_cpu_compare_on_dest':
      value => $skip_cpu_compare_on_dest;
    'workarounds/skip_cpu_compare_at_startup':
      value => $skip_cpu_compare_at_startup;
  }

}
