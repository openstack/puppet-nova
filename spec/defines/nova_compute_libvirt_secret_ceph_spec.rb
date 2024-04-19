require 'spec_helper'

describe 'nova::compute::libvirt::secret_ceph' do
  shared_examples 'nova::compute::libvirt::secret_ceph' do
    describe 'with required parameters' do
      let :pre_condition do
        "include nova"
      end

      let :params do
        {
          :uuid        => '4f515eff-47e4-425c-b24d-9c6adc56401c',
          :value       => 'AQBHCbtT6APDHhAA5W00cBchwkQjh3dkKsyPjw==',
          :secret_name => 'client.openstack',
          :secret_path => '/tmp',
        }
      end

      let :title do
        'random'
      end

      it { is_expected.to contain_file('/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.xml').with(
        :ensure  => 'present',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0600',
        :require => 'Anchor[nova::config::begin]',
      )}

      it {
        verify_contents(catalogue, '/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.xml', [
          "<secret ephemeral=\'no\' private=\'no\'>",
          "  <usage type=\'ceph\'>",
          "    <name>client.openstack</name>",
          "  </usage>",
          "  <uuid>4f515eff-47e4-425c-b24d-9c6adc56401c</uuid>",
          "</secret>"
        ])
      }

      it { is_expected.to contain_file('/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.secret').with(
        :ensure    => 'present',
        :owner     => 'root',
        :group     => 'root',
        :mode      => '0600',
        :show_diff => false,
        :require   => 'Anchor[nova::config::begin]',
      )}

      it {
        verify_contents(catalogue, '/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.secret', [
          "AQBHCbtT6APDHhAA5W00cBchwkQjh3dkKsyPjw==",
        ])
      }

      it { is_expected.to contain_exec('get-or-set virsh secret 4f515eff-47e4-425c-b24d-9c6adc56401c').with(
        :command => [
          '/usr/bin/virsh', 'secret-define', '--file', '/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.xml',
        ],
        :unless  => "/usr/bin/virsh secret-list | grep -i 4f515eff-47e4-425c-b24d-9c6adc56401c",
        :require => 'File[/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.xml]',
      )}

      it { is_expected.to contain_exec('set-secret-value virsh secret 4f515eff-47e4-425c-b24d-9c6adc56401c').with(
        :command   => [
          '/usr/bin/virsh', 'secret-set-value', '--secret', '4f515eff-47e4-425c-b24d-9c6adc56401c',
          '--file', '/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.secret',
        ],
        :unless    => "/usr/bin/virsh secret-get-value 4f515eff-47e4-425c-b24d-9c6adc56401c | grep -f /tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.secret",
        :logoutput => false,
        :require   => [
          'File[/tmp/libvirt-secret-4f515eff-47e4-425c-b24d-9c6adc56401c.secret]',
          'Exec[get-or-set virsh secret 4f515eff-47e4-425c-b24d-9c6adc56401c]',
        ],
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

      it_behaves_like 'nova::compute::libvirt::secret_ceph'
    end
  end
end
