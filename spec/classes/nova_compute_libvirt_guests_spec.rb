require 'spec_helper'
require 'puppet/util/package'
describe 'nova::compute::libvirt_guests' do

  let :pre_condition do
    "include nova\ninclude nova::compute"
  end

  shared_examples 'redhat-nova-compute-libvirt-guests' do
    before do
      facts.merge!({ :operatingsystem => 'RedHat', :osfamily => 'RedHat',
        :operatingsystemrelease => 6.5,
        :operatingsystemmajrelease => '6' })
    end

    describe 'with default parameters' do

      it { is_expected.to contain_class('nova::params')}

      it { is_expected.not_to contain_package('libvirt-client') }
      it { is_expected.not_to contain_service('libvirt-guests') }

      describe 'on rhel 7' do
        before do
          facts.merge!({
            :operatingsystemrelease => 7.0,
            :operatingsystemmajrelease => '7'
          })
        end

        it { is_expected.to contain_service('libvirt-guests')}

      end
    end

    describe 'with params' do
      let :params do
        { :enabled                   => true,
        }
      end

      it { is_expected.to contain_file_line('/etc/sysconfig/libvirt-guests ON_BOOT').with(:line => 'ON_BOOT=ignore') }
      it { is_expected.to contain_file_line('/etc/sysconfig/libvirt-guests ON_SHUTDOWN').with(:line => "ON_SHUTDOWN=shutdown") }
      it { is_expected.to contain_file_line('/etc/sysconfig/libvirt-guests SHUTDOWN_TIMEOUT').with(:line => "SHUTDOWN_TIMEOUT=300") }

      it { is_expected.to contain_package('libvirt-guests').with(
        :name   => 'libvirt-client',
        :ensure => 'present'
      ) }

      it { is_expected.to contain_service('libvirt-guests').with(
        :name   => 'libvirt-guests',
        :enable => true,
        :ensure => 'running',
      )}
    end

    context 'while not managing service state' do
      let :params do
        { :enabled           => false,
          :manage_service    => false,
        }
      end

      it { is_expected.to contain_service('libvirt-guests').without_ensure }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do

      case [:osfamily]
      when 'RedHat'
        it_behaves_like 'redhat-nova-compute-libvirt-guests'
      end
    end
  end

end
