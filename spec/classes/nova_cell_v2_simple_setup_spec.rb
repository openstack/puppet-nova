require 'spec_helper'

describe 'nova::cell_v2::simple_setup' do

  shared_examples_for 'nova::cell_v2::simple_setup' do
    context 'with defaults' do

      it {
        is_expected.to contain_class('nova::cell_v2::map_cell0')
        is_expected.to contain_nova_cell_v2('cell0').with(
          :database_connection => 'default'
        )
        is_expected.to contain_nova_cell_v2('default').with(
          :transport_url       => 'default',
          :database_connection => 'default'
        )
        is_expected.to contain_class('nova::cell_v2::discover_hosts')
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

      it_configures 'nova::cell_v2::simple_setup'
    end
  end

end
