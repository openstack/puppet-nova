require 'spec_helper'

describe 'nova::compute::libvirt_guests' do

  shared_examples 'nova::compute::libvirt_guests' do

    context 'with default parameters' do

      it { is_expected.to contain_class('nova::params')}

      it { is_expected.to contain_file(platform_params[:libvirt_guests_environment_file]).with(
        :ensure => 'present',
        :path   => platform_params[:libvirt_guests_environment_file],
        :tag    => 'libvirt-guests-file',
      ) }
      it { is_expected.to contain_file_line('libvirt-guests ON_BOOT').with(
        :path => platform_params[:libvirt_guests_environment_file],
        :line => 'ON_BOOT=ignore',
        :tag  => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests ON_SHUTDOWN').with(
        :path => platform_params[:libvirt_guests_environment_file],
        :line => "ON_SHUTDOWN=shutdown",
        :tag  => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests SHUTDOWN_TIMEOUT').with(
        :path => platform_params[:libvirt_guests_environment_file],
        :line => "SHUTDOWN_TIMEOUT=300",
        :tag  => 'libvirt-guests-file_line'
      ) }

      it { is_expected.to contain_package('libvirt-client').with(
        :name   => platform_params[:libvirt_client_package_name],
        :ensure => 'present'
      ) }

      it { is_expected.to_not contain_service('libvirt-guests')}
    end

    context 'with params' do
      let :params do
        {
          :enabled        => true,
          :manage_service => true,
        }
      end

      it { is_expected.to contain_package('libvirt-client').with(
        :name   => platform_params[:libvirt_client_package_name],
        :ensure => 'present'
      ) }

      it { is_expected.to contain_service('libvirt-guests').with(
        :name   => platform_params[:libvirt_guests_service_name],
        :enable => true,
        :ensure => 'running',
      )}
    end

    context 'while not managing service state' do
      let :params do
        {
          :enabled => true,
        }
      end

      it { is_expected.to_not contain_service('libvirt-guests') }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 5 }))
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :libvirt_client_package_name     => 'libvirt-clients',
            :libvirt_guests_service_name     => 'libvirt-guests',
            :libvirt_guests_environment_file => '/etc/default/libvirt-guests'
          }
        when 'RedHat'
          {
            :libvirt_client_package_name     => 'libvirt-client',
            :libvirt_guests_service_name     => 'libvirt-guests',
            :libvirt_guests_environment_file => '/etc/sysconfig/libvirt-guests'
          }
        end
      end
      it_behaves_like 'nova::compute::libvirt_guests'
    end
  end
end
