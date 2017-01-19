require 'spec_helper'

describe 'nova::db::sync_api' do

  shared_examples_for 'nova-dbsync-api' do

    it 'runs nova-db-sync-api' do
      is_expected.to contain_exec('nova-db-sync-api').with(
        :command     => '/usr/bin/nova-manage  api_db sync',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/nova/nova.conf',
        }
      end

      it {
        is_expected.to contain_exec('nova-db-sync-api').with(
          :command     => '/usr/bin/nova-manage --config-file /etc/nova/nova.conf api_db sync',
          :refreshonly => 'true',
          :logoutput   => 'on_failure'
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

      it_configures 'nova-dbsync-api'
    end
  end

end
