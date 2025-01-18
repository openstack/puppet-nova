require 'spec_helper'

describe 'nova::compute::spice' do
  shared_examples 'nova::compute::spice' do
    context 'with default params' do
      let :params do
        {}
      end

      it { should contain_nova_config('spice/agent_enabled').with_value('true')}
      it { should contain_nova_config('spice/server_proxyclient_address').with_value('<SERVICE DEFAULT>')}
      it { should contain_nova_config('spice/html5proxy_base_url').with_value('<SERVICE DEFAULT>')}
      it { should contain_nova_config('spice/server_listen').with_value('<SERVICE DEFAULT>')}
    end

    context 'when overriding params' do
      let :params do
        {
          :proxy_host                 => '10.10.10.10',
          :server_listen              => '10.10.11.11',
          :server_proxyclient_address => '192.168.12.12',
          :agent_enabled              => false
        }
      end

      it { should contain_nova_config('spice/html5proxy_base_url').with_value('http://10.10.10.10:6082/spice_auto.html')}
      it { should contain_nova_config('spice/server_listen').with_value('10.10.11.11')}
      it { should contain_nova_config('spice/server_proxyclient_address').with_value('192.168.12.12')}
      it { should contain_nova_config('spice/agent_enabled').with_value('false')}
    end

    context 'when setting html5proxy_base_url params' do
      let :params do
        {
          :html5proxy_base_url => 'https://my.custom.url/test.html',
        }
      end

      it { should contain_nova_config('spice/html5proxy_base_url').with_value('https://my.custom.url/test.html')}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::compute::spice'
    end
  end
end
