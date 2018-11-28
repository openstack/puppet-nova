require 'spec_helper'

describe 'nova::generic_service' do
  shared_examples 'nova::generic_service' do
    describe 'package should come before service' do
      let :pre_condition do
        "include nova"
      end

      let :params do
        {
          :package_name => 'foo',
          :service_name => 'food'
        }
      end

      let :title do
        'foo'
      end

      it { should contain_service('nova-foo').with(
        :name   => 'food',
        :ensure => 'running',
        :enable => true
      )}

      it { should contain_service('nova-foo').that_subscribes_to(
        'Anchor[nova::service::begin]',
      )}

      it { should contain_service('nova-foo').that_notifies(
        'Anchor[nova::service::end]',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::generic_service'
    end
  end
end
