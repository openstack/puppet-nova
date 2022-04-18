# Unit tests for nova::compute::libvirt::virtlockd class
#
require 'spec_helper'

describe 'nova::compute::libvirt::virtlockd' do

  let :pre_condition do
    <<-eos
    include nova
    include nova::compute
    include nova::compute::libvirt
eos
  end

  shared_examples_for 'nova-compute-libvirt-virtlockd' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it { is_expected.to contain_class('nova::deps')}
      it { is_expected.to contain_class('nova::compute::libvirt::virtlockd')}

      it { is_expected.to contain_virtlockd_config('log_level').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_virtlockd_config('log_outputs').with_value('<SERVICE DEFAULT>').with_quote(true)}
      it { is_expected.to contain_virtlockd_config('log_filters').with_value('<SERVICE DEFAULT>').with_quote(true)}
      it { is_expected.to contain_virtlockd_config('max_clients').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_virtlockd_config('admin_max_clients').with_value('<SERVICE DEFAULT>')}
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
      it { is_expected.to contain_class('nova::compute::libvirt::virtlockd')}

      it { is_expected.to contain_virtlockd_config('log_level').with_value(params[:log_level])}
      it { is_expected.to contain_virtlockd_config('log_outputs').with_value(params[:log_outputs]).with_quote(true)}
      it { is_expected.to contain_virtlockd_config('log_filters').with_value(params[:log_filters]).with_quote(true)}
      it { is_expected.to contain_virtlockd_config('max_clients').with_value(params[:max_clients])}
      it { is_expected.to contain_virtlockd_config('admin_max_clients').with_value(params[:admin_max_clients])}
    end
  end

  on_supported_os({
     :supported_os => OSDefaults.get_supported_os
   }).each do |os,facts|
     context "on #{os}" do
       let (:facts) do
         facts.merge!(OSDefaults.get_facts())
       end

       it_configures 'nova-compute-libvirt-virtlockd'
     end
  end

end
