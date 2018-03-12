#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: nova::cron::archive_deleted_rows
#
# Move deleted instances to another table that you don't have to backup
# unless you have data retention policies.
#
# === Parameters
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#
#  [*max_rows*]
#    (optional) Maximum number of deleted rows to archive.
#    Defaults to '100'.
#
#  [*user*]
#    (optional) User with access to nova files.
#    nova::params::nova_user will be used if this is undef.
#    Defaults to undef.
#
#  [*destination*]
#    (optional) Path to file to which rows should be archived
#    Defaults to '/var/log/nova/nova-rowsflush.log'.
#
#  [*until_complete*]
#    (optional) Adds --until-complete to the archive command
#    Defaults to false.
#
#  [*purge*]
#    (optional) Adds --purge to the archive command
#    This option will fully purge shadow table data after
#    archiving, it adds a --purge flag to archive_deleted_rows
#    which will automatically do a full db purge when complete.
#    Defaults to false.
#

class nova::cron::archive_deleted_rows (
  $minute         = 1,
  $hour           = 0,
  $monthday       = '*',
  $month          = '*',
  $weekday        = '*',
  $max_rows       = '100',
  $user           = undef,
  $destination    = '/var/log/nova/nova-rowsflush.log',
  $until_complete = false,
  $purge          = false,
) {

  include ::nova::deps
  include ::nova::params

  if $until_complete {
    $until_complete_real = '--until-complete'
  }
  else {
    $until_complete_real = ''
  }

  if $purge {
    $purge_real = '--purge'
  }
  else {
    $purge_real = ''
  }

  $cron_cmd = 'nova-manage db archive_deleted_rows'

  cron { 'nova-manage db archive_deleted_rows':
    command     => "${cron_cmd} ${purge_real} --max_rows ${max_rows} ${until_complete_real} >>${destination} 2>&1",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => pick($user, $::nova::params::nova_user),
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['nova::dbsync::end']
  }
}
