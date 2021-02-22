# Unit tests for nova::compute::libvirt::virtsecretd class
#
require 'spec_helper'

describe 'nova::compute::libvirt::virtsecretd' do

  let :pre_condition do
    <<-eos
    include nova
    include nova::compute
    include nova::compute::libvirt
eos
  end

  shared_examples_for 'nova-compute-libvirt-virtsecretd' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it { is_expected.to contain_class('nova::deps')}
      it { is_expected.to contain_class('nova::compute::libvirt::virtsecretd')}

      it { is_expected.to contain_virtsecretd_config('log_level').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_virtsecretd_config('log_outputs').with_value('<SERVICE DEFAULT>').with_quote(true)}
      it { is_expected.to contain_virtsecretd_config('log_filters').with_value('<SERVICE DEFAULT>').with_quote(true)}
      it { is_expected.to contain_virtsecretd_config('max_clients').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_virtsecretd_config('admin_max_clients').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_virtsecretd_config('ovs_timeout').with_value('<SERVICE DEFAULT>')}
    end

    context 'with specified parameters' do
      let :params do
        { :log_level         => 3,
          :log_outputs       => '3:syslog',
          :log_filters       => '1:logging 4:object 4:json 4:event 1:util',
          :max_clients       => 1024,
          :admin_max_clients => 5,
          :ovs_timeout       => 10,
        }
      end

      it { is_expected.to contain_class('nova::deps')}
      it { is_expected.to contain_class('nova::compute::libvirt::virtsecretd')}

      it { is_expected.to contain_virtsecretd_config('log_level').with_value(params[:log_level])}
      it { is_expected.to contain_virtsecretd_config('log_outputs').with_value(params[:log_outputs]).with_quote(true)}
      it { is_expected.to contain_virtsecretd_config('log_filters').with_value(params[:log_filters]).with_quote(true)}
      it { is_expected.to contain_virtsecretd_config('max_clients').with_value(params[:max_clients])}
      it { is_expected.to contain_virtsecretd_config('admin_max_clients').with_value(params[:admin_max_clients])}
      it { is_expected.to contain_virtsecretd_config('ovs_timeout').with_value(params[:ovs_timeout])}
    end
  end

  on_supported_os({
     :supported_os => OSDefaults.get_supported_os
   }).each do |os,facts|
     context "on #{os}" do
       let (:facts) do
         facts.merge!(OSDefaults.get_facts())
       end

       it_configures 'nova-compute-libvirt-virtsecretd'
     end
  end

end
