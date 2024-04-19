# Unit tests for nova::compute::provider class
#

require 'spec_helper'

describe 'nova::compute::provider' do

  let :params do
    {}
  end

  shared_examples_for 'nova custom resource providers' do

    it 'configure nova.conf with default parameters' do
        is_expected.to contain_nova_config('compute/provider_config_location').with_value('/etc/nova/provider_config')
    end

    context 'when overriding default parameters' do
      before :each do
        params.merge!(
          :config_location     => '/etc/nova/custom_provider_config',
        )
      end

      it 'configure nova.conf with overridden parameters' do
          is_expected.to contain_nova_config('compute/provider_config_location').with_value('/etc/nova/custom_provider_config')
      end
    end

    context 'when providing custom inventory single inventory without uuid or name set' do
      before :each do
        params.merge!(
          :custom_inventories => [
            {
              'inventories' => {
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_1' => {
                  'total'            => '100',
                  'reserved'         => '0',
                  'min_unit'         => '1',
                  'max_unit'         => '10',
                  'step_size'        => '1',
                  'allocation_ratio' => '1.0'
                },
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_2' => {
                  'total' => '100',
                },
              },
              'traits' => [
                'CUSTOM_P_STATE_ENABLED',
                'CUSTOM_C_STATE_ENABLED',
              ],
            },
          ]
        )
      end

      it 'configure provider.yaml on compute nodes' do
        is_expected.to contain_file('/etc/nova/provider_config/provider.yaml')
      end
    end

    context 'when providing custom inventory single inventory with uuid set' do
      before :each do
        params.merge!(
          :custom_inventories => [
            {
              'uuid' => '5213b75d-9260-42a6-b236-f39b0fd10561',
              'inventories' => {
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_1' => {
                  'total'            => '100',
                  'reserved'         => '0',
                  'min_unit'         => '1',
                  'max_unit'         => '10',
                  'step_size'        => '1',
                  'allocation_ratio' => '1.0'
                },
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_2' => {
                  'total' => '100',
                },
              },
              'traits' => [
                'CUSTOM_P_STATE_ENABLED',
                'CUSTOM_C_STATE_ENABLED',
              ],
            },
          ]
        )
      end

      it 'configure provider.yaml on compute nodes' do
        is_expected.to contain_file('/etc/nova/provider_config/provider.yaml')
      end
    end

    context 'when providing custom inventory single inventory with name set' do
      before :each do
        params.merge!(
          :custom_inventories => [
            {
              'name' => 'EXAMPLE_RESOURCE_PROVIDER',
              'inventories' => {
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_1' => {
                  'total'            => '100',
                  'reserved'         => '0',
                  'min_unit'         => '1',
                  'max_unit'         => '10',
                  'step_size'        => '1',
                  'allocation_ratio' => '1.0'
                },
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_2' => {
                  'total' => '100',
                },
              },
              'traits' => [
                'CUSTOM_P_STATE_ENABLED',
                'CUSTOM_C_STATE_ENABLED',
              ],
            },
          ]
        )
      end

      it 'configure provider.yaml on compute nodes' do
        is_expected.to contain_file('/etc/nova/provider_config/provider.yaml')
      end
    end

    context 'when providing custom inventory with multiple providers' do
      before :each do
        params.merge!(
          :custom_inventories => [
            {
              'inventories' => {
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_1' => {
                  'total'            => '100',
                  'reserved'         => '0',
                  'min_unit'         => '1',
                  'max_unit'         => '10',
                  'step_size'        => '1',
                  'allocation_ratio' => '1.0'
                },
                'CUSTOM_EXAMPLE_RESOURCE_CLASS_2' => {
                  'total' => '100',
                },
              },
              'traits' => [
                'CUSTOM_P_STATE_ENABLED',
                'CUSTOM_C_STATE_ENABLED',
              ],
            },
            {
              'name' => 'EXAMPLE_RESOURCE_PROVIDER',
              'inventories' => {
                'CUSTOM_EXAMPLE_RESOURCE_CLASS' => {
                  'total'    => '10000',
                  'reserved' => '100',
                },
              },
            },
          ]
        )
      end

      it 'configure provider.yaml on compute nodes' do
        is_expected.to contain_file('/etc/nova/provider_config/provider.yaml')
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

      it_configures 'nova custom resource providers'
    end
  end
end
