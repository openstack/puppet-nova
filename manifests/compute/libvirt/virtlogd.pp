# == Class: nova::compute::libvirt::virtlogd
#
# virtlogd configuration
#
# === Parameters:
#
# [*log_level*]
#   Defines a log level to filter log outputs.
#   Defaults to undef
#
# [*log_filters*]
#   Defines a log filter to select a different logging level for
#   for a given category log outputs.
#   Defaults to undef
#
# [*log_outputs*]
#   (optional) Defines log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to undef
#
# [*max_clients*]
#   The maximum number of concurrent client connections to allow
#   on primary socket.
#   Defaults to undef
#
# [*admin_max_clients*]
#   The maximum number of concurrent client connections to allow
#   on administrative socket.
#   Defaults to undef
#
# [*max_size*]
#   Maximum file size before rolling over.
#   Defaults to undef
#
# [*max_backups*]
#   Maximum nuber of backup files to keep.
#   Defaults to undef
#
class nova::compute::libvirt::virtlogd (
  $log_level         = undef,
  $log_filters       = undef,
  $log_outputs       = undef,
  $max_clients       = undef,
  $admin_max_clients = undef,
  $max_size          = undef,
  $max_backups       = undef,
) {

  include nova::deps
  require nova::compute::libvirt

  if $log_level {
    virtlogd_config {
      'log_level': value => $log_level;
    }
  }
  else {
    virtlogd_config {
      'log_level': ensure => 'absent';
    }
  }

  if $log_filters {
    virtlogd_config {
      'log_filters': value => "\"${log_filters}\"";
    }
  }
  else {
    virtlogd_config {
      'log_filters': ensure => 'absent';
    }
  }

  if $log_outputs {
    virtlogd_config {
      'log_outputs': value => "\"${log_outputs}\"";
    }
  }
  else {
    virtlogd_config {
      'log_outputs': ensure => 'absent';
    }
  }

  if $max_clients {
    virtlogd_config {
      'max_clients': value => $max_clients;
    }
  }
  else {
    virtlogd_config {
      'max_clients': ensure => 'absent';
    }
  }

  if $admin_max_clients {
    virtlogd_config {
      'admin_max_clients': value => $admin_max_clients;
    }
  }
  else {
    virtlogd_config {
      'admin_max_clients': ensure => 'absent';
    }
  }

  if $max_size {
    virtlogd_config {
      'max_size': value => $max_size;
    }
  }
  else {
    virtlogd_config {
      'max_size': ensure => 'absent';
    }
  }

  if $max_backups {
    virtlogd_config {
      'max_backups': value => $max_backups;
    }
  }
  else {
    virtlogd_config {
      'max_backups': ensure => 'absent';
    }
  }

  Anchor['nova::config::begin']
  -> Virtlogd_config<||>
  -> Anchor['nova::config::end']
}
