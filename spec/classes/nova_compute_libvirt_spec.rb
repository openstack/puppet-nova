require 'spec_helper'
require 'puppet/util/package'
describe 'nova::compute::libvirt' do

  let :pre_condition do
    "include nova\ninclude nova::compute"
  end

  shared_examples 'debian-nova-compute-libvirt' do
    let(:libvirt_options) do
      if facts[:operatingsystem] == 'Ubuntu' and Puppet::Util::Package.versioncmp(facts[:operatingsystemmajrelease], '16') >= 0
        'libvirtd_opts="-l"'
      else
        'libvirtd_opts="-d -l"'
      end
    end

    describe 'with default parameters' do

      it { is_expected.to contain_class('nova::params')}

      it {
        is_expected.to contain_package('nova-compute-kvm').with(
          :ensure => 'present',
          :tag    => ['openstack', 'nova-package']
        )
        is_expected.to contain_package('nova-compute-kvm').that_requires('Anchor[nova::install::begin]')
        is_expected.to contain_package('nova-compute-kvm').that_notifies('Anchor[nova::install::end]')
      }

      it {
        is_expected.to contain_package('libvirt').with(
          :name   => 'libvirt-bin',
          :ensure => 'present'
        )
        is_expected.to contain_package('libvirt').that_requires('Anchor[nova::install::begin]')
        is_expected.to contain_package('libvirt').that_comes_before('Anchor[nova::install::end]')
      }

      it {
        is_expected.to contain_service('libvirt').with(
          :name     => 'libvirt-bin',
          :enable   => true,
          :ensure   => 'running',
          :provider => 'upstart',
        )
      }

      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('kvm')}
      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('host-model')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/disk_cachemodes').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/inject_password').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_key').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_partition').with_value(-2)}
      it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('127.0.0.1')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_ensure('absent')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_kernels').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_ensure('absent')}
    end

    describe 'with params' do
      let :params do
        { :ensure_package                             => 'latest',
          :libvirt_virt_type                          => 'qemu',
          :vncserver_listen                           => '0.0.0.0',
          :libvirt_cpu_mode                           => 'host-passthrough',
          :libvirt_cpu_model                          => 'kvm64',
          :libvirt_disk_cachemodes                    => ['file=directsync','block=none'],
          :libvirt_hw_disk_discard                    => 'unmap',
          :remove_unused_base_images                  => true,
          :remove_unused_kernels                      => true,
          :remove_unused_resized_minimum_age_seconds  => 3600,
          :remove_unused_original_minimum_age_seconds => 3600,
          :libvirt_service_name                       => 'custom_service',
          :compute_driver                             => 'libvirt.FoobarDriver',
        }
      end

      it { is_expected.to contain_package('nova-compute-qemu').with(
        :name   => 'nova-compute-qemu',
        :ensure => 'latest'
      ) }
      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.FoobarDriver')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('qemu')}
      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('host-passthrough')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/disk_cachemodes').with_value('file=directsync,block=none')}
      it { is_expected.to contain_nova_config('libvirt/hw_disk_discard').with_value('unmap')}
      it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('0.0.0.0')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_value(true)}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_value(3600)}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_kernels').with_value(true)}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_value(3600)}
      it {
        is_expected.to contain_service('libvirt').with(
          :name     => 'custom_service',
          :enable   => true,
          :ensure   => 'running',
          :before   => ['Service[nova-compute]']
        )
      }
    end

    describe 'with custom cpu_mode' do
      let :params do
        { :libvirt_cpu_mode  => 'custom',
          :libvirt_cpu_model => 'kvm64' }
      end

      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('custom')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model').with_value('kvm64')}
    end

    describe 'with qemu as virt_type' do
      let :params do
        { :libvirt_virt_type => 'qemu' }
      end

      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('none')}
    end

    describe 'with migration_support enabled' do

      context 'with vncserver_listen set to 0.0.0.0' do
        let :params do
          { :vncserver_listen  => '0.0.0.0',
            :migration_support => true }
        end

        it { is_expected.to contain_class('nova::migration::libvirt')}
        it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('0.0.0.0')}
        it { is_expected.to contain_file_line('/etc/default/libvirt-bin libvirtd opts').with(:line => libvirt_options) }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tls').with(:line => "listen_tls = 0") }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tcp').with(:line => "listen_tcp = 1") }
        it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls')}
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp').with(:line => "auth_tcp = \"none\"") }
      end

      context 'with vncserver_listen set to ::0' do
        let :params do
          { :vncserver_listen  => '::0',
            :migration_support => true }
        end

        it { is_expected.to contain_class('nova::migration::libvirt')}
        it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('::0')}
        it { is_expected.to contain_file_line('/etc/default/libvirt-bin libvirtd opts').with(:line => libvirt_options) }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tls').with(:line => "listen_tls = 0") }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tcp').with(:line => "listen_tcp = 1") }
        it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls')}
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp').with(:line => "auth_tcp = \"none\"") }
      end

      context 'with custom libvirt service name on Debian platforms' do
        let :params do
          { :libvirt_service_name  => 'libvirtd',
            :vncserver_listen      => '0.0.0.0',
            :migration_support     => true }
        end
        it { is_expected.to contain_file_line('/etc/default/libvirtd libvirtd opts').with(:line => libvirt_options) }

      end
    end
  end


  shared_examples 'redhat-nova-compute-libvirt' do
    before do
      facts.merge!({ :operatingsystem => 'RedHat', :osfamily => 'RedHat',
        :operatingsystemrelease => 6.5,
        :operatingsystemmajrelease => '6' })
    end

    describe 'with default parameters' do

      it { is_expected.to contain_class('nova::params')}

      it { is_expected.to contain_package('libvirt').with(
        :name   => 'libvirt-daemon-kvm',
        :ensure => 'present',
      ) }

      it { is_expected.to contain_package('libvirt-nwfilter').with(
        :name   => 'libvirt-daemon-config-nwfilter',
        :ensure => 'present',
        :before  => ['Service[libvirt]', 'Anchor[nova::install::end]'],
      ) }

      it { is_expected.to contain_service('libvirt').with(
        :name     => 'libvirtd',
        :enable   => true,
        :ensure   => 'running',
        :provider => 'init',
        :before   => ['Service[nova-compute]'],
      )}
      it { is_expected.to contain_service('messagebus').with(
        :ensure   => 'running',
        :enable   => true,
        :before   => ['Service[libvirt]'],
        :provider => 'init',
        :name     => 'messagebus'
      ) }

      describe 'on rhel 7' do
        before do
          facts.merge!({
            :operatingsystemrelease => 7.0,
            :operatingsystemmajrelease => '7'
          })
        end

        it { is_expected.to contain_service('libvirt').with(
          :provider => 'redhat'
        )}

        it { is_expected.to contain_service('messagebus').with(
          :provider => 'redhat',
          :name     => 'dbus'
        )}
      end

      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('kvm')}
      it { is_expected.to contain_nova_config('libvirt/inject_password').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_key').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_partition').with_value(-2)}
      it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('127.0.0.1')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_ensure('absent')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_kernels').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_ensure('absent')}
    end

    describe 'with params' do
      let :params do
        { :libvirt_virt_type                          => 'qemu',
          :vncserver_listen                           => '0.0.0.0',
          :remove_unused_base_images                  => true,
          :remove_unused_kernels                      => true,
          :remove_unused_resized_minimum_age_seconds  => 3600,
          :remove_unused_original_minimum_age_seconds => 3600
        }
      end

      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('qemu')}
      it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('0.0.0.0')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_value(true)}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_value(3600)}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_kernels').with_value(true)}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_value(3600)}
      it { is_expected.to contain_package('libvirt').with(
        :name   => 'libvirt-daemon-kvm',
        :ensure => 'present'
      ) }
    end

    describe 'with migration_support enabled' do

      context 'with vncserver_listen set to 0.0.0.0' do
        let :params do
          { :vncserver_listen  => '0.0.0.0',
            :migration_support => true }
        end

        it { is_expected.to contain_class('nova::migration::libvirt')}
        it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('0.0.0.0')}
        it { is_expected.to contain_file_line('/etc/sysconfig/libvirtd libvirtd args').with(:line => 'LIBVIRTD_ARGS="--listen"') }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tls').with(:line => "listen_tls = 0") }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tcp').with(:line => "listen_tcp = 1") }
        it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls')}
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp').with(:line => "auth_tcp = \"none\"") }
      end

      context 'with vncserver_listen set to ::0' do
        let :params do
          { :vncserver_listen  => '::0',
            :migration_support => true }
        end

        it { is_expected.to contain_class('nova::migration::libvirt')}
        it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('::0')}
        it { is_expected.to contain_file_line('/etc/sysconfig/libvirtd libvirtd args').with(:line => 'LIBVIRTD_ARGS="--listen"') }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tls').with(:line => "listen_tls = 0") }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tcp').with(:line => "listen_tcp = 1") }
        it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls')}
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp').with(:line => "auth_tcp = \"none\"") }
      end

    end

    describe 'with default parameters on Fedora' do
      before do
        facts.merge!({ :operatingsystem => 'Fedora', :osfamily => 'RedHat' })
      end

      it { is_expected.to contain_class('nova::params')}

      it { is_expected.to contain_package('libvirt').with(
        :name   => 'libvirt-daemon-kvm',
        :ensure => 'present'
      ) }

      it { is_expected.to contain_package('libvirt-nwfilter').with(
        :name   => 'libvirt-daemon-config-nwfilter',
        :ensure => 'present',
        :before  => ['Service[libvirt]', 'Anchor[nova::install::end]'],
      ) }

      it { is_expected.to contain_service('libvirt').with(
        :name     => 'libvirtd',
        :enable   => true,
        :ensure   => 'running',
        :provider => nil,
        :before   => ['Service[nova-compute]']
      )}

      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('kvm')}
      it { is_expected.to contain_nova_config('vnc/vncserver_listen').with_value('127.0.0.1')}
    end

  end

  context 'on Debian platforms' do
    let (:facts) do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :os_package_family => 'debian',
        :operatingsystemmajrelease => '8'
      })
    end

    it_behaves_like 'debian-nova-compute-libvirt'
  end

  context 'on Ubuntu platforms' do
    let (:facts) do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :os_package_family => 'ubuntu',
        :operatingsystemmajrelease => '16.04'
      })
    end

    it_behaves_like 'debian-nova-compute-libvirt'
  end

  context 'on RedHat platforms' do
    let (:facts) do
      @default_facts.merge({
        :osfamily => 'RedHat',
        :os_package_type => 'rpm',
      })
    end

    it_behaves_like 'redhat-nova-compute-libvirt'
  end


end
