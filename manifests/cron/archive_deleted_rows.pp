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
#    Defaults to $::nova::params::user.
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
#  [*age*]
#    (optional) Adds a retention policy when purging the shadow tables
#    Defaults to undef.
#
#  [*all_cells*]
#    (optional) Adds --all-cells to the archive command
#    Defaults to false.
#
#  [*task_log*]
#    (optional) Adds --task-log to the archive command
#    Defaults to false.
#
#  [*sleep*]
#    (optional) The amount of time in seconds to sleep between batches when
#    until_complete is used
#    Defaults to undef.
#
#  [*verbose*]
#    (optional) Adds --verbose to the purge command
#    If specified, will print information about the archived rows.
#    Defaults to false.
#
#  [*maxdelay*]
#    (optional) In Seconds. Should be a positive integer.
#    Induces a random delay before running the cronjob to avoid running
#    all cron jobs at the same time on all hosts this job is configured.
#    Defaults to 0.
#
class nova::cron::archive_deleted_rows (
  $minute         = 1,
  $hour           = 0,
  $monthday       = '*',
  $month          = '*',
  $weekday        = '*',
  $max_rows       = '100',
  $user           = $::nova::params::user,
  $destination    = '/var/log/nova/nova-rowsflush.log',
  $until_complete = false,
  $purge          = false,
  $age            = undef,
  $all_cells      = false,
  $task_log       = false,
  $sleep          = undef,
  $verbose        = false,
  $maxdelay       = 0,
) inherits nova::params {

  include nova::deps

  if $until_complete {
    $until_complete_real = ' --until-complete'
  }
  else {
    $until_complete_real = ''
  }

  if $purge {
    $purge_real = ' --purge'
  }
  else {
    $purge_real = ''
  }

  if $verbose {
    $verbose_real = ' --verbose'
  }
  else {
    $verbose_real = ''
  }

  if $all_cells {
    $all_cells_real = ' --all-cells'
  }
  else {
    $all_cells_real = ''
  }

  if $task_log {
    $task_log_real = ' --task-log'
  }
  else {
    $task_log_real = ''
  }

  if $maxdelay == 0 {
    $delay_cmd = ''
  } else {
    $delay_cmd = "sleep `expr \${RANDOM} \\% ${maxdelay}`; "
  }

  if $age {
    $age_real = " --before `date --date=\'today - ${age} days\' +\\%F`"
  } else {
    $age_real = ''
  }

  if $sleep != undef {
    $sleep_real = " --sleep ${sleep}"
  } else {
    $sleep_real = ''
  }

  $cron_cmd = 'nova-manage db archive_deleted_rows'

  cron { 'nova-manage db archive_deleted_rows':
    # lint:ignore:140chars
    command     => "${delay_cmd}${cron_cmd}${purge_real} --max_rows ${max_rows}${verbose_real}${age_real}${until_complete_real}${all_cells_real}${task_log_real}${sleep_real} >>${destination} 2>&1",
    # lint:endignore
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => $user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['nova::dbsync::end']
  }
}
