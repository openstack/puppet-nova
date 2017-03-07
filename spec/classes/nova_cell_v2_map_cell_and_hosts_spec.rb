require 'spec_helper'

describe 'nova::cell_v2::map_cell_and_hosts' do

  shared_examples_for 'nova::cell_v2::map_cell_and_hosts' do
    context 'with defaults' do

      it {
        is_expected.to contain_exec('nova-cell_v2-map_cell_and_hosts').with(
          :path        => ['/bin', '/usr/bin'],
          :command     => 'nova-manage  cell_v2 map_cell_and_hosts',
          :user        => 'nova',
          :refreshonly => true,
        )
      }
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params        => '--config-file /etc/nova/nova.conf'
        }
      end

      it {
        is_expected.to contain_exec('nova-cell_v2-map_cell_and_hosts').with(
          :path        => ['/bin', '/usr/bin'],
          :command     => 'nova-manage --config-file /etc/nova/nova.conf cell_v2 map_cell_and_hosts',
          :user        => 'nova',
          :refreshonly => true,
        )
      }
    end
  end


  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'nova::cell_v2::map_cell_and_hosts'
    end
  end

end
