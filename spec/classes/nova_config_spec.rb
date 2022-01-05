require 'spec_helper'

describe 'nova::config' do
  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples 'nova_config' do
    let :params do
      { :nova_config => config_hash }
    end

    it { is_expected.to contain_class('nova::deps') }

    it 'configures arbitrary nova-config configurations' do
      is_expected.to contain_nova_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_nova_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_nova_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples 'nova_api_paste_ini' do
    let :params do
      { :nova_api_paste_ini => config_hash }
    end

    it 'configures arbitrary nova-api-paste-ini configurations' do
      is_expected.to contain_nova_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_nova_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_nova_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples 'nova_rootwrap_config' do
    let :params do
      { :nova_rootwrap_config => config_hash }
    end

    it 'configures arbitrary nova-rootwrap-config configurations' do
      is_expected.to contain_nova_rootwrap_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_nova_rootwrap_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_nova_rootwrap_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova_config'
      it_behaves_like 'nova_api_paste_ini'
      it_behaves_like 'nova_rootwrap_config'
    end
  end
end
