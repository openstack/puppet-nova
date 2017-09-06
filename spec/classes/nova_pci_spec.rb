require 'spec_helper'

describe 'nova::pci' do

  shared_examples_for 'nova-pci' do
    context 'with default parameters' do
      it 'clears pci_alias configuration' do
        is_expected.to contain_nova_config('pci/alias').with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'with aliases array' do
      let :params do
        {
            :aliases => [{
              "vendor_id"  => "8086",
              "product_id" => "0126",
              "name"       => "graphic_card"
            },
            {
              "vendor_id"  => "9096",
              "product_id" => "1520",
              "name"       => "network_card"
            }
          ]
        }
      end
      it 'configures nova pci_alias entries' do
        is_expected.to contain_nova_config('pci/alias').with(
          'value' => ['{"vendor_id":"8086","product_id":"0126","name":"graphic_card"}','{"vendor_id":"9096","product_id":"1520","name":"network_card"}']
        )
      end
    end

    context 'with aliases JSON encoded string (deprecated)' do
      let :params do
        {
          :aliases => "[{\"vendor_id\":\"8086\",\"product_id\":\"0126\",\"name\":\"graphic_card\"},{\"vendor_id\":\"9096\",\"product_id\":\"1520\",\"name\":\"network_card\"}]",
        }
      end
      it 'configures nova pci_alias entries' do
        is_expected.to contain_nova_config('pci/alias').with(
          'value' => ['{"vendor_id":"8086","product_id":"0126","name":"graphic_card"}','{"vendor_id":"9096","product_id":"1520","name":"network_card"}']
        )
      end
    end

    context 'when aliases is empty' do
      let :params do
        {
          :aliases => []
        }
      end

      it 'clears pci_alias configuration' do
        is_expected.to contain_nova_config('pci/alias').with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'when aliases is empty string' do
      let :params do
        {
          :aliases => ""
        }
      end

      it 'clears pci_alias configuration' do
        is_expected.to contain_nova_config('pci/alias').with(:value => '<SERVICE DEFAULT>')
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

      it_configures 'nova-pci'
    end
  end
end