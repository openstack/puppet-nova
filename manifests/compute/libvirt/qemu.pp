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
# [*user*]
#   (optional) User for qemu processes run by the system instance.
#   Defaults to undef.
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
# [*default_tls_verify*]
#   (optional) Enables TLS client cert verification.
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
# [*libvirt_version*]
#   (optional) installed libvirt version. Default is automatic detected depending
#   of the used OS installed via $nova::compute::libvirt::version::default .
#   Defaults to $nova::compute::libvirt::version::default
#
class nova::compute::libvirt::qemu (
  Boolean $configure_qemu     = false,
  $user                       = undef,
  $group                      = undef,
  $max_files                  = 1024,
  $max_processes              = 4096,
  Boolean $vnc_tls            = false,
  Boolean $vnc_tls_verify     = true,
  Boolean $default_tls_verify = true,
  $memory_backing_dir         = undef,
  Boolean $nbd_tls            = false,
  $libvirt_version            = $nova::compute::libvirt::version::default,
) inherits nova::compute::libvirt::version {
  include nova::deps

  if versioncmp($libvirt_version, '4.5') < 0 {
    fail('libvirt version < 4.5 is no longer supported')
  }

  Qemu_config<||> ~> Service<| tag == 'libvirt-qemu-service' |>

  if $configure_qemu {
    if $vnc_tls {
      $vnc_tls_verify_real = $vnc_tls_verify
    } else {
      $vnc_tls_verify_real = false
    }

    qemu_config {
      'max_files':               value => $max_files;
      'max_processes':           value => $max_processes;
      'vnc_tls':                 value => $vnc_tls;
      'vnc_tls_x509_verify':     value => $vnc_tls_verify_real;
      'default_tls_x509_verify': value => $default_tls_verify;
    }

    if $user and !empty($user) {
      qemu_config { 'user': value => $user, quote => true }
    } else {
      qemu_config { 'user': ensure => absent }
    }

    if $group and !empty($group) {
      qemu_config { 'group': value => $group, quote => true }
    } else {
      qemu_config { 'group': ensure => absent }
    }

    if $memory_backing_dir and !empty($memory_backing_dir) {
      qemu_config { 'memory_backing_dir': value => $memory_backing_dir, quote => true }
    } else {
      qemu_config { 'memory_backing_dir': ensure => absent }
    }

    qemu_config { 'nbd_tls': value => $nbd_tls }
  } else {
    qemu_config {
      'max_files':               ensure => absent;
      'max_processes':           ensure => absent;
      'vnc_tls':                 ensure => absent;
      'vnc_tls_x509_verify':     ensure => absent;
      'default_tls_x509_verify': ensure => absent;
      'user':                    ensure => absent;
      'group':                   ensure => absent;
      'memory_backing_dir':      ensure => absent;
      'nbd_tls':                 ensure => absent;
    }
  }
}
