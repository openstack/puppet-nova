require 'spec_helper'

describe 'nova::reports' do
  shared_examples 'nova::reports' do
    context 'with default parameters' do
      it {
        is_expected.to contain_oslo__reports('nova_config').with(
          :log_dir                     => '<SERVICE DEFAULT>',
          :file_event_handler          => '<SERVICE DEFAULT>',
          :file_event_handler_interval => '<SERVICE DEFAULT>',
        )
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :log_dir                     => '/var/log/nova',
          :file_event_handler          => '/var/tmp/nova/reports',
          :file_event_handler_interval => 1,
        }
      end

      it {
        is_expected.to contain_oslo__reports('nova_config').with(
          :log_dir                     => '/var/log/nova',
          :file_event_handler          => '/var/tmp/nova/reports',
          :file_event_handler_interval => 1,
        )
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::reports'
    end
  end
end
