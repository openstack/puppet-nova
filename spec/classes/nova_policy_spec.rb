require 'spec_helper'

describe 'nova::policy' do

  shared_examples_for 'nova policies' do
    let :params do
      {
        :policy_path => '/etc/nova/policy.json',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it 'set up the policies' do
      is_expected.to contain_openstacklib__policy__base('context_is_admin').with({
        :key   => 'context_is_admin',
        :value => 'foo:bar'
      })
      is_expected.to contain_oslo__policy('nova_config').with(
        :policy_file => '/etc/nova/policy.json',
      )
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova policies'
    end
  end

end
