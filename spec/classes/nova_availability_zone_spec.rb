require 'spec_helper'

describe 'nova::availability_zone' do

  let :params do
    {}
  end

  shared_examples 'nova::availability_zone' do

    context 'with default parameters' do
      it { is_expected.to contain_nova_config('DEFAULT/default_availability_zone').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/default_schedule_zone').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/internal_service_availability_zone').with_value('<SERVICE DEFAULT>') }
    end

    context 'with overridden parameters' do
      let :params do
        { :default_availability_zone          => 'az1',
          :default_schedule_zone              => 'az2',
          :internal_service_availability_zone => 'az_int1',
        }
      end

      it { is_expected.to contain_nova_config('DEFAULT/default_availability_zone').with_value('az1') }
      it { is_expected.to contain_nova_config('DEFAULT/default_schedule_zone').with_value('az2') }
      it { is_expected.to contain_nova_config('DEFAULT/internal_service_availability_zone').with_value('az_int1') }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova::availability_zone'
    end
  end
end
