#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
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
# Unit tests for nova::migration::libvirt class
#

require 'spec_helper'

describe 'nova::migration::libvirt' do

  generate = {}

  before(:each) {
    Puppet::Parser::Functions.newfunction(:generate, :type => :rvalue) {
        |args| generate.call()
    }
    generate.stubs(:call).returns('0000-111-111')
  }

  let :pre_condition do
   'include nova
    include nova::compute
    include nova::compute::libvirt'
  end

  shared_examples_for 'nova migration with libvirt' do

    context 'with default params' do
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tls').with(:line => "listen_tls = 0") }
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tcp').with(:line => "listen_tcp = 1") }
      it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls')}
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp').with(:line => "auth_tcp = \"none\"") }
    end

    context 'with override_uuid enabled' do
      let :params do
        {
          :override_uuid => true,
        }
      end

      it { is_expected.to contain_augeas('libvirt-conf-uuid').with({
        :context => '/files/etc/libvirt/libvirtd.conf',
        :changes => [ "set host_uuid 0000-111-111" ],
      }).that_requires('Package[libvirt]').that_notifies('Service[libvirt]') }
    end

    context 'with tls enabled' do
      let :params do
        {
          :use_tls => true,
        }
      end
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tls').with(:line => "listen_tls = 1") }
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tcp').with(:line => "listen_tcp = 0") }
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls').with(:line => "auth_tls = \"none\"") }
      it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+tls://%s/system')}
    end

    context 'with migration flags set' do
      let :params do
        {
          :live_migration_flag => 'live migration flag',
          :block_migration_flag => 'block migration flag',
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_flag').with(:value => 'live migration flag') }
      it { is_expected.to contain_nova_config('libvirt/block_migration_flag').with(:value => 'block migration flag') }
    end

    context 'with auth set to sasl' do
      let :params do
        {
          :auth => 'sasl',
        }
      end
      it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls')}
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp').with(:line => "auth_tcp = \"sasl\"") }
    end

    context 'with auth set to sasl and tls enabled' do
      let :params do
        {
          :auth    => 'sasl',
          :use_tls => true
        }
      end
      it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls').with(:line => "auth_tls = \"sasl\"") }
      it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp')}
    end

    context 'with auth set to an invalid setting' do
      let :params do
        {
          :auth => 'inexistent_auth',
        }
      end
      it { expect { is_expected.to contain_class('nova::compute::libvirt') }.to \
        raise_error(Puppet::Error, /Valid options for auth are none and sasl./) }
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian' })
    end

    it_configures 'nova migration with libvirt'
    it { is_expected.to contain_file_line('/etc/default/libvirt-bin libvirtd opts').with(:line => 'libvirtd_opts="-d -l"') }
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_configures 'nova migration with libvirt'
    it { is_expected.to contain_file_line('/etc/sysconfig/libvirtd libvirtd args').with(:line => 'LIBVIRTD_ARGS="--listen"') }
  end

end
