require 'spec_helper'

describe 'nova::compute::ironic' do

  shared_examples_for 'nova-compute-ironic' do

    context 'with default parameters' do
      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('ironic.IronicDriver')
        is_expected.to contain_class('ironic::client')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :compute_driver => 'ironic.FoobarDriver',
        }
      end

      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('ironic.FoobarDriver')
      end
    end

    context 'always' do
       it 'contains the ironic common class' do
         is_expected.to contain_class('nova::ironic::common')
       end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
            {}
        when 'RedHat'
            {}
        end
      end
      it_configures 'nova-compute-ironic'
    end
  end
end
