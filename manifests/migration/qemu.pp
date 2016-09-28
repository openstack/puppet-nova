# == Class: nova::migration::qemu
#
# Sets qemu config that is required for migration
#
# === Parameters:
#
# [*configure_qemu*]
#   (optional) Whether or not configure qemu bits.
#   Defaults to false.
#
# [*migration_port_min*]
#   (optional) Lower limit of port range used for migration.
#   Defaults to 49152.
#
# [*migration_port_max*]
#   (optional) Higher limit of port range used for migration.
#   Defaults to 49215.
#
class nova::migration::qemu(
  $configure_qemu     = false,
  $migration_port_min = 49152,
  $migration_port_max = 49215,
){

  include ::nova::deps

  Anchor['nova::config::begin']
  -> Augeas<| tag == 'qemu-conf-augeas'|>
  -> Anchor['nova::config::end']

  Augeas<| tag == 'qemu-conf-augeas'|>
  ~> Service['libvirt']

  if $configure_qemu {

    augeas { 'qemu-conf-migration-ports':
      context => '/files/etc/libvirt/qemu.conf',
      changes => [
        "set migration_port_min ${migration_port_min}",
        "set migration_port_max ${migration_port_max}",
      ],
      tag     => 'qemu-conf-augeas',
    }
  } else {
    augeas { 'qemu-conf-migration-ports':
      context => '/files/etc/libvirt/qemu.conf',
      changes => [
        'rm migration_port_min',
        'rm migration_port_max',
      ],
      tag     => 'qemu-conf-augeas',
    }
  }
}
