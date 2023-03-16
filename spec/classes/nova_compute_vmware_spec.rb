require 'spec_helper'

describe 'nova::compute::vmware' do

  let :params do
    {
      :host_ip       => '127.0.0.1',
      :host_username => 'root',
      :host_password => 'passw0rd',
      :cluster_name  => 'cluster1'
    }
  end

  let :optional_params do
    {
      :api_retry_count    => 10,
      :maximum_objects    => 100,
      :task_poll_interval => 10.5,
      :use_linked_clone   => false,
      :compute_driver     => 'vmwareapi.FoobarDriver',
      :insecure           => true,
      :datastore_regex    => '/(?:[^:]|:[^:])+/'
    }
  end

  shared_examples_for 'vmware api' do

    context 'with default parameters' do
      it 'configures vmwareapi in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('vmwareapi.VMwareVCDriver')
        is_expected.to contain_nova_config('vmware/host_ip').with_value(params[:host_ip])
        is_expected.to contain_nova_config('vmware/host_username').with_value(params[:host_username])
        is_expected.to contain_nova_config('vmware/host_password').with_value(params[:host_password]).with_secret(true)
        is_expected.to contain_nova_config('vmware/cluster_name').with_value(params[:cluster_name])
        is_expected.to contain_nova_config('vmware/api_retry_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vmware/maximum_objects').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vmware/task_poll_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vmware/use_linked_clone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vmware/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vmware/ca_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vmware/datastore_regex').with_value('<SERVICE DEFAULT>')
      end

      it 'installs oslo.vmware python package' do
        is_expected.to contain_package('python-oslo-vmware').with(
          :ensure => 'present',
          :name   => 'python3-oslo-vmware',
          :tag    => ['openstack', 'nova-support-package'],
        )
      end
    end

    context 'with optional parameters' do
      before :each do
        params.merge!(optional_params)
      end

      it 'configures vmwareapi in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value(params[:compute_driver])
        is_expected.to contain_nova_config('vmware/api_retry_count').with_value(params[:api_retry_count])
        is_expected.to contain_nova_config('vmware/maximum_objects').with_value(params[:maximum_objects])
        is_expected.to contain_nova_config('vmware/task_poll_interval').with_value(params[:task_poll_interval])
        is_expected.to contain_nova_config('vmware/use_linked_clone').with_value(params[:use_linked_clone])
        is_expected.to contain_nova_config('vmware/insecure').with_value(params[:insecure])
        is_expected.to contain_nova_config('vmware/datastore_regex').with_value(params[:datastore_regex])
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os, facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'vmware api'
    end
  end

end
