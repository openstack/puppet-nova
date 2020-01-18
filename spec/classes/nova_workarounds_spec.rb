require 'spec_helper'

describe 'nova::workarounds' do

  let :params do
    {}
  end

  shared_examples 'nova::workarounds' do

    context 'with default parameters' do
      it { is_expected.not_to contain_resources('nova_config') }
    end

    context 'with overridden parameters' do
      let :params do
        { :enable_numa_live_migration => true,}
      end

      it { is_expected.to contain_nova_config('workarounds/enable_numa_live_migration').with_value('true') }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova::workarounds'
    end
  end
end
