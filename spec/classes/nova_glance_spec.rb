require 'spec_helper'

describe 'nova::glance' do

  shared_examples_for 'nova::glance' do
    context 'with default params' do
      let :params do
        {}
      end

      it 'configure default params' do
        is_expected.to contain_nova_config('glance/endpoint_override').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('glance/num_retries').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :endpoint_override => 'http://localhost:9292',
          :num_retries       => 3,
        }
      end

      it 'configure glance params' do
        is_expected.to contain_nova_config('glance/endpoint_override').with_value('http://localhost:9292')
        is_expected.to contain_nova_config('glance/num_retries').with_value(3)
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

      it_behaves_like 'nova::glance'
    end
  end

end
