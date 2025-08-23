#
# Copyright (C) 2014 OpenStack Foundation
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#         Donald Talton  <dotalton@cisco.com>
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

# == Class: nova::compute::rbd
#
# Configure nova-compute to store virtual machines on RBD
#
# === Parameters
#
# [*libvirt_rbd_user*]
#   (Required) The RADOS client name for accessing rbd volumes.
#
# [*libvirt_rbd_secret_uuid*]
#   (optional) The libvirt uuid of the secret for the rbd_user.
#   Required to use cephx.
#   Default to undef.
#
# [*libvirt_rbd_secret_key*]
#   (optional) The cephx key to use as key for the libvirt secret,
#   it must be base64 encoded; when not provided this key will be
#   requested to the ceph cluster, which assumes the node is
#   provided of the client.admin keyring as well.
#   Default to undef.
#
# [*libvirt_images_rbd_pool*]
#   (optional) The RADOS pool in which rbd volumes are stored.
#   Defaults to 'rbd'.
#
# [*libvirt_images_rbd_ceph_conf*]
#   (optional) The path to the ceph configuration file to use.
#   Defaults to '/etc/ceph/ceph.conf'.
#
# [*libvirt_images_rbd_glance_store_name*]
#   (optional) Name of the Glance store that represents the local rbd cluster.
#   If set, this will allow Nova to request that Glance copy an image from
#   an existing non-local store into the one named by this option before
#   booting so that proper Copy-on-Write behavior is maintained.
#   Defaults to $facts['os_service_default'].
#
# [*libvirt_images_rbd_glance_copy_poll_interval*]
#   (optional) The interval in seconds with which to poll Glance after asking
#   for it to copy an image to the local rbd store.
#   Defaults to $facts['os_service_default'].
#
# [*libvirt_images_rbd_glance_copy_timeout*]
#   (optional) The overall maximum time we will wait for Glance to complete
#   an image copy to our local rbd store.
#   Defaults to $facts['os_service_default'].
#
# [*libvirt_rbd_connect_timeout*]
#   (optional) The RADOS client timeout in seconds when initially connecting
#   to the cluster.
#   Defaults to $facts['os_service_default'].
#
# [*libvirt_rbd_destroy_volume_retry_interval*]
#   (optional) Number of seconds to wait between each consecutive retry to
#   destroy a RBD volume.
#   Defaults to $facts['os_service_default'].
#
# [*libvirt_rbd_destroy_volume_retries*]
#   (optional) Number of retries to destory a RBD volume.
#   Defaults to $facts['os_service_default'].
#
# [*ephemeral_storage*]
#   (optional) Whether or not to use the rbd driver for the nova
#   ephemeral storage or for the cinder volumes only.
#   Defaults to true.
#
# [*manage_ceph_client*]
#  (optional) Whether to manage the ceph client package.
#  Defaults to true.
#
# [*ceph_client_ensure*]
#  (optional) Ensure value for ceph client package.
#  Defaults to 'present'.
#
# [*package_ensure*]
#   (optional) The state of qemu-block-extra package. This parameter has effect
#   only in Ubuntu/Debian.
#   Defaults to 'present'
#
# [*manage_libvirt_secret*]
#   (optional) Manage the libvirt secret
#   Defaults to true
#
class nova::compute::rbd (
  $libvirt_rbd_user,
  $libvirt_rbd_secret_uuid                      = undef,
  $libvirt_rbd_secret_key                       = undef,
  $libvirt_images_rbd_pool                      = 'rbd',
  $libvirt_images_rbd_ceph_conf                 = '/etc/ceph/ceph.conf',
  $libvirt_images_rbd_glance_store_name         = $facts['os_service_default'],
  $libvirt_images_rbd_glance_copy_poll_interval = $facts['os_service_default'],
  $libvirt_images_rbd_glance_copy_timeout       = $facts['os_service_default'],
  $libvirt_rbd_connect_timeout                  = $facts['os_service_default'],
  $libvirt_rbd_destroy_volume_retry_interval    = $facts['os_service_default'],
  $libvirt_rbd_destroy_volume_retries           = $facts['os_service_default'],
  Boolean $ephemeral_storage                    = true,
  Boolean $manage_ceph_client                   = true,
  $ceph_client_ensure                           = 'present',
  $package_ensure                               = 'present',
  Boolean $manage_libvirt_secret                = true,
) {
  include nova::deps
  include nova::params

  if $manage_ceph_client {
    # Install ceph client libraries
    stdlib::ensure_packages( 'ceph-common', {
      ensure => $ceph_client_ensure,
      name   => $nova::params::ceph_common_package_name,
    })
    Package<| title == 'ceph-common' |> { tag +> 'nova-support-package' }
  }

  if $facts['os']['family'] == 'Debian' {
    package { 'qemu-block-extra':
      ensure => $package_ensure,
      tag    => ['openstack', 'nova-support-package'],
    }
  }

  nova_config {
    'libvirt/rbd_user': value => $libvirt_rbd_user;
  }

  if $libvirt_rbd_secret_uuid != undef {
    nova_config {
      'libvirt/rbd_secret_uuid': value => $libvirt_rbd_secret_uuid;
    }

    # TODO(tobias-urdin): Remove these two when propagated
    file { '/etc/nova/secret.xml':
      ensure => 'absent',
    }
    file { '/etc/nova/virsh.secret':
      ensure => 'absent',
    }

    if $manage_libvirt_secret {
      if $libvirt_rbd_secret_key == undef {
        fail('libvirt_rbd_secret_key is required when libvirt_rbd_secret_uuid is set')
      }

      nova::compute::libvirt::secret_ceph { $libvirt_rbd_secret_uuid:
        uuid  => $libvirt_rbd_secret_uuid,
        value => $libvirt_rbd_secret_key,
      }
    }
  } else {
    nova_config {
      'libvirt/rbd_secret_uuid': ensure => absent;
    }
  }

  if $ephemeral_storage {
    if defined('Class[nova::compute::libvirt]') {
      if $nova::compute::libvirt::images_type != 'rbd' {
        fail('nova::compute::libvirt::images_type should be rbd if rbd ephemeral storage is used.')
      }
    }

    nova_config {
      'libvirt/images_rbd_pool':                      value => $libvirt_images_rbd_pool;
      'libvirt/images_rbd_ceph_conf':                 value => $libvirt_images_rbd_ceph_conf;
      'libvirt/images_rbd_glance_store_name':         value => $libvirt_images_rbd_glance_store_name;
      'libvirt/images_rbd_glance_copy_poll_interval': value => $libvirt_images_rbd_glance_copy_poll_interval;
      'libvirt/images_rbd_glance_copy_timeout':       value => $libvirt_images_rbd_glance_copy_timeout;
      'libvirt/rbd_connect_timeout':                  value => $libvirt_rbd_connect_timeout;
      'libvirt/rbd_destroy_volume_retry_interval':    value => $libvirt_rbd_destroy_volume_retry_interval;
      'libvirt/rbd_destroy_volume_retries':           value => $libvirt_rbd_destroy_volume_retries;
    }
  } else {
    nova_config {
      'libvirt/images_rbd_pool':                      ensure => absent;
      'libvirt/images_rbd_ceph_conf':                 ensure => absent;
      'libvirt/images_rbd_glance_store_name':         ensure => absent;
      'libvirt/images_rbd_glance_copy_poll_interval': ensure => absent;
      'libvirt/images_rbd_glance_copy_timeout':       ensure => absent;
      'libvirt/rbd_connect_timeout':                  ensure => absent;
      'libvirt/rbd_destroy_volume_retry_interval':    ensure => absent;
      'libvirt/rbd_destroy_volume_retries':           ensure => absent;
    }
  }
}
