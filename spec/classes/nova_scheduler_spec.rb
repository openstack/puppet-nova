require 'spec_helper'

describe 'nova::scheduler' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova-scheduler' do

    it { is_expected.to contain_package('nova-scheduler').with(
      :name   => platform_params[:scheduler_package_name],
      :ensure => 'present'
    ) }

    it { is_expected.to contain_service('nova-scheduler').with(
      :name      => platform_params[:scheduler_service_name],
      :hasstatus => 'true',
      :ensure    => 'running'
    )}

    it { is_expected.to contain_nova_config('scheduler/workers').with_value(4) }
    it { is_expected.to contain_nova_config('scheduler/driver').with_value('filter_scheduler') }
    it { is_expected.to contain_nova_config('scheduler/discover_hosts_in_cells_interval').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/query_placement_for_image_type_support').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/limit_tenants_to_placement_aggregate').with_value('<SERVICE DEFAULT>')}
    it { is_expected.to contain_nova_config('scheduler/placement_aggregate_required_for_tenants').with_value('<SERVICE DEFAULT>') }

    it { is_expected.to contain_class('nova::availability_zone') }

    context 'with manage_service as false' do
      let :params do
        { :enabled        => true,
          :manage_service => false
        }
      end
      it { is_expected.to contain_service('nova-scheduler').without_ensure }
    end

    context 'with package version' do
      let :params do
        { :ensure_package => '2012.1-2' }
      end

      it { is_expected.to contain_package('nova-scheduler').with(
        :ensure => params[:ensure_package]
      )}
    end

    context 'with workers' do
      let :params do
        { :workers => 8 }
      end

      it { is_expected.to contain_nova_config('scheduler/workers').with_value(8) }
    end

    context 'with scheduler driver' do
      let :params do
        { :scheduler_driver => 'custom driver' }
      end

      it { is_expected.to contain_nova_config('scheduler/driver').with_value('custom driver') }
    end

    context 'with discover_hosts_in_cells_interval' do
      let :params do
        { :discover_hosts_in_cells_interval => 15 }
      end

      it { is_expected.to contain_nova_config('scheduler/discover_hosts_in_cells_interval').with_value(15) }
    end

    context 'with query_placement_for_image_type_support' do
      let :params do
        { :query_placement_for_image_type_support => true }
      end

      it { is_expected.to contain_nova_config('scheduler/query_placement_for_image_type_support').with_value(true) }
    end

    context 'with limit_tenants_to_placement_aggregate' do
      let :params do
        { :limit_tenants_to_placement_aggregate => true }
      end

      it { is_expected.to contain_nova_config('scheduler/limit_tenants_to_placement_aggregate').with_value(true) }
    end

    context 'with placement_aggregate_required_for_tenants' do
      let :params do
        { :placement_aggregate_required_for_tenants => true }
      end

      it { is_expected.to contain_nova_config('scheduler/placement_aggregate_required_for_tenants').with_value(true) }
    end

    context 'with default database parameters' do
      let :pre_condition do
        "include nova"
      end

      it { is_expected.to_not contain_nova_config('database/connection') }
      it { is_expected.to_not contain_nova_config('database/slave_connection') }
      it { is_expected.to_not contain_nova_config('database/connection_recycle_time').with_value('<SERVICE DEFAULT>') }
    end

    context 'with overridden database parameters' do
      let :pre_condition do
        "class { 'nova':
           database_connection   => 'mysql://user:pass@db/db',
           slave_connection      => 'mysql://user:pass@slave/db',
           database_idle_timeout => '30',
         }
        "
      end

      it { is_expected.to contain_oslo__db('nova_config').with(
        :connection              => 'mysql://user:pass@db/db',
        :slave_connection        => 'mysql://user:pass@slave/db',
        :connection_recycle_time => '30',
      )}
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 4 }))
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :scheduler_package_name => 'nova-scheduler',
            :scheduler_service_name => 'nova-scheduler' }
        when 'RedHat'
          { :scheduler_package_name => 'openstack-nova-scheduler',
            :scheduler_service_name => 'openstack-nova-scheduler' }
        end
      end

      it_configures 'nova-scheduler'
    end
  end

end
