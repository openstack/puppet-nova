require 'spec_helper'

describe 'nova::config' do
  shared_examples 'nova::config' do
    let :params do
      {
        :nova_config => {
          'DEFAULT/foo' => { 'value'  => 'fooValue' },
          'DEFAULT/bar' => { 'value'  => 'barValue' },
          'DEFAULT/baz' => { 'ensure' => 'absent' }
        },
        :nova_paste_api_ini => {
          'DEFAULT/foo2' => { 'value'  => 'fooValue' },
          'DEFAULT/bar2' => { 'value'  => 'barValue' },
          'DEFAULT/baz2' => { 'ensure' => 'absent' }
        }
      }
    end

    context 'with specified configs' do
      it { should contain_class('nova::deps') }

      it {
        should contain_nova_config('DEFAULT/foo').with_value('fooValue')
        should contain_nova_config('DEFAULT/bar').with_value('barValue')
        should contain_nova_config('DEFAULT/baz').with_ensure('absent')
      }

      it {
        should contain_nova_paste_api_ini('DEFAULT/foo2').with_value('fooValue')
        should contain_nova_paste_api_ini('DEFAULT/bar2').with_value('barValue')
        should contain_nova_paste_api_ini('DEFAULT/baz2').with_ensure('absent')
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::config'
    end
  end
end
