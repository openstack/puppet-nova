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

    context 'with deprecated parameters' do
      before do
        params.merge!({
          :quota_instances                   => 20,
          :quota_cores                       => 40,
          :quota_ram                         => 102400,
          :quota_floating_ips                => 20,
          :quota_fixed_ips                   => 512,
          :quota_metadata_items              => 256,
          :quota_injected_files              => 10,
          :quota_injected_file_content_bytes => 20480,
          :quota_injected_file_path_length   => 254,
          :quota_security_groups             => 20,
          :quota_security_group_rules        => 40,
          :quota_key_pairs                   => 200,
          :quota_server_groups               => 20,
          :quota_server_group_members        => 20
        })
      end

      it {
        should contain_nova_config('quota/instances').with_value(params[:quota_instances])
        should contain_nova_config('quota/cores').with_value(params[:quota_cores])
        should contain_nova_config('quota/ram').with_value(params[:quota_ram])
        should contain_nova_config('quota/floating_ips').with_value(params[:quota_floating_ips])
        should contain_nova_config('quota/fixed_ips').with_value(params[:quota_fixed_ips])
        should contain_nova_config('quota/metadata_items').with_value(params[:quota_metadata_items])
        should contain_nova_config('quota/injected_files').with_value(params[:quota_injected_files])
        should contain_nova_config('quota/injected_file_content_bytes').with_value(params[:quota_injected_file_content_bytes])
        should contain_nova_config('quota/injected_file_path_length').with_value(params[:quota_injected_file_path_length])
        should contain_nova_config('quota/security_groups').with_value(params[:quota_security_groups])
        should contain_nova_config('quota/security_group_rules').with_value(params[:quota_security_group_rules])
        should contain_nova_config('quota/key_pairs').with_value(params[:quota_key_pairs])
        should contain_nova_config('quota/server_groups').with_value(params[:quota_server_groups])
        should contain_nova_config('quota/server_group_members').with_value(params[:quota_server_group_members])
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

      it_behaves_like 'nova::quota'
    end
  end
end
