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
# == Class: nova::db
#
#  Configures the Nova database.
#
# == Parameters
#
# [*database_connection*]
#   (optional) Connection url to connect to nova database.
#   Defaults to $facts['os_service_default']
#
# [*slave_connection*]
#   (optional) Connection url to connect to nova slave database (read-only).
#   Defaults to $facts['os_service_default']
#
# [*database_connection_recycle_time*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $facts['os_service_default']
#
# [*database_db_max_retries*]
#   (optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $facts['os_service_default']
#
# [*mysql_enable_ndb*]
#   (Optional) If True, transparently enables support for handling MySQL
#   Cluster (NDB).
#   Defaults to $facts['os_service_default']
#
# [*api_database_connection*]
#   (optional) Connection url to connect to nova api database.
#   Defaults to $facts['os_service_default']
#
# [*api_slave_connection*]
#   (optional) Connection url to connect to nova api slave database (read-only).
#   Defaults to $facts['os_service_default']
#
# [*api_database_connection_recycle_time*]
#   Timeout when nova api db connections should be reaped.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*api_database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*api_database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*api_database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*api_database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*api_database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $facts['os_service_default']
#
class nova::db (
  $database_connection                  = $facts['os_service_default'],
  $slave_connection                     = $facts['os_service_default'],
  $database_connection_recycle_time     = $facts['os_service_default'],
  $database_max_pool_size               = $facts['os_service_default'],
  $database_max_retries                 = $facts['os_service_default'],
  $database_retry_interval              = $facts['os_service_default'],
  $database_max_overflow                = $facts['os_service_default'],
  $database_pool_timeout                = $facts['os_service_default'],
  $database_db_max_retries              = $facts['os_service_default'],
  $mysql_enable_ndb                     = $facts['os_service_default'],
  $api_database_connection              = $facts['os_service_default'],
  $api_slave_connection                 = $facts['os_service_default'],
  $api_database_connection_recycle_time = $facts['os_service_default'],
  $api_database_max_pool_size           = $facts['os_service_default'],
  $api_database_max_retries             = $facts['os_service_default'],
  $api_database_retry_interval          = $facts['os_service_default'],
  $api_database_max_overflow            = $facts['os_service_default'],
  $api_database_pool_timeout            = $facts['os_service_default'],
) {

  include nova::deps

  oslo::db { 'nova_config':
    db_max_retries          => $database_db_max_retries,
    connection              => $database_connection,
    connection_recycle_time => $database_connection_recycle_time,
    max_pool_size           => $database_max_pool_size,
    max_retries             => $database_max_retries,
    retry_interval          => $database_retry_interval,
    max_overflow            => $database_max_overflow,
    pool_timeout            => $database_pool_timeout,
    mysql_enable_ndb        => $mysql_enable_ndb,
    slave_connection        => $slave_connection,
  }

  oslo::db { 'api_database':
    config                  => 'nova_config',
    config_group            => 'api_database',
    connection              => $api_database_connection,
    slave_connection        => $api_slave_connection,
    connection_recycle_time => $api_database_connection_recycle_time,
    max_pool_size           => $api_database_max_pool_size,
    max_retries             => $api_database_max_retries,
    retry_interval          => $api_database_retry_interval,
    max_overflow            => $api_database_max_overflow,
    pool_timeout            => $api_database_pool_timeout,
  }
}
