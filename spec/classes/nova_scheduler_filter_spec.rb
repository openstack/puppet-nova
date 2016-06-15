require 'spec_helper'

describe 'nova::scheduler::filter' do

  let :params do
    {}
  end

  shared_examples 'nova::scheduler::filter' do

    context 'with default parameters' do
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_host_manager').with_value('host_manager') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_max_attempts').with_value('3') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_host_subset_size').with_value('1') }
      it { is_expected.to contain_nova_config('DEFAULT/max_io_ops_per_host').with_value('8') }
      it { is_expected.to contain_nova_config('DEFAULT/max_instances_per_host').with_value('50') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_available_filters').with_value(['nova.scheduler.filters.all_filters']) }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_weight_classes').with_value('nova.scheduler.weights.all_weighers') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_use_baremetal_filters').with_value(false) }
      it { is_expected.to contain_nova_config('DEFAULT/isolated_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/isolated_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_default_filters').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/baremetal_scheduler_default_filters').with_value('<SERVICE DEFAULT>') }
    end

    context 'when overriding params with non-empty arrays' do
      let :params do
        { :scheduler_max_attempts               => '4',
          :isolated_images                      => ['ubuntu1','centos2'],
          :isolated_hosts                       => ['192.168.1.2','192.168.1.3'],
          :scheduler_default_filters            => ['RetryFilter','AvailabilityZoneFilter','RamFilter'],
          :scheduler_use_baremetal_filters      => true,
          :baremetal_scheduler_default_filters  => ['ExactRamFilter','ExactDiskFilter','ExactCoreFilter'],
          :scheduler_available_filters          => ['nova_filter1','nova_filter2']
        }
      end

      it { is_expected.to contain_nova_config('DEFAULT/scheduler_max_attempts').with_value('4') }
      it { is_expected.to contain_nova_config('DEFAULT/isolated_images').with_value('ubuntu1,centos2') }
      it { is_expected.to contain_nova_config('DEFAULT/isolated_hosts').with_value('192.168.1.2,192.168.1.3') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_default_filters').with_value('RetryFilter,AvailabilityZoneFilter,RamFilter') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_use_baremetal_filters').with_value(true) }
      it { is_expected.to contain_nova_config('DEFAULT/baremetal_scheduler_default_filters').with_value('ExactRamFilter,ExactDiskFilter,ExactCoreFilter') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_available_filters').with_value(['nova_filter1','nova_filter2']) }
    end

    context 'when overriding params with empty arrays' do
      let :params do
        { :isolated_images                      => [],
          :isolated_hosts                       => [],
          :scheduler_default_filters            => [],
          :baremetal_scheduler_default_filters  => [], }
      end

      it { is_expected.to contain_nova_config('DEFAULT/isolated_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/isolated_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/scheduler_default_filters').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/baremetal_scheduler_default_filters').with_value('<SERVICE DEFAULT>') }
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
