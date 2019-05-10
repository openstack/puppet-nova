require 'spec_helper'

describe 'nova::quota' do
  let :params do
    {}
  end

  let :default_params do
    {
      :instances                   => 10,
      :cores                       => 20,
      :ram                         => 51200,
      :floating_ips                => 10,
      :fixed_ips                   => -1,
      :metadata_items              => 128,
      :injected_files              => 5,
      :injected_file_content_bytes => 10240,
      :injected_file_path_length   => 255,
      :security_groups             => 10,
      :security_group_rules        => 20,
      :key_pairs                   => 100,
      :server_groups               => 10,
      :server_group_members        => 10,
      :reservation_expire          => 86400,
      :until_refresh               => 0,
      :max_age                     => 0
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
          :instances                   => 20,
          :cores                       => 40,
          :ram                         => 102400,
          :floating_ips                => 20,
          :fixed_ips                   => 512,
          :metadata_items              => 256,
          :injected_files              => 10,
          :injected_file_content_bytes => 20480,
          :injected_file_path_length   => 254,
          :security_groups             => 20,
          :security_group_rules        => 40,
          :key_pairs                   => 200,
          :server_groups               => 20,
          :server_group_members        => 20,
          :reservation_expire          => 6400,
          :until_refresh               => 30,
          :max_age                     => 60
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
