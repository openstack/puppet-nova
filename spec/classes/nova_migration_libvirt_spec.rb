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
  # needed for Puppet 4.x
  before(:each) {
    Puppet::Parser::Functions.newfunction(:generate, :type => :rvalue) {
        |args| generate.call()
    }
    generate.stubs(:call).returns('0000-111-111')
  }

  # function here is needed for Puppet 5.5.7+
  let :pre_condition do
   'function generate($a, $b) { return "0000-111-111" }
    include nova
    include nova::compute
    include nova::compute::libvirt'
  end

  shared_examples_for 'nova migration with libvirt' do

    context 'with default params' do
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('0') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('1') }
      it { is_expected.not_to contain_libvirtd_config('auth_tls') }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value("\"none\"") }
      it { is_expected.to contain_nova_config('libvirt/live_migration_tunnelled').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_completion_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+tcp://%s/system') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_inbound_addr').with_value('<SERVICE DEFAULT>')}
    end

    context 'with override_uuid enabled' do
      let :params do
        {
          :override_uuid => true,
        }
      end

      it { is_expected.to contain_file('/etc/libvirt/libvirt_uuid').with({
        :content => '0000-111-111',
      }).that_requires('Package[libvirt]') }

      it { is_expected.to contain_augeas('libvirt-conf-uuid').with({
        :context => '/files/etc/libvirt/libvirtd.conf',
        :changes => [ "set host_uuid 0000-111-111" ],
      }).that_requires('Package[libvirt]').that_notifies('Service[libvirt]') }
    end

    context 'with tls enabled (legacy)' do
      let :params do
        {
          :use_tls => true,
        }
      end
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('1') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('0') }
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value("\"none\"") }
      it { is_expected.not_to contain_libvirtd_config('auth_tcp') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+tls://%s/system')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_inbound_addr').with_value('<SERVICE DEFAULT>')}
    end

    context 'with tls enabled' do
      let :params do
        {
          :transport => 'tls',
        }
      end
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('1') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('0') }
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value("\"none\"") }
      it { is_expected.not_to contain_libvirtd_config('auth_tcp') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+tls://%s/system')}
    end

    context 'with tls enabled and inbound addr set' do
      let :params do
        {
          :transport                   => 'tls',
          :live_migration_inbound_addr => 'host1.example.com',
        }
      end
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('1') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('0') }
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value("\"none\"") }
      it { is_expected.not_to contain_libvirtd_config('auth_tcp') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+tls://%s/system')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_inbound_addr').with_value('host1.example.com')}
    end

    context 'with migration flags set' do
      let :params do
        {
          :live_migration_tunnelled          => true,
          :live_migration_completion_timeout => '1500',
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_tunnelled').with(:value => true) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_completion_timeout').with_value('1500') }
    end

    context 'with auth set to sasl' do
      let :params do
        {
          :auth => 'sasl',
        }
      end
      it { is_expected.not_to contain_libvirtd_config('auth_tls') }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value("\"sasl\"") }
    end

    context 'with auth set to sasl and tls enabled' do
      let :params do
        {
          :auth    => 'sasl',
          :transport => 'tls'
        }
      end
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value("\"sasl\"") }
      it { is_expected.not_to contain_libvirtd_config('auth_tcp') }
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

    context 'when not configuring libvirt' do
      let :params do
        {
          :configure_libvirt => false
        }
      end
      it { is_expected.not_to contain_libvirtd_config('listen_tls') }
      it { is_expected.not_to contain_libvirtd_config('listen_tcp') }
    end

    context 'when not configuring nova and tls enabled' do
      let :params do
        {
          :configure_nova => false,
          :transport      => 'tls',
        }
      end
      it { is_expected.not_to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+tls://%s/system') }
    end

    context 'with listen_address set' do
      let :params do
        {
          :listen_address => "127.0.0.1"
        }
      end
      it { is_expected.to contain_libvirtd_config('listen_addr').with_value("\"127.0.0.1\"") }
    end

    context 'with ssh transport' do
      let :params do
        {
          :transport => 'ssh',
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://%s/system')}
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('0') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('0') }
    end

    context 'with ssh transport with user' do
      let :params do
        {
          :transport => 'ssh',
          :client_user => 'foobar'
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://foobar@%s/system')}
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('0') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('0') }
    end

    context 'with ssh transport with port' do
      let :params do
        {
          :transport => 'ssh',
          :client_port => 1234
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://%s:1234/system')}
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('0') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('0') }
    end

    context 'with ssh transport with extraparams' do
      let :params do
        {
          :transport => 'ssh',
          :client_extraparams => {'foo' => '%', 'bar' => 'baz'}
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://%s/system?foo=%%25&bar=baz')}
      it { is_expected.to contain_libvirtd_config('listen_tls').with_value('0') }
      it { is_expected.to contain_libvirtd_config('listen_tcp').with_value('0') }
    end

  end

  # TODO (degorenko): switch to on_supported_os function when we got Xenial
  context 'on Debian platforms with Ubuntu release 16' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemmajrelease => '16'
      })
    end

    it_configures 'nova migration with libvirt'
    it { is_expected.to contain_file_line('/etc/default/libvirtd libvirtd opts').with(:line => 'libvirtd_opts="-l"') }
  end

  context 'on Debian platforms release' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemmajrelease => '8'
      })
    end

    it_configures 'nova migration with libvirt'
    it { is_expected.to contain_file_line('/etc/default/libvirtd libvirtd opts').with(:line => 'libvirtd_opts="-d -l"') }
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
        :operatingsystemmajrelease => '7.0'
      })
    end

    it_configures 'nova migration with libvirt'
    it { is_expected.to contain_file_line('/etc/sysconfig/libvirtd libvirtd args').with(:line => 'LIBVIRTD_ARGS="--listen"') }
  end

end
