require 'spec_helper'

describe 'nova::policy' do
  shared_examples 'nova::policy' do

    context 'setup policy with parameters' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/nova/policy.yaml',
          :policy_dirs          => '/etc/nova/policy.d',
          :policies             => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          }
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/nova/policy.yaml').with(
          :policies     => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          },
          :policy_path  => '/etc/nova/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'nova',
          :file_format  => 'yaml',
          :purge_config => false,
          :tag          => 'nova',
        )
        is_expected.to contain_oslo__policy('nova_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/nova/policy.yaml',
          :policy_dirs          => '/etc/nova/policy.d',
        )
      end
    end

    context 'with empty policies and purge_config enabled' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/nova/policy.yaml',
          :policies             => {},
          :purge_config         => true,
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/nova/policy.yaml').with(
          :policies     => {},
          :policy_path  => '/etc/nova/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'nova',
          :file_format  => 'yaml',
          :purge_config => true,
          :tag          => 'nova',
        )
        is_expected.to contain_oslo__policy('nova_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/nova/policy.yaml',
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::policy'
    end
  end
end
