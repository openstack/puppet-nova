require 'spec_helper'

describe 'nova::scheduler::filter' do

  let :params do
    {}
  end

  shared_examples 'nova::scheduler::filter' do

    context 'with default parameters' do
      it { is_expected.to contain_nova_config('filter_scheduler/host_subset_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/max_io_ops_per_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/max_instances_per_host').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/available_filters').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/weight_classes').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/enabled_filters').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/track_instance_changes').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/ram_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/cpu_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/disk_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/io_ops_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/soft_affinity_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/soft_anti_affinity_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/build_failure_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/cross_cell_move_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/hypervisor_version_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/num_instances_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/shuffle_best_same_weighed_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/restrict_isolated_hosts_to_isolated_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/aggregate_image_properties_isolation_namespace').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/aggregate_image_properties_isolation_separator').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/pci_in_placement').with_value('<SERVICE DEFAULT>') }
    end

    context 'when overriding params' do
      let :params do
        {
          :host_subset_size                     => '3',
          :max_io_ops_per_host                  => '16',
          :max_instances_per_host               => '100',
          :isolated_images                      => ['ubuntu1','centos2'],
          :isolated_hosts                       => ['192.168.1.2','192.168.1.3'],
          :enabled_filters                      => ['RetryFilter','AvailabilityZoneFilter'],
          :available_filters                    => ['nova_filter1','nova_filter2'],
          :weight_classes                       => 'nova.scheduler.weights.compute.BuildFailureWeigher',
          :track_instance_changes               => true,
          :ram_weight_multiplier                => 10,
          :cpu_weight_multiplier                => 20,
          :disk_weight_multiplier               => 30,
          :io_ops_weight_multiplier             => 40,
          :soft_affinity_weight_multiplier      => 50,
          :soft_anti_affinity_weight_multiplier => 60,
          :build_failure_weight_multiplier      => 100,
          :cross_cell_move_weight_multiplier    => 1000,
          :hypervisor_version_weight_multiplier => 70,
          :num_instances_weight_multiplier      => 0,
          :shuffle_best_same_weighed_hosts      => true,
          :pci_in_placement                     => false,
        }
      end

      it { is_expected.to contain_nova_config('filter_scheduler/host_subset_size').with_value('3') }
      it { is_expected.to contain_nova_config('filter_scheduler/max_io_ops_per_host').with_value('16') }
      it { is_expected.to contain_nova_config('filter_scheduler/max_instances_per_host').with_value('100') }
      it { is_expected.to contain_nova_config('filter_scheduler/track_instance_changes').with_value(true) }
      it { is_expected.to contain_nova_config('filter_scheduler/ram_weight_multiplier').with_value(10) }
      it { is_expected.to contain_nova_config('filter_scheduler/cpu_weight_multiplier').with_value(20) }
      it { is_expected.to contain_nova_config('filter_scheduler/disk_weight_multiplier').with_value(30) }
      it { is_expected.to contain_nova_config('filter_scheduler/io_ops_weight_multiplier').with_value(40) }
      it { is_expected.to contain_nova_config('filter_scheduler/soft_affinity_weight_multiplier').with_value(50) }
      it { is_expected.to contain_nova_config('filter_scheduler/soft_anti_affinity_weight_multiplier').with_value(60) }
      it { is_expected.to contain_nova_config('filter_scheduler/build_failure_weight_multiplier').with_value(100) }
      it { is_expected.to contain_nova_config('filter_scheduler/cross_cell_move_weight_multiplier').with_value(1000) }
      it { is_expected.to contain_nova_config('filter_scheduler/hypervisor_version_weight_multiplier').with_value(70) }
      it { is_expected.to contain_nova_config('filter_scheduler/num_instances_weight_multiplier').with_value(0) }
      it { is_expected.to contain_nova_config('filter_scheduler/shuffle_best_same_weighed_hosts').with_value(true) }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_images').with_value('ubuntu1,centos2') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_hosts').with_value('192.168.1.2,192.168.1.3') }
      it { is_expected.to contain_nova_config('filter_scheduler/enabled_filters').with_value('RetryFilter,AvailabilityZoneFilter') }
      it { is_expected.to contain_nova_config('filter_scheduler/available_filters').with_value(['nova_filter1','nova_filter2']) }
      it { is_expected.to contain_nova_config('filter_scheduler/pci_in_placement').with_value(false) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova::scheduler::filter'
    end
  end

end
