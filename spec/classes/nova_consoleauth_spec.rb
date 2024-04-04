require 'spec_helper'

describe 'nova::consoleauth' do

  shared_examples 'nova::consoleauth' do
    context 'with defaults' do
      it 'configures consoleauth in nova.conf' do
        should contain_nova_config('consoleauth/token_ttl').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('consoleauth/enforce_session_timeout').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let :params do
        {
          :token_ttl               => 600,
          :enforce_session_timeout => false,
        }
      end

      it 'configures consoleauth in nova.conf' do
        should contain_nova_config('consoleauth/token_ttl').with_value(600)
        should contain_nova_config('consoleauth/enforce_session_timeout').with_value(false)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::consoleauth'
    end
  end
end
