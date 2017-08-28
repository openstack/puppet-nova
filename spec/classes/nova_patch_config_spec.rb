require 'spec_helper'

describe 'nova::patch::config' do

  let :params do
    {}
  end

  shared_examples 'nova::patch::config' do

    it { is_expected.to contain_class('nova::deps') }

    context 'with default parameters' do
      it { is_expected.to contain_nova_config('DEFAULT/monkey_patch').with_value('false') }
      it { is_expected.to contain_nova_config('DEFAULT/monkey_patch_modules').with(:value => '<SERVICE DEFAULT>') }
    end

    context 'when overriding parameters' do
      let :params do
        { :monkey_patch         => true,
          :monkey_patch_modules => ['nova.compute.api:nova.notifications.notify_decorator']
        }
      end

      it { is_expected.to contain_nova_config('DEFAULT/monkey_patch').with_value('true') }
      it { is_expected.to contain_nova_config('DEFAULT/monkey_patch_modules').with_value('nova.compute.api:nova.notifications.notify_decorator') }
    end

    context 'when overriding parameters with reset values' do
      let :params do
        { :monkey_patch         => false,
          :monkey_patch_modules => '<SERVICE DEFAULT>'
        }
      end

      it { is_expected.to contain_nova_config('DEFAULT/monkey_patch').with_value('false') }
      it { is_expected.to contain_nova_config('DEFAULT/monkey_patch_modules').with(:value => '<SERVICE DEFAULT>') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova::patch::config'
    end
  end

end
