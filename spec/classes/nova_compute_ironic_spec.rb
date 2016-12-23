require 'spec_helper'

describe 'nova::compute::ironic' do

  shared_examples_for 'nova-compute-ironic' do

    context 'with default parameters' do
      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('ironic.IronicDriver')
        is_expected.to contain_nova_config('DEFAULT/max_concurrent_builds').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :compute_driver        => 'ironic.FoobarDriver',
          :max_concurrent_builds => 15,
        }
      end

      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('ironic.FoobarDriver')
        is_expected.to contain_nova_config('DEFAULT/max_concurrent_builds').with_value(15)
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
        facts.merge!(OSDefaults.get_facts({
          :fqdn           => 'some.host.tld',
          :processorcount => 2,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
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
