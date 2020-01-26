require 'spec_helper'
require 'puppet/util/package'
describe 'nova::compute::libvirt' do

  let :pre_condition do
    "include nova\ninclude nova::compute"
  end

  shared_examples 'debian-nova-compute-libvirt' do
    let(:libvirt_options) do
      'libvirtd_opts="-l"'
    end

    describe 'with default parameters' do

      let :params do
        {
          :libvirt_cpu_model_extra_flags  => 'pcid,pdpe1gb',
        }
      end

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
          :name   => 'libvirtd',
          :ensure => 'present'
        )
        is_expected.to contain_package('libvirt').that_requires('Anchor[nova::install::begin]')
        is_expected.to contain_package('libvirt').that_comes_before('Anchor[nova::install::end]')
      }

      it {
        is_expected.to contain_service('libvirt').with(
          :name   => 'libvirtd',
          :enable => true,
          :ensure => 'running',
        )
      }

      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')}
      it { is_expected.to contain_nova_config('DEFAULT/preallocate_images').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('kvm')}
      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('host-model')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model_extra_flags').with_ensure('pcid,pdpe1gb')}
      it { is_expected.to contain_nova_config('libvirt/snapshot_image_format').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/disk_cachemodes').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/inject_password').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_key').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_partition').with_value(-2)}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('127.0.0.1')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_ensure('absent')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/rx_queue_size').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/tx_queue_size').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/volume_use_multipath').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/nfs_mount_options').with_ensure('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/num_pcie_ports').with_ensure('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/mem_stats_period_seconds').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_libvirtd_config('log_outputs').with_ensure('absent')}
      it { is_expected.to contain_libvirtd_config('log_filters').with_ensure('absent')}
      it { is_expected.to contain_libvirtd_config('tls_priority').with_ensure('absent')}
    end

    describe 'with params' do
      let :params do
        { :ensure_package                             => 'latest',
          :libvirt_virt_type                          => 'qemu',
          :vncserver_listen                           => '0.0.0.0',
          :libvirt_cpu_mode                           => 'host-passthrough',
          :libvirt_cpu_model                          => 'kvm64',
          :libvirt_cpu_model_extra_flags              => 'pcid',
          :libvirt_snapshot_image_format              => 'raw',
          :libvirt_disk_cachemodes                    => ['file=directsync','block=none'],
          :libvirt_hw_disk_discard                    => 'unmap',
          :libvirt_hw_machine_type                    => 'x86_64=machinetype1,armv7l=machinetype2',
          :libvirt_enabled_perf_events                => ['cmt', 'mbml', 'mbmt'],
          :remove_unused_base_images                  => true,
          :remove_unused_resized_minimum_age_seconds  => 3600,
          :remove_unused_original_minimum_age_seconds => 3600,
          :libvirt_service_name                       => 'custom_service',
          :virtlock_service_name                      => 'virtlock',
          :virtlog_service_name                       => 'virtlog',
          :compute_driver                             => 'libvirt.FoobarDriver',
          :preallocate_images                         => 'space',
          :log_outputs                                => '1:file:/var/log/libvirt/libvirtd.log',
          :rx_queue_size                              => 512,
          :tx_queue_size                              => 1024,
          :volume_use_multipath                       => false,
          :nfs_mount_options                          => 'rw,intr,nolock',
          :num_pcie_ports                             => 16,
          :mem_stats_period_seconds                   => 20,
          :log_filters                                => '1:qemu',
          :tls_priority                               => 'NORMAL:-VERS-SSL3.0',
        }
      end

      it { is_expected.to contain_package('nova-compute-qemu').with(
        :name   => 'nova-compute-qemu',
        :ensure => 'latest'
      ) }
      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.FoobarDriver')}
      it { is_expected.to contain_nova_config('DEFAULT/preallocate_images').with_value('space')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('qemu')}
      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('host-passthrough')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model_extra_flags').with_ensure('pcid')}
      it { is_expected.to contain_nova_config('libvirt/snapshot_image_format').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/disk_cachemodes').with_value('file=directsync,block=none')}
      it { is_expected.to contain_nova_config('libvirt/hw_disk_discard').with_value('unmap')}
      it { is_expected.to contain_nova_config('libvirt/hw_machine_type').with_value('x86_64=machinetype1,armv7l=machinetype2')}
      it { is_expected.to contain_nova_config('libvirt/enabled_perf_events').with_value('cmt,mbml,mbmt')}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('0.0.0.0')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_value(true)}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_value(3600)}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_value(3600)}
      it { is_expected.to contain_libvirtd_config('log_outputs').with_value("\"#{params[:log_outputs]}\"")}
      it { is_expected.to contain_nova_config('libvirt/rx_queue_size').with_value(512)}
      it { is_expected.to contain_nova_config('libvirt/tx_queue_size').with_value(1024)}
      it { is_expected.to contain_nova_config('libvirt/volume_use_multipath').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/nfs_mount_options').with_value('rw,intr,nolock')}
      it { is_expected.to contain_nova_config('libvirt/num_pcie_ports').with_value(16)}
      it { is_expected.to contain_nova_config('libvirt/mem_stats_period_seconds').with_value(20)}
      it { is_expected.to contain_libvirtd_config('log_filters').with_value("\"#{params[:log_filters]}\"")}
      it { is_expected.to contain_libvirtd_config('tls_priority').with_value("\"#{params[:tls_priority]}\"")}
      it {
        is_expected.to contain_service('libvirt').with(
          :name     => 'custom_service',
          :enable   => true,
          :ensure   => 'running',
          :before   => ['Service[nova-compute]']
        )
        is_expected.to contain_service('virtlockd').with(
          :name     => 'virtlock',
          :enable   => true,
          :ensure => 'running'
        )
        is_expected.to contain_service('virtlogd').with(
          :name     => 'virtlog',
          :enable   => true,
          :ensure => 'running'
        )

      }
    end

    describe 'with custom cpu_mode' do
      let :params do
        { :libvirt_cpu_mode              => 'custom',
          :libvirt_cpu_model             => 'kvm64',
          :libvirt_cpu_model_extra_flags => 'pcid' }
      end

      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('custom')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model').with_value('kvm64')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model_extra_flags').with_value('pcid')}
    end

    describe 'with qcow2 as snapshot_image_format' do
      let :params do
        { :libvirt_snapshot_image_format => 'qcow2' }
      end

      it { is_expected.to contain_nova_config('libvirt/snapshot_image_format').with_value('qcow2')}
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
        it { is_expected.to contain_nova_config('vnc/server_listen').with_value('0.0.0.0')}
        it { is_expected.to contain_file_line('/etc/default/libvirtd libvirtd opts').with(:line => libvirt_options) }
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
        it { is_expected.to contain_nova_config('vnc/server_listen').with_value('::0')}
        it { is_expected.to contain_file_line('/etc/default/libvirtd libvirtd opts').with(:line => libvirt_options) }
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

    describe 'when manage_libvirt_services is set to false' do
      context 'without libvirt packages & services' do
        let :params do
          { :manage_libvirt_services => false }
        end

        it { is_expected.not_to contain_package('libvirt') }
        it { is_expected.not_to contain_service('libvirt') }
        it { is_expected.not_to contain_package('libvirt-nwfilter') }
        it { is_expected.not_to contain_service('messagebus') }
        it { is_expected.not_to contain_service('virtlockd') }
        it { is_expected.not_to contain_service('virtlogd') }
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
        :name   => 'libvirtd',
        :enable => true,
        :ensure => 'running',
        :before => ['Service[nova-compute]'],
      )}
      it { is_expected.to contain_service('messagebus').with(
        :ensure => 'running',
        :enable => true,
        :before => ['Service[libvirt]'],
        :name   => 'messagebus'
      ) }

      describe 'on rhel 7' do
        before do
          facts.merge!({
            :operatingsystemrelease => 7.0,
            :operatingsystemmajrelease => '7'
          })
        end

        it { is_expected.to contain_service('libvirt')}

        it { is_expected.to contain_service('messagebus').with(
          :name => 'dbus'
        )}
      end

      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('kvm')}
      it { is_expected.to contain_nova_config('libvirt/inject_password').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_key').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/inject_partition').with_value(-2)}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('127.0.0.1')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_ensure('absent')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_ensure('absent')}
      it { is_expected.to contain_nova_config('libvirt/nfs_mount_options').with_ensure('<SERVICE DEFAULT>')}
    end

    describe 'with params' do
      let :params do
        { :libvirt_virt_type                          => 'qemu',
          :vncserver_listen                           => '0.0.0.0',
          :remove_unused_base_images                  => true,
          :remove_unused_resized_minimum_age_seconds  => 3600,
          :remove_unused_original_minimum_age_seconds => 3600,
          :libvirt_enabled_perf_events                => ['cmt', 'mbml', 'mbmt'],
          :nfs_mount_options                          => 'rw,intr,nolock',
          :mem_stats_period_seconds                   => 20,
        }
      end

      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('qemu')}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('0.0.0.0')}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_base_images').with_value(true)}
      it { is_expected.to contain_nova_config('DEFAULT/remove_unused_original_minimum_age_seconds').with_value(3600)}
      it { is_expected.to contain_nova_config('libvirt/remove_unused_resized_minimum_age_seconds').with_value(3600)}
      it { is_expected.to contain_nova_config('libvirt/enabled_perf_events').with_value('cmt,mbml,mbmt')}
      it { is_expected.to contain_nova_config('libvirt/nfs_mount_options').with_value('rw,intr,nolock')}
      it { is_expected.to contain_nova_config('libvirt/mem_stats_period_seconds').with_value(20)}
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
        it { is_expected.to contain_nova_config('vnc/server_listen').with_value('0.0.0.0')}
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
        it { is_expected.to contain_nova_config('vnc/server_listen').with_value('::0')}
        it { is_expected.to contain_file_line('/etc/sysconfig/libvirtd libvirtd args').with(:line => 'LIBVIRTD_ARGS="--listen"') }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tls').with(:line => "listen_tls = 0") }
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf listen_tcp').with(:line => "listen_tcp = 1") }
        it { is_expected.not_to contain_file_line('/etc/libvirt/libvirtd.conf auth_tls')}
        it { is_expected.to contain_file_line('/etc/libvirt/libvirtd.conf auth_tcp').with(:line => "auth_tcp = \"none\"") }
      end

    end

    describe 'when manage_libvirt_services is set to false' do
      context 'without libvirt packages & services' do
        let :params do
          { :manage_libvirt_services => false }
        end

        it { is_expected.not_to contain_package('libvirt') }
        it { is_expected.not_to contain_service('libvirt') }
        it { is_expected.not_to contain_package('libvirt-nwfilter') }
        it { is_expected.not_to contain_service('messagebus') }
        it { is_expected.not_to contain_service('virtlockd') }
        it { is_expected.not_to contain_service('virtlogd') }
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
        :name   => 'libvirtd',
        :enable => true,
        :ensure => 'running',
        :before => ['Service[nova-compute]']
      )}

      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('kvm')}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('127.0.0.1')}
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do

      case [:osfamily]
      when 'Debian'

        case [:operatingsystem]
        when 'Debian'
          let (:facts) do
            facts.merge!(OSDefaults.get_facts({
              :os_package_family => 'debian',
              :operatingsystemmajrelease => '8'}))
          end
          it_behaves_like 'debian-nova-compute-libvirt'
        when 'Ubuntu'
          let (:facts) do
            facts.merge!(OSDefaults.get_facts({
              :os_package_family => 'ubuntu',
              :operatingsystemmajrelease => '16.04'}))
          end
          it_behaves_like 'debian-nova-compute-libvirt'
        end

      when 'RedHat'
        let (:facts) do
          facts.merge!(OSDefaults.get_facts({ :os_package_type => 'rpm' }))
        end
        it_behaves_like 'redhat-nova-compute-libvirt'
      end
    end
  end

end
