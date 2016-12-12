require 'spec_helper'

describe 'nova::db::sync_cell_v2' do

  shared_examples_for 'nova-db-sync-cell_v2' do
    context 'with defaults' do

      it {
        is_expected.to contain_exec('nova-cell_v2-simple-cell-setup').with(
          :command     => '/usr/bin/nova-manage  cell_v2 simple_cell_setup ',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::dbsync_api::end]',
                           'Anchor[nova::cell_v2::begin]'],
          :notify      => 'Anchor[nova::cell_v2::end]',
        )
      }
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params  => '--config-file /etc/nova/nova.conf',
          :transport_url => 'rabbit://user:pass@host:1234/virt'
        }
      end

      it {
        is_expected.to contain_exec('nova-cell_v2-simple-cell-setup').with(
          :command     => '/usr/bin/nova-manage --config-file /etc/nova/nova.conf cell_v2 simple_cell_setup --transport-url=rabbit://user:pass@host:1234/virt',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::dbsync_api::end]',
                           'Anchor[nova::cell_v2::begin]'],
          :notify      => 'Anchor[nova::cell_v2::end]',
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

      it_configures 'nova-db-sync-cell_v2'
    end
  end

end
