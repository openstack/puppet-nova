require 'spec_helper'

describe 'nova::db::postgresql' do

  shared_examples 'nova::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { should contain_openstacklib__db__postgresql('nova').with(
        :password   => 'pw',
        :dbname     => 'nova',
        :user       => 'nova',
        :encoding   => nil,
        :privileges => 'ALL',
      )}

      it { should contain_openstacklib__db__postgresql('nova_cell0').with(
        :password   => 'pw',
        :dbname     => 'nova_cell0',
        :user       => 'nova',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end

    context 'when disabling cell0 setup' do
      let :params do
        { :setup_cell0 => false}.merge(req_params)
      end

      it { is_expected.to_not contain_openstacklib__db__postgresql('nova_cell0') }
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
