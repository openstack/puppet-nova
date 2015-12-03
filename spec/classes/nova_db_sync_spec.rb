require 'spec_helper'

describe 'nova::db::sync' do

  shared_examples_for 'nova-dbsync' do

    it 'runs nova-db-sync' do
      is_expected.to contain_exec('nova-db-sync').with(
        :command     => '/usr/bin/nova-manage  db sync',
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
        is_expected.to contain_exec('nova-db-sync').with(
          :command     => '/usr/bin/nova-manage --config-file /etc/nova/nova.conf db sync',
          :refreshonly => 'true',
          :logoutput   => 'on_failure'
        )
        }
      end

  end


  context 'on a RedHat osfamily' do
    let :facts do
     @default_facts.merge({
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      })
    end

    it_configures 'nova-dbsync'
  end

  context 'on a Debian osfamily' do
    let :facts do
      @default_facts.merge({
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      })
    end

    it_configures 'nova-dbsync'
  end

end
