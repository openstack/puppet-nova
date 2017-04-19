require 'spec_helper'

describe 'nova::cell_v2::cell' do

  let (:title) { 'foo' }

  shared_examples_for 'nova::cell_v2::cell' do
    context 'with defaults' do

      it {
        is_expected.to contain_nova_cell_v2("#{title}").with(
          :transport_url       => 'default',
          :database_connection => 'default'
        )
      }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'nova::cell_v2::cell'
    end
  end

end
