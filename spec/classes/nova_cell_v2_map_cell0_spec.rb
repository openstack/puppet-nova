require 'spec_helper'

describe 'nova::cell_v2::map_cell0' do
  shared_examples 'nova::cell_v2::map_cell0' do
    context 'with defaults' do
      it { should contain_exec('nova-cell_v2-map_cell0').with(
        :path        => ['/bin', '/usr/bin'],
        :command     => 'nova-manage  cell_v2 map_cell0',
        :user        => 'nova',
        :refreshonly => 'true',
        :logoutput   => 'on_failure',
        :subscribe   => 'Anchor[nova::cell_v2::begin]',
        :notify      => 'Anchor[nova::cell_v2::end]',
      )}
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/nova/nova.conf',
        }
      end

      it { should contain_exec('nova-cell_v2-map_cell0').with(
        :path        => ['/bin', '/usr/bin'],
        :command     => 'nova-manage --config-file /etc/nova/nova.conf cell_v2 map_cell0',
        :user        => 'nova',
        :refreshonly => 'true',
        :logoutput   => 'on_failure',
        :subscribe   => 'Anchor[nova::cell_v2::begin]',
        :notify      => 'Anchor[nova::cell_v2::end]',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::cell_v2::map_cell0'
    end
  end
end
