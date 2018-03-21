#
# Copyright (C) 2018 Red Hat
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
# == Class: nova::cron::purge_shadow_tables
#
# Clean shadow tables
#
# === Parameters
#
#  [*minute*]
#    (optional) Defaults to '0'.
#
#  [*hour*]
#    (optional) Defaults to '5'.
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
#  [*user*]
#    (optional) User with access to nova files.
#    nova::params::nova_user will be used if this is undef.
#    Defaults to undef.
#
#  [*destination*]
#    (optional) Path to file to which rows should be archived
#    Defaults to '/var/log/nova/nova-rowspurge.log'.
#
#  [*age*]
#    (optional) Adds a retention policy when purging the shadow tables
#    Defaults to 14.
#
#  [*all_cells*]
#    (optional) Adds --all-cells to the purge command
#    Defaults to false.
#
#  [*verbose*]
#    (optional) Adds --verbose to the purge command
#    If specified, will print information about the purged rows.
#

class nova::cron::purge_shadow_tables (
  $minute       = 0,
  $hour         = 5,
  $monthday     = '*',
  $month        = '*',
  $weekday      = '*',
  $user         = undef,
  $destination  = '/var/log/nova/nova-rowspurge.log',
  $age          = 14,
  $all_cells    = false,
  $verbose      = false,
) {

  include ::nova::deps
  include ::nova::params

  if $verbose {
    $verbose_real = '--verbose'
  }
  else {
    $verbose_real = ''
  }

  if $all_cells {
    $all_cells_real = '--all-cells'
  }
  else {
    $all_cells_real = ''
  }

  $cron_cmd = 'nova-manage db purge'

  cron { 'nova-manage db purge':
    command     => "${cron_cmd} --before `date --date='today - ${age} days' +%D` ${verbose_real} ${all_cells_real} >>${destination} 2>&1",
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
