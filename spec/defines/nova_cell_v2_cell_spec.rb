require 'spec_helper'

describe 'nova::cell_v2::cell' do

  let (:title) { 'foo' }

  shared_examples_for 'nova::cell_v2::cell' do
    context 'with defaults' do

      it {
        is_expected.to contain_exec("nova-cell_v2-cell-#{title}").with(
          :path      => ['/bin', '/usr/bin'],
          :command   => "nova-manage  cell_v2 create_cell --name=#{title}  ",
          :logoutput => 'on_failure',
          :subscribe => 'Anchor[nova::cell_v2::begin]',
          :notify    => 'Anchor[nova::cell_v2::end]',
        )
      }
    end

    context "overriding extra_params" do
      let :params do
        {
          :extra_params        => '--config-file /etc/nova/nova.conf',
          :transport_url       => 'rabbit://user:pass@host:1234/vhost',
          :database_connection => 'mysql://user:pass@host:3306/nova'
        }
      end

      it {
        is_expected.to contain_exec("nova-cell_v2-cell-#{title}").with(
          :path      => ['/bin', '/usr/bin'],
          :command   => "nova-manage --config-file /etc/nova/nova.conf cell_v2 create_cell --name=#{title} --transport-url=#{params[:transport_url]} --database_connection=#{params[:database_connection]}",
          :logoutput => 'on_failure',
          :subscribe => 'Anchor[nova::cell_v2::begin]',
          :notify    => 'Anchor[nova::cell_v2::end]',
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
