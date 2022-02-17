require 'spec_helper'

describe 'nova::compute::pci' do

  shared_examples_for 'nova-compute-pci' do
    context 'with default parameters' do
      it 'clears pci_passthrough_whitelist configuration' do
        is_expected.to contain_nova_config('pci/passthrough_whitelist').with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'with passthrough array' do
      let :params do
        {
            :passthrough => [
            {
              "vendor_id"  => "8086",
              "product_id" => "0126"
            },
            {
              "vendor_id"        => "9096",
              "product_id"       => "1520",
              "physical_network" => "physnet1"
            }
          ],
        }
      end
      it 'configures nova pci_passthrough_whitelist entries' do
        is_expected.to contain_nova_config('pci/passthrough_whitelist').with(
          'value' => ['{"vendor_id":"8086","product_id":"0126"}','{"vendor_id":"9096","product_id":"1520","physical_network":"physnet1"}']
        )
      end
    end

    context 'with passthrough JSON encoded string (deprecated)' do
      let :params do
        {
          :passthrough => "[{\"vendor_id\":\"8086\",\"product_id\":\"0126\"},{\"vendor_id\":\"9096\",\"product_id\":\"1520\",\"physical_network\":\"physnet1\"}]",
        }
      end

      it 'configures nova pci_passthrough_whitelist entries' do
        is_expected.to contain_nova_config('pci/passthrough_whitelist').with(
          'value' => ['{"vendor_id":"8086","product_id":"0126"}','{"vendor_id":"9096","product_id":"1520","physical_network":"physnet1"}']
        )
      end
    end

    context 'when passthrough is empty' do
      let :params do
        {
          :passthrough => []
        }
      end

      it 'clears pci_passthrough_whitelist configuration' do
        is_expected.to contain_nova_config('pci/passthrough_whitelist').with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'when passthrough is empty string' do
      let :params do
        {
          :passthrough => ""
        }
      end

      it 'clears pci_passthrough_whitelist configuration' do
        is_expected.to contain_nova_config('pci/passthrough_whitelist').with(:value => '<SERVICE DEFAULT>')
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

      it_configures 'nova-compute-pci'
    end
  end
end
