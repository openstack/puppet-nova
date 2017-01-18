require 'spec_helper'

describe 'nova::cell_v2::simple_setup' do

  shared_examples_for 'nova::cell_v2::simple_setup' do
    context 'with defaults' do

      it {
        is_expected.to contain_class('nova::cell_v2::map_cell0')
        is_expected.to contain_nova__cell_v2__cell('default').with(
          :extra_params        => '',
          :transport_url       => nil,
          :database_conneciton => nil
        )
        is_expected.to contain_class('nova::cell_v2::discover_hosts')
      }
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params        => '--config-file /etc/nova/nova.conf',
          :transport_url       => 'rabbit://user:pass@host:1234/virt',
          :database_connection => 'mysql://nova:pass@host:1234/nova'
        }
      end

      it {
        is_expected.to contain_class('nova::cell_v2::map_cell0')
        is_expected.to contain_nova__cell_v2__cell('default').with(
          :extra_params        => params[:extra_params],
          :transport_url       => params[:transport_url],
          :database_connection => params[:database_connection]
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
