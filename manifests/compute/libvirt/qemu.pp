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
# [*max_files*]
#   (optional) Maximum number of opened files, per process.
#   Defaults to 1024.
#
# [*max_processes*]
#   (optional) Maximum number of processes that can be run by qemu user.
#   Defaults to 4096.
#
class nova::compute::libvirt::qemu(
  $configure_qemu = false,
  $max_files      = 1024,
  $max_processes  = 4096,
){

  include ::nova::deps
  require ::nova::compute::libvirt

  Anchor['nova::config::begin']
  -> Augeas<| tag == 'qemu-conf-augeas'|>
  -> Anchor['nova::config::end']

  Augeas<| tag == 'qemu-conf-augeas'|>
  ~> Service['libvirt']

  if $configure_qemu {

    augeas { 'qemu-conf-limits':
      context => '/files/etc/libvirt/qemu.conf',
      changes => [
        "set max_files ${max_files}",
        "set max_processes ${max_processes}",
      ],
      tag     => 'qemu-conf-augeas',
    }
  } else {
    augeas { 'qemu-conf-limits':
      context => '/files/etc/libvirt/qemu.conf',
      changes => [
        'rm max_files',
        'rm max_processes',
      ],
      tag     => 'qemu-conf-augeas',
    }
  }
}
