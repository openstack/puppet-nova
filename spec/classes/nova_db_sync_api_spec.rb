require 'spec_helper'

describe 'nova::db::sync_api' do

  shared_examples_for 'nova-dbsync-api' do
    context 'with defaults' do
      it {
        is_expected.to contain_exec('nova-db-sync-api').with(
          :command     => '/usr/bin/nova-manage  api_db sync',
          :user        => 'nova',
          :refreshonly => 'true',
          :timeout     => 300,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::db::end]',
                           'Anchor[nova::dbsync_api::begin]'],
          :notify      => 'Anchor[nova::dbsync_api::end]',
          :tag         => 'openstack-db',
        )
      }
      it { is_expected.to_not contain_class('nova::cell_v2::simple_setup') }
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/nova/nova.conf',
          :cellv2_setup => false
        }
      end

      it {
        is_expected.to contain_exec('nova-db-sync-api').with(
          :command     => '/usr/bin/nova-manage --config-file /etc/nova/nova.conf api_db sync',
          :user        => 'nova',
          :refreshonly => 'true',
          :timeout     => 300,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::db::end]',
                           'Anchor[nova::dbsync_api::begin]'],
          :notify      => 'Anchor[nova::dbsync_api::end]',
          :tag         => 'openstack-db',
        )
      }
      it { is_expected.to_not contain_class('nova::cell_v2::simple_setup') }
    end

    context "overriding db_sync_timeout" do
      let :params do
        {
          :db_sync_timeout => 750
        }
      end

      it {
        is_expected.to contain_exec('nova-db-sync-api').with(
          :command     => '/usr/bin/nova-manage  api_db sync',
          :user        => 'nova',
          :refreshonly => 'true',
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::db::end]',
                           'Anchor[nova::dbsync_api::begin]'],
          :notify      => 'Anchor[nova::dbsync_api::end]',
          :tag         => 'openstack-db',
        )
      }
    end
  end


  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
        }))
      end

      it_configures 'nova-dbsync-api'
    end
  end

end
