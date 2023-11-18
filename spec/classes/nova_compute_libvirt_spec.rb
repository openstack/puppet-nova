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
        {}
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
          :name   => 'libvirt-daemon-system',
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
      it { is_expected.to contain_nova_config('libvirt/cpu_models').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model_extra_flags').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_management').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_management_strategy').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_governor_low').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_governor_high').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/snapshot_image_format').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/snapshots_directory').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/disk_cachemodes').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/inject_password').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/inject_key').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/inject_partition').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/enabled_perf_events').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/sysinfo_serial').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/device_detach_attempts').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/device_detach_timeout').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('127.0.0.1')}
      it { is_expected.to contain_nova_config('libvirt/rx_queue_size').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/tx_queue_size').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/file_backed_memory').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/images_type').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/volume_use_multipath').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/num_volume_scan_tries').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/nfs_mount_options').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/num_pcie_ports').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/mem_stats_period_seconds').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/pmem_namespaces').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/swtpm_enabled').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/swtpm_user').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/swtpm_group').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/max_queues').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/num_memory_encrypted_guests').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/wait_soft_reboot_seconds').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/tb_cache_size').with_value('<SERVICE DEFAULT>')}
    end

    describe 'with params' do
      let :params do
        { :ensure_package                             => 'latest',
          :virt_type                                  => 'qemu',
          :vncserver_listen                           => '0.0.0.0',
          :cpu_mode                                   => 'host-passthrough',
          :cpu_models                                 => ['kvm64', 'qemu64'],
          :cpu_model_extra_flags                      => 'pcid',
          :cpu_power_management                       => false,
          :cpu_power_management_strategy              => 'cpu_state',
          :cpu_power_governor_low                     => 'powersave',
          :cpu_power_governor_high                    => 'performance',
          :snapshot_image_format                      => 'raw',
          :snapshots_directory                        => '/var/lib/nova/snapshots',
          :disk_cachemodes                            => ['file=directsync','block=none'],
          :hw_disk_discard                            => 'unmap',
          :hw_machine_type                            => 'x86_64=machinetype1,armv7l=machinetype2',
          :sysinfo_serial                             => 'auto',
          :enabled_perf_events                        => ['cmt', 'mbml', 'mbmt'],
          :device_detach_attempts                     => 8,
          :device_detach_timeout                      => 20,
          :libvirt_service_name                       => 'custom_service',
          :virtlock_service_name                      => 'virtlock',
          :virtlog_service_name                       => 'virtlog',
          :compute_driver                             => 'libvirt.FoobarDriver',
          :preallocate_images                         => 'space',
          :rx_queue_size                              => 512,
          :tx_queue_size                              => 1024,
          :file_backed_memory                         => 2048,
          :images_type                                => 'raw',
          :volume_use_multipath                       => false,
          :num_volume_scan_tries                      => 3,
          :nfs_mount_options                          => 'rw,intr,nolock',
          :num_pcie_ports                             => 16,
          :mem_stats_period_seconds                   => 20,
          :pmem_namespaces                            => ['128G:ns0|ns1|ns2|ns3', '262144MB:ns4|ns5', 'MEDIUM:ns6|ns7'],
          :swtpm_enabled                              => true,
          :swtpm_user                                 => 'libvirt',
          :swtpm_group                                => 'libvirt',
          :max_queues                                 => 4,
          :num_memory_encrypted_guests                => 255,
          :wait_soft_reboot_seconds                   => 120,
          :tb_cache_size                              => 32,
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
      it { is_expected.to contain_nova_config('libvirt/cpu_models').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model_extra_flags').with_value('pcid')}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_management').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_management_strategy').with_value('cpu_state')}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_governor_low').with_value('powersave')}
      it { is_expected.to contain_nova_config('libvirt/cpu_power_governor_high').with_value('performance')}
      it { is_expected.to contain_nova_config('libvirt/snapshot_image_format').with_value('raw')}
      it { is_expected.to contain_nova_config('libvirt/snapshots_directory').with_value('/var/lib/nova/snapshots')}
      it { is_expected.to contain_nova_config('libvirt/disk_cachemodes').with_value('file=directsync,block=none')}
      it { is_expected.to contain_nova_config('libvirt/hw_disk_discard').with_value('unmap')}
      it { is_expected.to contain_nova_config('libvirt/hw_machine_type').with_value('x86_64=machinetype1,armv7l=machinetype2')}
      it { is_expected.to contain_nova_config('libvirt/sysinfo_serial').with_value('auto')}
      it { is_expected.to contain_nova_config('libvirt/enabled_perf_events').with_value('cmt,mbml,mbmt')}
      it { is_expected.to contain_nova_config('libvirt/device_detach_attempts').with_value(8)}
      it { is_expected.to contain_nova_config('libvirt/device_detach_timeout').with_value(20)}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('0.0.0.0')}
      it { is_expected.to contain_nova_config('libvirt/rx_queue_size').with_value(512)}
      it { is_expected.to contain_nova_config('libvirt/tx_queue_size').with_value(1024)}
      it { is_expected.to contain_nova_config('libvirt/file_backed_memory').with_value(2048)}
      it { is_expected.to contain_nova_config('libvirt/images_type').with_value('raw')}
      it { is_expected.to contain_nova_config('libvirt/volume_use_multipath').with_value(false)}
      it { is_expected.to contain_nova_config('libvirt/num_volume_scan_tries').with_value(3)}
      it { is_expected.to contain_nova_config('libvirt/nfs_mount_options').with_value('rw,intr,nolock')}
      it { is_expected.to contain_nova_config('libvirt/num_pcie_ports').with_value(16)}
      it { is_expected.to contain_nova_config('libvirt/mem_stats_period_seconds').with_value(20)}
      it { is_expected.to contain_nova_config('libvirt/pmem_namespaces').with_value('128G:ns0|ns1|ns2|ns3,262144MB:ns4|ns5,MEDIUM:ns6|ns7')}
      it { is_expected.to contain_nova_config('libvirt/swtpm_enabled').with_value(true)}
      it { is_expected.to contain_nova_config('libvirt/swtpm_user').with_value('libvirt')}
      it { is_expected.to contain_nova_config('libvirt/swtpm_group').with_value('libvirt')}
      it { is_expected.to contain_nova_config('libvirt/max_queues').with_value(4)}
      it { is_expected.to contain_nova_config('libvirt/num_memory_encrypted_guests').with_value(255)}
      it { is_expected.to contain_nova_config('libvirt/wait_soft_reboot_seconds').with_value(120)}
      it { is_expected.to contain_nova_config('libvirt/tb_cache_size').with_value(32)}

      it {
        is_expected.to contain_service('libvirt').with(
          :name   => 'custom_service',
          :enable => true,
          :ensure => 'running',
          :before => ['Anchor[nova::service::end]', 'Service[nova-compute]']
        )
        is_expected.to contain_service('virtlockd').with(
          :name   => 'virtlock',
          :enable => true,
          :ensure => 'running'
        )
        is_expected.to contain_service('virtlogd').with(
          :name   => 'virtlog',
          :enable => true,
          :ensure => 'running'
        )

      }
    end

    describe 'with custom cpu_mode' do
      let :params do
        { :cpu_mode              => 'custom',
          :cpu_models            => ['kvm64', 'qemu64'],
          :cpu_model_extra_flags => 'pcid' }
      end

      it { is_expected.to contain_nova_config('libvirt/cpu_mode').with_value('custom')}
      it { is_expected.to contain_nova_config('libvirt/cpu_models').with_value('kvm64,qemu64')}
      it { is_expected.to contain_nova_config('libvirt/cpu_model_extra_flags').with_value('pcid')}
    end

    describe 'with hw_machine_type set by array' do
      let :params do
        { :hw_machine_type => ['x86_64=machinetype1', 'armv7l=machinetype2'] }
      end
      it { is_expected.to contain_nova_config('libvirt/hw_machine_type').with_value('x86_64=machinetype1,armv7l=machinetype2')}
    end

    describe 'with hw_machine_type set by hash' do
      let :params do
        { :hw_machine_type => {
          'x86_64' => 'machinetype1',
          'armv7l' => 'machinetype2'
        } }
      end
      it { is_expected.to contain_nova_config('libvirt/hw_machine_type').with_value('x86_64=machinetype1,armv7l=machinetype2')}
    end

    describe 'with migration_support enabled' do

      context 'with vncserver_listen set to 0.0.0.0' do
        let :params do
          { :vncserver_listen  => '0.0.0.0',
            :migration_support => true }
        end

        it { is_expected.to contain_class('nova::migration::libvirt')}
        it { is_expected.to contain_nova_config('vnc/server_listen').with_value('0.0.0.0')}
      end

      context 'with vncserver_listen set to ::0' do
        let :params do
          { :vncserver_listen  => '::0',
            :migration_support => true }
        end

        it { is_expected.to contain_class('nova::migration::libvirt')}
        it { is_expected.to contain_nova_config('vnc/server_listen').with_value('::0')}
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
        :before => ['Anchor[nova::service::end]', 'Service[nova-compute]'],
      )}
      it { is_expected.to contain_service('messagebus').with(
        :ensure => 'running',
        :enable => true,
        :before => ['Anchor[nova::service::end]', 'Service[libvirt]'],
        :name   => 'dbus'
      ) }

      it { is_expected.to contain_nova_config('DEFAULT/compute_driver').with_value('libvirt.LibvirtDriver')}
      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('kvm')}
      it { is_expected.to contain_nova_config('libvirt/inject_password').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/inject_key').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/inject_partition').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('127.0.0.1')}
      it { is_expected.to contain_nova_config('libvirt/enabled_perf_events').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/device_detach_attempts').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/device_detach_timeout').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_nova_config('libvirt/nfs_mount_options').with_value('<SERVICE DEFAULT>')}
    end

    describe 'with params' do
      let :params do
        { :virt_type                                  => 'qemu',
          :vncserver_listen                           => '0.0.0.0',
          :enabled_perf_events                        => ['cmt', 'mbml', 'mbmt'],
          :device_detach_attempts                     => 8,
          :device_detach_timeout                      => 20,
          :nfs_mount_options                          => 'rw,intr,nolock',
          :mem_stats_period_seconds                   => 20,
        }
      end

      it { is_expected.to contain_nova_config('libvirt/virt_type').with_value('qemu')}
      it { is_expected.to contain_nova_config('vnc/server_listen').with_value('0.0.0.0')}
      it { is_expected.to contain_nova_config('libvirt/enabled_perf_events').with_value('cmt,mbml,mbmt')}
      it { is_expected.to contain_nova_config('libvirt/device_detach_attempts').with_value(8)}
      it { is_expected.to contain_nova_config('libvirt/device_detach_timeout').with_value(20)}
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
      end

      context 'with vncserver_listen set to ::0' do
        let :params do
          { :vncserver_listen  => '::0',
            :migration_support => true }
        end

        it { is_expected.to contain_class('nova::migration::libvirt')}
        it { is_expected.to contain_nova_config('vnc/server_listen').with_value('::0')}
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

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      case facts[:os]['family']
      when 'Debian'
        it_behaves_like 'debian-nova-compute-libvirt'
      when 'RedHat'
        it_behaves_like 'redhat-nova-compute-libvirt'
      end
    end
  end
end
