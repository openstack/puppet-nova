require 'spec_helper'

describe 'nova::quota' do
  let :params do
    {}
  end

  let :default_params do
    {
      :driver                      => '<SERVICE DEFAULT>',
      :instances                   => '<SERVICE DEFAULT>',
      :cores                       => '<SERVICE DEFAULT>',
      :ram                         => '<SERVICE DEFAULT>',
      :metadata_items              => '<SERVICE DEFAULT>',
      :injected_files              => '<SERVICE DEFAULT>',
      :injected_file_content_bytes => '<SERVICE DEFAULT>',
      :injected_file_path_length   => '<SERVICE DEFAULT>',
      :key_pairs                   => '<SERVICE DEFAULT>',
      :server_groups               => '<SERVICE DEFAULT>',
      :server_group_members        => '<SERVICE DEFAULT>',
      :recheck_quota               => '<SERVICE DEFAULT>',
      :count_usage_from_placement  => '<SERVICE DEFAULT>',
    }
  end

  shared_examples 'nova::quota config options' do
    let :params_hash do
      default_params.merge!(params)
    end

    it {
      params_hash.each_pair do |config, value|
        should contain_nova_config("quota/#{config}").with_value(value)
      end
    }
  end

  shared_examples 'nova::quota' do
    context 'with default parameters' do
      it_behaves_like 'nova::quota config options'
    end

    context 'with provided parameters' do
      before do
        params.merge!({
          :driver                      => 'nova.quota.DbQuotaDriver',
          :instances                   => 20,
          :cores                       => 40,
          :ram                         => 102400,
          :metadata_items              => 256,
          :injected_files              => 10,
          :injected_file_content_bytes => 20480,
          :injected_file_path_length   => 254,
          :key_pairs                   => 200,
          :server_groups               => 20,
          :server_group_members        => 20,
          :recheck_quota               => true,
          :count_usage_from_placement  => false,
        })
      end

      it_behaves_like 'nova::quota config options'
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::quota'
    end
  end
end
