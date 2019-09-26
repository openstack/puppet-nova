# Unit tests for nova::compute::libvirt::virtlogd class
#
require 'spec_helper'

describe 'nova::compute::libvirt::virtlogd' do

  let :pre_condition do
    <<-eos
    include nova
    include nova::compute
    include nova::compute::libvirt
eos
  end

  shared_examples_for 'nova-compute-libvirt-virtlogd' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it { is_expected.to contain_class('nova::deps')}
      it { is_expected.to contain_class('nova::compute::libvirt::virtlogd')}

      it { is_expected.to contain_virtlogd_config('log_level').with_ensure('absent')}
      it { is_expected.to contain_virtlogd_config('log_outputs').with_ensure('absent')}
      it { is_expected.to contain_virtlogd_config('log_filters').with_ensure('absent')}
      it { is_expected.to contain_virtlogd_config('max_clients').with_ensure('absent')}
      it { is_expected.to contain_virtlogd_config('admin_max_clients').with_ensure('absent')}
      it { is_expected.to contain_virtlogd_config('max_size').with_ensure('absent')}
      it { is_expected.to contain_virtlogd_config('max_backups').with_ensure('absent')}
    end

    context 'with specified parameters' do
      let :params do
        { :log_level         => 3,
          :log_outputs       => '3:syslog',
          :log_filters       => '1:logging 4:object 4:json 4:event 1:util',
          :max_clients       => 1024,
          :admin_max_clients => 5,
          :max_size          => 2097152,
          :max_backups       => 3,
        }
      end

      it { is_expected.to contain_class('nova::deps')}
      it { is_expected.to contain_class('nova::compute::libvirt::virtlogd')}

      it { is_expected.to contain_virtlogd_config('log_level').with_value(params[:log_level])}
      it { is_expected.to contain_virtlogd_config('log_outputs').with_value("\"#{params[:log_outputs]}\"")}
      it { is_expected.to contain_virtlogd_config('log_filters').with_value("\"#{params[:log_filters]}\"")}
      it { is_expected.to contain_virtlogd_config('max_clients').with_value(params[:max_clients])}
      it { is_expected.to contain_virtlogd_config('admin_max_clients').with_value(params[:admin_max_clients])}
      it { is_expected.to contain_virtlogd_config('max_size').with_value(params[:max_size])}
      it { is_expected.to contain_virtlogd_config('max_backups').with_value(params[:max_backups])}
    end
  end

  on_supported_os({
     :supported_os => OSDefaults.get_supported_os
   }).each do |os,facts|
     context "on #{os}" do
       let (:facts) do
         facts.merge!(OSDefaults.get_facts())
       end

       it_configures 'nova-compute-libvirt-virtlogd'
     end
  end

end
