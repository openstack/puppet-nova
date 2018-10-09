# == Class: nova::compute::libvirt::qemu
#
# Configures qemu limits for use by libvirt
#
# === Parameters:
#
# [*configure_qemu*]
#   (optional) Whether or not configure qemu bits.
#   Defaults to false.
#
# [*group*]
#   (optional) Group under which the qemu should run.
#   Defaults to undef.
#
# [*max_files*]
#   (optional) Maximum number of opened files, per process.
#   Defaults to 1024.
#
# [*max_processes*]
#   (optional) Maximum number of processes that can be run by qemu user.
#   Defaults to 4096.
#
# [*vnc_tls*]
#   (optional) Enables TLS for vnc connections.
#   Defaults to false.
#
# [*vnc_tls_verify*]
#   (optional) Enables TLS client cert verification when vnc_tls is enabled.
#   Defaults to true.
#
# [*memory_backing_dir*]
#   (optional) This directory is used for memoryBacking source if configured as file.
#   NOTE: big files will be stored here
#   Defaults to undef.
#
# [*nbd_tls*]
#   (optional) Enables TLS for nbd connections.
#   Defaults to false.
#
class nova::compute::libvirt::qemu(
  $configure_qemu     = false,
  $group              = undef,
  $max_files          = 1024,
  $max_processes      = 4096,
  $vnc_tls            = false,
  $vnc_tls_verify     = true,
  $memory_backing_dir = undef,
  $nbd_tls            = false
){

  include ::nova::deps
  require ::nova::compute::libvirt

  Anchor['nova::config::begin']
  -> Augeas<| tag == 'qemu-conf-augeas'|>
  -> Anchor['nova::config::end']

  Augeas<| tag == 'qemu-conf-augeas'|>
  ~> Service['libvirt']

  if $configure_qemu {

    if $vnc_tls {
      $vnc_tls_value = 1
      $vnc_tls_verify_value = $vnc_tls_verify ? { true => 1, false => 0 }
    } else {
      $vnc_tls_value = 0
      $vnc_tls_verify_value = 0
    }

    if $nbd_tls {
      $nbd_tls_value = 1
    } else {
      $nbd_tls_value = 0
    }

    $augues_changes_default = [
      "set max_files ${max_files}",
      "set max_processes ${max_processes}",
      "set vnc_tls ${vnc_tls_value}",
      "set vnc_tls_x509_verify ${vnc_tls_verify_value}",
      "set nbd_tls ${nbd_tls_value}"
    ]
    if $group and !empty($group) {
      $augues_group_changes = ["set group ${group}"]
    } else {
      $augues_group_changes = []
    }
    if $memory_backing_dir and !empty($memory_backing_dir) {
      $augues_memory_backing_dir_changes = ["set memory_backing_dir ${memory_backing_dir}"]
    } else {
      $augues_memory_backing_dir_changes = []
    }
    $augues_changes = concat($augues_changes_default, $augues_group_changes, $augues_memory_backing_dir_changes)

    augeas { 'qemu-conf-limits':
      context => '/files/etc/libvirt/qemu.conf',
      changes => $augues_changes,
      tag     => 'qemu-conf-augeas',
    }
  } else {
    augeas { 'qemu-conf-limits':
      context => '/files/etc/libvirt/qemu.conf',
      changes => [
        'rm max_files',
        'rm max_processes',
        'rm group',
        'rm vnc_tls',
        'rm vnc_tls_x509_verify',
        'rm memory_backing_dir',
        'rm nbd_tls'
      ],
      tag     => 'qemu-conf-augeas',
    }
  }
}
