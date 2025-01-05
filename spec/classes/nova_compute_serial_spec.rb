require 'spec_helper'

describe 'nova::compute::serial' do
  shared_examples 'nova::compute::serial' do
    context 'with defaults' do
      it 'configures defaults' do
        should contain_nova_config('serial_console/enabled').with_value('true')
        should contain_nova_config('serial_console/port_range').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('serial_console/base_url').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('serial_console/proxyclient_address').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when overriding params' do
      let :params do
        {
          :port_range          => '10000:20000',
          :base_url            => 'ws://127.0.0.1:6083/',
          :proxyclient_address => '127.0.0.1',
        }
      end

      it 'configures the parameters' do
        should contain_nova_config('serial_console/enabled').with_value('true')
        should contain_nova_config('serial_console/port_range').with_value('10000:20000')
        should contain_nova_config('serial_console/base_url').with_value('ws://127.0.0.1:6083/')
        should contain_nova_config('serial_console/proxyclient_address').with_value('127.0.0.1')
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

      it_behaves_like 'nova::compute::serial'
    end
  end
end
