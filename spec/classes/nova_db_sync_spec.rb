require 'spec_helper'

describe 'nova::db::sync' do

  shared_examples_for 'nova-dbsync' do

    it 'runs nova-db-sync' do
      is_expected.to contain_exec('nova-db-sync').with(
        :command     => '/usr/bin/nova-manage  db sync',
        :user        => 'nova',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[nova::install::end]',
                         'Anchor[nova::config::end]',
                         'Anchor[nova::db::end]',
                         'Anchor[nova::dbsync::begin]'],
        :notify      => 'Anchor[nova::dbsync::end]',
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/nova/nova.conf',
        }
      end

      it {
        is_expected.to contain_exec('nova-db-sync').with(
          :command     => '/usr/bin/nova-manage --config-file /etc/nova/nova.conf db sync',
          :user        => 'nova',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 300,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::db::end]',
                           'Anchor[nova::dbsync::begin]'],
          :notify      => 'Anchor[nova::dbsync::end]',
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
        is_expected.to contain_exec('nova-db-sync').with(
          :command     => '/usr/bin/nova-manage  db sync',
          :user        => 'nova',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[nova::install::end]',
                           'Anchor[nova::config::end]',
                           'Anchor[nova::db::end]',
                           'Anchor[nova::dbsync::begin]'],
          :notify      => 'Anchor[nova::dbsync::end]',
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
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'nova-dbsync'
    end
  end

end
