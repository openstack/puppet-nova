require 'spec_helper'

describe 'nova::cors' do

  shared_examples_for 'nova cors' do
    it 'configure cors default params' do
      is_expected.to contain_nova_config('cors/allowed_origin').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_nova_config('cors/allow_credentials').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_nova_config('cors/expose_headers').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_nova_config('cors/max_age').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_nova_config('cors/allow_methods').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_nova_config('cors/allow_headers').with_value('<SERVICE DEFAULT>')
    end

    context 'with specific parameters' do
      let :params do
        { :allowed_origin    => '*',
          :allow_credentials => true,
          :expose_headers    => 'Content-Language,Expires',
          :max_age           => 3600,
          :allow_methods     => 'GET,POST,PUT,DELETE,OPTIONS',
          :allow_headers     => 'Content-Type,Cache-Control',
        }
      end

      it 'configure cors params' do
        is_expected.to contain_nova_config('cors/allowed_origin').with_value('*')
        is_expected.to contain_nova_config('cors/allow_credentials').with_value(true)
        is_expected.to contain_nova_config('cors/expose_headers').with_value('Content-Language,Expires')
        is_expected.to contain_nova_config('cors/max_age').with_value(3600)
        is_expected.to contain_nova_config('cors/allow_methods').with_value('GET,POST,PUT,DELETE,OPTIONS')
        is_expected.to contain_nova_config('cors/allow_headers').with_value('Content-Type,Cache-Control')
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

      it_behaves_like 'nova cors'
    end
  end

end
