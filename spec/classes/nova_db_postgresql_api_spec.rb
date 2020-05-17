require 'spec_helper'

describe 'nova::db::postgresql_api' do

  shared_examples_for 'nova::db::postgresql' do
    let :req_params do
      { :password => 'novapass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_openstacklib__db__postgresql('nova_api').with(
        :user       => 'nova_api',
        :password   => 'novapass',
        :dbname     => 'nova_api',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
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

      it_configures 'nova::db::postgresql'
    end
  end

end
