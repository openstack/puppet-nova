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

  # function here is needed for Puppet 5.5.7+
  let :pre_condition do
   'function generate($a, $b) { return "0000-111-111" }
    include nova
    include nova::compute
    include nova::compute::libvirt'
  end

  shared_examples_for 'nova migration with libvirt' do

    context 'with default params' do
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value('none').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('key_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('cert_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_nova_config('libvirt/migration_inbound_addr').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_tunnelled').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_with_native_tls').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_bandwidth').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_downtime').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_downtime_steps').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_downtime_delay').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_completion_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_timeout_action').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_inbound_addr').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('tcp') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_permit_post_copy').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_permit_auto_converge').with_value('<SERVICE DEFAULT>')}
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

      it { is_expected.to contain_libvirtd_config('host_uuid').with_value('0000-111-111').with_quote(true) }
    end

    context 'with override_uuid enabled and host_uuid set' do
      let :params do
        {
          :override_uuid => true,
          :host_uuid     => 'a8debd9d-e359-4bb2-8c77-edee431f94f2',
        }
      end

      it { is_expected.to contain_file('/etc/libvirt/libvirt_uuid').with({
        :content => 'a8debd9d-e359-4bb2-8c77-edee431f94f2',
      }).that_requires('Package[libvirt]') }

      it { is_expected.to contain_libvirtd_config('host_uuid').with_value('a8debd9d-e359-4bb2-8c77-edee431f94f2').with_quote(true) }
    end

    context 'with tls enabled' do
      let :params do
        {
          :transport => 'tls',
        }
      end
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value('none').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('key_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('cert_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('tls') }
    end

    context 'with tls enabled and inbound addr set' do
      let :params do
        {
          :transport                   => 'tls',
          :migration_inbound_addr      => 'host2.example.com',
          :live_migration_inbound_addr => 'host1.example.com',
        }
      end
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value('none').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_nova_config('libvirt/migration_inbound_addr').with_value('host2.example.com')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_inbound_addr').with_value('host1.example.com')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('tls') }
    end

    context 'with live_migration_with_native_tls flags set' do
      let :params do
        {
          :live_migration_with_native_tls => true,
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_with_native_tls').with(:value => true) }
    end

    context 'with migration flags set' do
      let :params do
        {
          :live_migration_tunnelled          => true,
          :live_migration_bandwidth          => 1024,
          :live_migration_downtime           => 800,
          :live_migration_downtime_steps     => 15,
          :live_migration_downtime_delay     => 5,
          :live_migration_completion_timeout => '1500',
          :live_migration_timeout_action     => 'force_complete',
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_tunnelled').with(:value => true) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_bandwidth').with_value(1024) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_downtime').with_value(800) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_downtime_steps').with_value(15) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_downtime_delay').with_value(5) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_completion_timeout').with_value('1500') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_timeout_action').with_value('force_complete') }
    end

    context 'with live migration auto converge on' do
      let :params do
        {
          :live_migration_permit_post_copy     => false,
          :live_migration_permit_auto_converge => true,
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_permit_post_copy').with(:value => false) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_permit_auto_converge').with(:value => true) }
    end

    context 'with auth set to sasl' do
      let :params do
        {
          :auth => 'sasl',
        }
      end
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value('sasl').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('key_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('cert_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
    end

    context 'with auth set to sasl and tls enabled' do
      let :params do
        {
          :auth      => 'sasl',
          :transport => 'tls'
        }
      end
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value('sasl').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('key_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('cert_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
    end

    context 'with certificates set and tls enabled' do
      let :params do
        {
          :transport => 'tls',
          :key_file  => '/etc/pki/libvirt/private/serverkey.pem',
          :cert_file => '/etc/pki/libvirt/servercert.pem',
          :ca_file   => '/etc/pki/CA/cacert.pem',
          :crl_file  => '/etc/pki/CA/crl.pem',
        }
      end
      it { is_expected.to contain_libvirtd_config('auth_tls').with_value('none').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('auth_tcp').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('key_file').with_value('/etc/pki/libvirt/private/serverkey.pem').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('cert_file').with_value('/etc/pki/libvirt/servercert.pem').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('ca_file').with_value('/etc/pki/CA/cacert.pem').with_quote(true) }
      it { is_expected.to contain_libvirtd_config('crl_file').with_value('/etc/pki/CA/crl.pem').with_quote(true) }
    end

    context 'with auth set to an invalid setting' do
      let :params do
        {
          :auth => 'inexistent_auth',
        }
      end
      it { expect { is_expected.to contain_class('nova::compute::libvirt') }.to \
        raise_error(Puppet::Error) }
    end

    context 'when not configuring libvirt' do
      let :params do
        {
          :configure_libvirt => false
        }
      end
      it { is_expected.to_not contain_libvirtd_config('auth_tls') }
      it { is_expected.to_not contain_libvirtd_config('auth_tcp') }
      it { is_expected.to_not contain_libvirtd_config('ca_file') }
      it { is_expected.to_not contain_libvirtd_config('crl_file') }
    end

    context 'when not configuring nova and tls enabled' do
      let :params do
        {
          :configure_nova => false,
          :transport      => 'tls',
        }
      end
      it { is_expected.not_to contain_nova_config('libvirt/live_migration_uri') }
      it { is_expected.not_to contain_nova_config('libvirt/live_migration_inbound_addr') }
      it { is_expected.not_to contain_nova_config('libvirt/live_migration_scheme') }
    end

    context 'with ssh transport' do
      let :params do
        {
          :transport => 'ssh',
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('ssh') }
    end

    context 'with ssh transport with user' do
      let :params do
        {
          :transport   => 'ssh',
          :client_user => 'foobar'
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://foobar@%s/system')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('<SERVICE DEFAULT>') }
    end

    context 'with ssh transport with port' do
      let :params do
        {
          :transport   => 'ssh',
          :client_port => 1234
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://%s:1234/system')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('<SERVICE DEFAULT>') }
    end

    context 'with ssh transport with extraparams' do
      let :params do
        {
          :transport          => 'ssh',
          :client_extraparams => {'foo' => '%', 'bar' => 'baz'}
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://%s/system?foo=%%25&bar=baz')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('<SERVICE DEFAULT>') }
    end

    context 'with tls transport' do
      let :params do
        { :transport => 'tls' }
      end

      it { is_expected.to contain_service('libvirtd-tls').with(
        :name   => 'libvirtd-tls.socket',
        :ensure => 'running',
        :enable => true,
      )}
      it { is_expected.to contain_file('/etc/systemd/system/libvirtd-tls.socket').with(
        :ensure => 'absent',
      )}
    end

    context 'with tcp transport' do
      let :params do
        {
          :transport      => 'tcp',
          :listen_address => '127.0.0.1'
        }
      end

      it { is_expected.to contain_service('libvirtd-tcp').with(
        :name   => 'libvirtd-tcp.socket',
        :ensure => 'running',
        :enable => true,
      )}
      it { is_expected.to contain_file_line('libvirtd-tcp.socket ListenStream').with(
        :path  => '/etc/systemd/system/libvirtd-tcp.socket',
        :line  => 'ListenStream=127.0.0.1:16509',
        :match => '^ListenStream=.*',
      )}
    end
  end

  shared_examples_for 'nova migration with modular libvirt' do
    context 'with modular_libvirt set to true' do
      let(:params) { { :modular_libvirt => true} }

      it { is_expected.to contain_virtproxyd_config('auth_tls').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('auth_tcp').with_value('none').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_tunnelled').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_with_native_tls').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_completion_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_timeout_action').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_inbound_addr').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('tcp') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_permit_post_copy').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_permit_auto_converge').with_value('<SERVICE DEFAULT>')}
    end

    context 'with tls enabled' do
      let :params do
        {
          :transport => 'tls',
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_virtproxyd_config('auth_tls').with_value('none').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('auth_tcp').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('tls') }
    end

    context 'with auth set to sasl' do
      let :params do
        {
          :auth => 'sasl',
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_virtproxyd_config('auth_tls').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('auth_tcp').with_value('sasl').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
    end

    context 'with auth set to sasl and tls enabled' do
      let :params do
        {
          :auth            => 'sasl',
          :transport       => 'tls',
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_virtproxyd_config('auth_tls').with_value('sasl').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('auth_tcp').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('ca_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('crl_file').with_value('<SERVICE DEFAULT>').with_quote(true) }
    end

    context 'with certificates set and tls enabled' do
      let :params do
        {
          :transport       => 'tls',
          :ca_file         => '/ca',
          :crl_file        => '/crl',
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_virtproxyd_config('auth_tls').with_value('none').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('auth_tcp').with_value('<SERVICE DEFAULT>').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('ca_file').with_value('/ca').with_quote(true) }
      it { is_expected.to contain_virtproxyd_config('crl_file').with_value('/crl').with_quote(true) }
    end

    context 'with ssh transport' do
      let :params do
        {
          :transport       => 'ssh',
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('ssh') }
    end

    context 'with ssh transport with user' do
      let :params do
        {
          :transport => 'ssh',
          :client_user => 'foobar',
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://foobar@%s/system')}
      it { is_expected.to contain_nova_config('libvirt/live_migration_scheme').with_value('<SERVICE DEFAULT>') }
    end

    context 'with ssh transport with port' do
      let :params do
        {
          :transport       => 'ssh',
          :client_port     => 1234,
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://%s:1234/system')}
    end

    context 'with ssh transport with extraparams' do
      let :params do
        {
          :transport => 'ssh',
          :client_extraparams => {'foo' => '%', 'bar' => 'baz'},
          :modular_libvirt => true,
        }
      end
      it { is_expected.to contain_nova_config('libvirt/live_migration_uri').with_value('qemu+ssh://%s/system?foo=%%25&bar=baz')}
    end

    context 'with tls transport' do
      let :params do
        {
          :transport       => 'tls',
          :modular_libvirt => true,
          :listen_address  => '::1'
        }
      end

      it { is_expected.to contain_service('virtproxyd-tls').with(
        :name   => 'virtproxyd-tls.socket',
        :ensure => 'running',
        :enable => true,
      )}
      it { is_expected.to contain_file_line('virtproxyd-tls.socket ListenStream').with(
        :path  => '/etc/systemd/system/virtproxyd-tls.socket',
        :line  => 'ListenStream=[::1]:16514',
        :match => '^ListenStream=.*',
      )}
    end

    context 'with tcp transport' do
      let :params do
        {
          :transport       => 'tcp',
          :modular_libvirt => true,
        }
      end

      it { is_expected.to contain_service('virtproxyd-tcp').with(
        :name   => 'virtproxyd-tcp.socket',
        :ensure => 'running',
        :enable => true,
      )}
      it { is_expected.to contain_file('/etc/systemd/system/virtproxyd-tcp.socket').with(
        :ensure => 'absent',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova migration with libvirt'
      if facts[:os]['family'] == 'RedHat'
        it_behaves_like 'nova migration with modular libvirt'
      end
    end
  end
end
