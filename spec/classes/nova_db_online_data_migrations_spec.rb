require 'spec_helper'

describe 'nova::db::online_data_migrations' do

  shared_examples_for 'nova-db-online-data-migrations' do

    it 'runs nova-db-sync' do
      is_expected.to contain_exec('nova-db-online-data-migrations').with(
        :command     => '/usr/bin/nova-manage  db online_data_migrations',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[nova::install::end]',
                         'Anchor[nova::config::end]',
                         'Anchor[nova::dbsync_api::end]',
                         'Anchor[nova::db_online_data_migrations::begin]'],
        :notify      => 'Anchor[nova::db_online_data_migrations::end]',
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/nova/nova.conf',
        }
      end

      it {
        is_expected.to contain_exec('nova-db-online-data-migrations').with(
          :command     => '/usr/bin/nova-manage --config-file /etc/nova/nova.conf db online_data_migrations',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 300,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::dbsync_api::end]',
                           'Anchor[nova::db_online_data_migrations::begin]'],
          :notify      => 'Anchor[nova::db_online_data_migrations::end]',
        )
        }
      end

    describe "overriding db_sync_timeout" do
      let :params do
        {
          :db_sync_timeout => 750,
        }
      end

      it {
        is_expected.to contain_exec('nova-db-online-data-migrations').with(
          :command     => '/usr/bin/nova-manage  db online_data_migrations',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::dbsync_api::end]',
                           'Anchor[nova::db_online_data_migrations::begin]'],
          :notify      => 'Anchor[nova::db_online_data_migrations::end]',
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
          :processorcount => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'nova-db-online-data-migrations'
    end
  end

end
