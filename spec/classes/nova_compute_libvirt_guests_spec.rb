require 'spec_helper'

describe 'nova::compute::libvirt_guests' do

  shared_examples 'nova::compute::libvirt_guests' do

    context 'with default parameters' do

      it { is_expected.to contain_class('nova::params')}

      it { is_expected.to contain_file(platform_params[:libvirt_guests_environment_file]).with(
        :ensure => 'file',
        :path   => platform_params[:libvirt_guests_environment_file],
        :tag    => 'libvirt-guests-file'
      )}
      it { is_expected.to contain_file_line('libvirt-guests ON_BOOT').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => 'ON_BOOT=ignore',
        :match => '^ON_BOOT=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests ON_SHUTDOWN').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => 'ON_SHUTDOWN=shutdown',
        :match => '^ON_SHUTDOWN=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests START_DELAY').with(
        :ensure            => 'absent',
        :path              => platform_params[:libvirt_guests_environment_file],
        :match             => '^START_DELAY=.*',
        :match_for_absence => true,
        :tag               => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests SHUTDOWN_TIMEOUT').with(
        :ensure            => 'absent',
        :path              => platform_params[:libvirt_guests_environment_file],
        :match             => '^SHUTDOWN_TIMEOUT=.*',
        :match_for_absence => true,
        :tag               => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests PARALLEL_SHUTDOWN').with(
        :ensure            => 'absent',
        :path              => platform_params[:libvirt_guests_environment_file],
        :match             => '^PARALLEL_SHUTDOWN=.*',
        :match_for_absence => true,
        :tag               => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests BYPASS_CACHE').with(
        :ensure            => 'absent',
        :path              => platform_params[:libvirt_guests_environment_file],
        :match             => '^BYPASS_CACHE=.*',
        :match_for_absence => true,
        :tag               => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests SYNC_TIME').with(
        :ensure            => 'absent',
        :path              => platform_params[:libvirt_guests_environment_file],
        :match             => '^SYNC_TIME=.*',
        :match_for_absence => true,
        :tag               => 'libvirt-guests-file_line'
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
          :enabled           => true,
          :manage_service    => true,
          :on_boot           => 'start',
          :on_shutdown       => 'suspend',
          :start_delay       => 0,
          :shutdown_timeout  => 300,
          :parallel_shutdown => 0,
          :bypass_cache      => true,
          :sync_time         => true,
        }
      end

      it { is_expected.to contain_file(platform_params[:libvirt_guests_environment_file]).with(
        :ensure => 'file',
        :path   => platform_params[:libvirt_guests_environment_file],
        :tag    => 'libvirt-guests-file'
      )}
      it { is_expected.to contain_file_line('libvirt-guests ON_BOOT').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => 'ON_BOOT=start',
        :match => '^ON_BOOT=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests ON_SHUTDOWN').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => "ON_SHUTDOWN=suspend",
        :match => '^ON_SHUTDOWN=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests START_DELAY').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => 'START_DELAY=0',
        :match => '^START_DELAY=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests SHUTDOWN_TIMEOUT').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => "SHUTDOWN_TIMEOUT=300",
        :match => '^SHUTDOWN_TIMEOUT=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests PARALLEL_SHUTDOWN').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => "PARALLEL_SHUTDOWN=0",
        :match => '^PARALLEL_SHUTDOWN=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests BYPASS_CACHE').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => "BYPASS_CACHE=1",
        :match => '^BYPASS_CACHE=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }
      it { is_expected.to contain_file_line('libvirt-guests SYNC_TIME').with(
        :path  => platform_params[:libvirt_guests_environment_file],
        :line  => "SYNC_TIME=1",
        :match => '^SYNC_TIME=.*',
        :tag   => 'libvirt-guests-file_line'
      ) }

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
