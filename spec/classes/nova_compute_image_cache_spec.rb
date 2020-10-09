require 'spec_helper'

describe 'nova::compute::image_cache' do

  shared_examples 'nova::compute::image_cache' do
    context 'with no parameters' do

      it 'configures image cache in nova.conf' do
        should contain_nova_config('image_cache/manager_interval').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('image_cache/subdirectory_name').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('image_cache/remove_unused_base_images').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('image_cache/remove_unused_original_minimum_age_seconds').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('image_cache/remove_unused_resized_minimum_age_seconds').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('image_cache/precache_concurrency').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when specified parameters' do
      let :params do
        {
          :manager_interval                           => 2400,
          :subdirectory_name                          => '_base',
          :remove_unused_base_images                  => true,
          :remove_unused_original_minimum_age_seconds => 86400,
          :remove_unused_resized_minimum_age_seconds  => 3600,
          :precache_concurrency                       => 1,
        }
      end

      it 'configures image cache in nova.conf' do
        should contain_nova_config('image_cache/manager_interval').with_value(2400)
        should contain_nova_config('image_cache/subdirectory_name').with_value('_base')
        should contain_nova_config('image_cache/remove_unused_base_images').with_value(true)
        should contain_nova_config('image_cache/remove_unused_original_minimum_age_seconds').with_value(86400)
        should contain_nova_config('image_cache/remove_unused_resized_minimum_age_seconds').with_value(3600)
        should contain_nova_config('image_cache/precache_concurrency').with_value(1)
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

      it_behaves_like 'nova::compute::image_cache'
    end
  end
end
