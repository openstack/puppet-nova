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
# Unit tests for nova::compute::rbd class
#

require 'spec_helper'

describe 'nova::compute::rbd' do

  let :params do
    { :libvirt_rbd_user => 'nova' }
  end

  shared_examples_for 'nova::compute::rbd' do

    it { is_expected.to contain_class('nova::params') }

    it 'configure nova.conf with default parameters' do
        is_expected.to contain_nova_config('libvirt/rbd_secret_uuid').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/images_rbd_pool').with_value('rbd')
        is_expected.to contain_nova_config('libvirt/images_rbd_ceph_conf').with_value('/etc/ceph/ceph.conf')
        is_expected.to contain_nova_config('libvirt/rbd_user').with_value('nova')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_store_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_copy_poll_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_copy_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('libvirt/rbd_connect_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('libvirt/rbd_destroy_volume_retry_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('libvirt/rbd_destroy_volume_retries').with_value('<SERVICE DEFAULT>')
    end

    it 'installs client package' do
      is_expected.to contain_package('ceph-client-package').with(
        'name'   => platform_params[:ceph_client_package],
        'ensure' => 'present',
        'tag'    => ['openstack', 'nova-support-package']
      )
    end

    context 'when overriding default parameters' do
      before :each do
        params.merge!(
          :libvirt_rbd_user                             => 'joe',
          :libvirt_images_rbd_pool                      => 'AnotherPool',
          :libvirt_images_rbd_ceph_conf                 => '/tmp/ceph.conf',
          :libvirt_images_rbd_glance_store_name         => 'glance_rbd_store',
          :libvirt_images_rbd_glance_copy_poll_interval => 30,
          :libvirt_images_rbd_glance_copy_timeout       => 300,
          :libvirt_rbd_connect_timeout                  => 5,
          :libvirt_rbd_destroy_volume_retry_interval    => 5,
          :libvirt_rbd_destroy_volume_retries           => 12,
        )
      end

      it 'configure nova.conf with overridden parameters' do
        is_expected.to contain_nova_config('libvirt/images_rbd_pool').with_value('AnotherPool')
        is_expected.to contain_nova_config('libvirt/images_rbd_ceph_conf').with_value('/tmp/ceph.conf')
        is_expected.to contain_nova_config('libvirt/rbd_user').with_value('joe')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_store_name').with_value('glance_rbd_store')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_copy_poll_interval').with_value(30)
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_copy_timeout').with_value(300)
        is_expected.to contain_nova_config('libvirt/rbd_connect_timeout').with_value(5)
        is_expected.to contain_nova_config('libvirt/rbd_destroy_volume_retry_interval').with_value(5)
        is_expected.to contain_nova_config('libvirt/rbd_destroy_volume_retries').with_value(12)
      end
    end

    context 'when using cephx' do
      before do
        params.merge!(
          :libvirt_rbd_secret_uuid => '4f515eff-47e4-425c-b24d-9c6adc56401c',
          :libvirt_rbd_secret_key  => 'AQBHCbtT6APDHhAA5W00cBchwkQjh3dkKsyPjw==',
        )
      end

      it { is_expected.to contain_nova__compute__libvirt__secret_ceph('4f515eff-47e4-425c-b24d-9c6adc56401c').with(
        :uuid  => '4f515eff-47e4-425c-b24d-9c6adc56401c',
        :value => 'AQBHCbtT6APDHhAA5W00cBchwkQjh3dkKsyPjw==',
      )}
    end

    context 'when using cephx but disabling ephemeral storage' do
      before do
        params.merge!(
          :libvirt_rbd_secret_uuid => '4f515eff-47e4-425c-b24d-9c6adc56401c',
          :libvirt_rbd_secret_key  => 'AQBHCbtT6APDHhAA5W00cBchwkQjh3dkKsyPjw==',
          :ephemeral_storage       => false
        )
      end

      it 'should only set user and secret_uuid in nova.conf ' do
        is_expected.to contain_nova_config('libvirt/images_rbd_pool').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/images_rbd_ceph_conf').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_store_name').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_copy_poll_interval').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/images_rbd_glance_copy_timeout').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/rbd_connect_timeout').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/rbd_destroy_volume_retry_interval').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/rbd_destroy_volume_retries').with_ensure('absent')
        is_expected.to contain_nova_config('libvirt/rbd_user').with_value('nova')
        is_expected.to contain_nova_config('libvirt/rbd_secret_uuid').with_value('4f515eff-47e4-425c-b24d-9c6adc56401c')
      end

      it { is_expected.to contain_nova__compute__libvirt__secret_ceph('4f515eff-47e4-425c-b24d-9c6adc56401c').with(
        :uuid  => '4f515eff-47e4-425c-b24d-9c6adc56401c',
        :value => 'AQBHCbtT6APDHhAA5W00cBchwkQjh3dkKsyPjw==',
      )}
    end

    context 'when not managing ceph client' do
      before :each do
        params.merge!(
          :manage_ceph_client => false
        )
      end

      it { is_expected.to_not contain_package('ceph-client-package') }
    end
  end

  shared_examples_for 'nova::compute::rbd in Debian' do
    it 'should install the qemu-block-extra package' do
      is_expected.to contain_package('qemu-block-extra').with(
        :ensure => 'present',
        :tag    => ['openstack', 'nova-support-package'],
      )
    end
  end

  shared_examples_for 'nova::compute::rbd in RedHat' do
    it 'should not install the qemu-block-extra package' do
      is_expected.to_not contain_package('qemu-block-extra')
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :ceph_client_package => 'ceph-common' }
        when 'RedHat'
          { :ceph_client_package => 'ceph-common' }
        end
      end
      it_configures 'nova::compute::rbd'
      if facts[:os]['family'] == 'Debian'
        it_configures "nova::compute::rbd in #{facts[:os]['family']}"
      end
    end
  end

end
