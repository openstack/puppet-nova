require 'spec_helper'

describe 'nova::db::sync_api' do

  shared_examples_for 'nova-dbsync-api' do
    context 'with defaults' do
      it {
        is_expected.to contain_exec('nova-db-sync-api').with(
          :command     => '/usr/bin/nova-manage  api_db sync',
          :refreshonly => 'true',
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::dbsync_api::begin]'],
          :notify      => 'Anchor[nova::dbsync_api::end]',
        )
      }
      it { is_expected.to_not contain_class('nova::db::sync_cell_v2') }
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/nova/nova.conf',
          :cellv2_setup => true
        }
      end

      it {
        is_expected.to contain_exec('nova-db-sync-api').with(
          :command     => '/usr/bin/nova-manage --config-file /etc/nova/nova.conf api_db sync',
          :refreshonly => 'true',
          :logoutput   => 'on_failure'
        )
      }
      it { is_expected.to contain_class('nova::db::sync_cell_v2') }
    end
  end


  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'nova-dbsync-api'
    end
  end

end
