require 'spec_helper'
describe 'nova::compute::libvirt' do

  let :pre_condition do
    "include nova\ninclude nova::compute"
  end

  shared_examples 'nova-compute with libvirt' do

    it { should contain_class('nova::params') }

    context 'with default parameters' do

      it 'installs libvirt package and service' do
        should contain_package('libvirt').with(
          :name   => platform_params[:libvirt_package_name],
          :ensure => 'present'
        )
        should contain_service('libvirt').with(
          :name     => platform_params[:libvirt_service_name],
          :ensure   => 'running',
          :provider => platform_params[:special_service_provider],
          :require  => 'Package[libvirt]',
          :before   => 'Service[nova-compute]'
        )
      end

      it 'configures nova.conf' do
        should contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')
        should contain_nova_config('DEFAULT/libvirt_type').with_value('kvm')
        should contain_nova_config('DEFAULT/connection_type').with_value('libvirt')
        should contain_nova_config('DEFAULT/vncserver_listen').with_value('127.0.0.1')
      end
    end

    context 'with overridden parameters' do
      let :params do
        { :libvirt_type => 'qemu' }
      end

      it { should contain_nova_config('DEFAULT/libvirt_type').with_value('qemu')}
    end

    describe 'with migration_support enabled' do
      let :params do
        { :migration_support => true }
      end

      context 'with vncserver_listen set to 0.0.0.0' do
        before do
          params.merge!( :vncserver_listen => '0.0.0.0' )
        end

        it {
          should contain_class('nova::migration::libvirt')
          should contain_nova_config('DEFAULT/vncserver_listen').with_value('0.0.0.0')
        }
      end

      context 'with vncserver_listen not set to 0.0.0.0' do
        before do
          params.merge!( :vncserver_listen => '127.0.0.1' )
        end

        it_raises 'a Puppet::Error', /For migration support to work, you MUST set vncserver_listen to '0.0.0.0'/
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :libvirt_package_name => 'libvirt-bin',
        :libvirt_service_name => 'libvirt-bin' }
    end

    it { should contain_package('nova-compute-kvm').with(
      :ensure => 'present',
      :before => 'Package[nova-compute]'
    ) }

    context 'on Debian operating systems' do
      before do
        facts.merge!(:operatingsystem => 'Debian')
        platform_params.merge!(:special_service_provider => nil)
      end

      it_behaves_like 'nova-compute with libvirt'
    end

    context 'on Ubuntu operating systems' do
      before do
        facts.merge!(:operatingsystem => 'Ubuntu')
        platform_params.merge!(:special_service_provider => 'upstart')
      end

      it_behaves_like 'nova-compute with libvirt'
    end
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :libvirt_package_name     => 'libvirt',
        :libvirt_service_name     => 'libvirtd',
        :special_service_provider => 'init' }
    end

    context 'on Fedora operating systems' do
      before do
        facts.merge!(:operatingsystem => 'Fedora')
        platform_params.merge!(:special_service_provider => nil)
      end

      it_behaves_like 'nova-compute with libvirt'
    end

    context 'on other operating systems' do
      before do
        facts.merge!(:operatingsystem => 'RedHat')
        platform_params.merge!(:special_service_provider => 'init')
      end

      it_behaves_like 'nova-compute with libvirt'

      it { should contain_service('messagebus').with(
        :ensure   => 'running',
        :enable   => true,
        :before   => 'Service[libvirt]',
        :provider => platform_params[:special_service_provider]
      ) }
    end
  end
end
