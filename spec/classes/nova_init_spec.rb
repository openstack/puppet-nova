require 'spec_helper'

describe 'nova' do

  shared_examples 'nova' do

    context 'with default parameters' do

      it { is_expected.to contain_class('nova::deps') }
      it { is_expected.to contain_class('nova::workarounds') }

      it 'installs packages' do
        is_expected.to contain_package('python-nova').with(
          :ensure => 'present',
          :tag    => ['openstack', 'nova-package']
        )
        is_expected.to contain_package('nova-common').with(
          :name    => platform_params[:nova_common_package],
          :ensure  => 'present',
          :tag     => ['openstack', 'nova-package']
        )
      end

      it 'configures rootwrap' do
        is_expected.to contain_nova_config('DEFAULT/rootwrap_config').with_value('/etc/nova/rootwrap.conf')
      end

      it 'does not configure auth_strategy' do
        is_expected.to contain_nova_config('api/auth_strategy').with_value('<SERVICE DEFAULT>')
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__default('nova_config').with(
          :executor_thread_pool_size => '<SERVICE DEFAULT>',
          :transport_url             => '<SERVICE DEFAULT>',
          :rpc_response_timeout      => '<SERVICE DEFAULT>',
          :control_exchange          => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__rabbit('nova_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread            => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :rabbit_retry_interval           => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__amqp('nova_config').with(
          :server_request_prefix => '<SERVICE DEFAULT>',
          :broadcast_prefix      => '<SERVICE DEFAULT>',
          :group_request_prefix  => '<SERVICE DEFAULT>',
          :container_name        => '<SERVICE DEFAULT>',
          :idle_timeout          => '<SERVICE DEFAULT>',
          :trace                 => '<SERVICE DEFAULT>',
          :ssl_ca_file           => '<SERVICE DEFAULT>',
          :ssl_cert_file         => '<SERVICE DEFAULT>',
          :ssl_key_file          => '<SERVICE DEFAULT>',
          :sasl_mechanisms       => '<SERVICE DEFAULT>',
          :sasl_config_dir       => '<SERVICE DEFAULT>',
          :sasl_config_name      => '<SERVICE DEFAULT>',
          :username              => '<SERVICE DEFAULT>',
          :password              => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('nova_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
        )
      end

      it 'configures various things' do
        is_expected.to contain_nova_config('DEFAULT/state_path').with_value('/var/lib/nova')
        is_expected.to contain_oslo__concurrency('nova_config').with(
          :lock_path => platform_params[:lock_path]
        )
        is_expected.to contain_nova_config('DEFAULT/service_down_time').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('notifications/notification_format').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('notifications/notify_on_state_change').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/rootwrap_config').with_value('/etc/nova/rootwrap.conf')
        is_expected.to contain_nova_config('DEFAULT/report_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/periodic_fuzzy_delay').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('vif_plug_ovs/ovsdb_connection').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/long_rpc_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/cpu_allocation_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/ram_allocation_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/disk_allocation_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/initial_cpu_allocation_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/initial_ram_allocation_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/initial_disk_allocation_ratio').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/ssl_only').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/cert').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/key').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('console/ssl_ciphers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('console/ssl_minimum_version').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/dhcp_domain').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/instance_name_template').with_value('<SERVICE DEFAULT>')
      end

    end

    context 'with overridden parameters' do

      let :params do
        {
          :default_transport_url                   => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout                    => '30',
          :long_rpc_timeout                        => '1800',
          :control_exchange                        => 'nova',
          :executor_thread_pool_size               => 64,
          :rabbit_use_ssl                          => true,
          :rabbit_heartbeat_timeout_threshold      => '60',
          :rabbit_heartbeat_rate                   => '10',
          :rabbit_heartbeat_in_pthread             => true,
          :kombu_reconnect_delay                   => '5.0',
          :amqp_durable_queues                     => true,
          :kombu_compression                       => 'gzip',
          :kombu_ssl_ca_certs                      => '/etc/ca.cert',
          :kombu_ssl_certfile                      => '/etc/certfile',
          :kombu_ssl_keyfile                       => '/etc/key',
          :kombu_ssl_version                       => 'TLSv1',
          :rabbit_ha_queues                        => true,
          :rabbit_quorum_queue                     => true,
          :rabbit_quorum_delivery_limit            => 3,
          :rabbit_quorum_max_memory_length         => 5,
          :rabbit_quorum_max_memory_bytes          => 1073741824,
          :rabbit_retry_interval                   => '1',
          :amqp_idle_timeout                       => '60',
          :amqp_trace                              => true,
          :amqp_ssl_ca_file                        => '/etc/ca.cert',
          :amqp_ssl_cert_file                      => '/etc/certfile',
          :amqp_ssl_key_file                       => '/etc/key',
          :amqp_username                           => 'amqp_user',
          :amqp_password                           => 'password',
          :lock_path                               => '/var/locky/path',
          :state_path                              => '/var/lib/nova2',
          :service_down_time                       => '60',
          :auth_strategy                           => 'foo',
          :ensure_package                          => '2012.1.1-15.el6',
          :host                                    => 'test-001.example.org',
          :notification_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                     => 'ceilometer.compute.nova_notifier',
          :notification_topics                     => 'openstack',
          :notification_format                     => 'unversioned',
          :report_interval                         => '10',
          :periodic_fuzzy_delay                    => '61',
          :ovsdb_connection                        => 'tcp:127.0.0.1:6640',
          :upgrade_level_cert                      => '1.0.0',
          :upgrade_level_compute                   => '1.0.0',
          :upgrade_level_conductor                 => '1.0.0',
          :upgrade_level_scheduler                 => '1.0.0',
          :purge_config                            => false,
          :my_ip                                   => '192.0.2.1',
          :ssl_only                                => true,
          :cert                                    => '/etc/ssl/private/snakeoil.pem',
          :key                                     => '/etc/ssl/certs/snakeoil.pem',
          :console_ssl_ciphers                     => 'kEECDH+aECDSA+AES:kEECDH+AES+aRSA:kEDH+aRSA+AES',
          :console_ssl_minimum_version             => 'tlsv1_2',
          :dhcp_domain                             => 'foo',
          :instance_name_template                  => 'instance-%08x',
        }
      end

      it { is_expected.to contain_class('nova::deps') }
      it { is_expected.to contain_class('nova::workarounds') }

      it 'installs packages' do
        is_expected.to contain_package('nova-common').with('ensure' => '2012.1.1-15.el6')
        is_expected.to contain_package('python-nova').with('ensure' => '2012.1.1-15.el6')
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('nova_config').with({
          :purge => false
        })
      end

      it 'configures auth_strategy' do
        is_expected.to contain_nova_config('api/auth_strategy').with_value('foo')
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__default('nova_config').with(
          :executor_thread_pool_size => 64,
          :transport_url             => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout      => '30',
          :control_exchange          => 'nova',
        )
        is_expected.to contain_oslo__messaging__rabbit('nova_config').with(
          :rabbit_use_ssl                  => true,
          :heartbeat_timeout_threshold     => '60',
          :heartbeat_rate                  => '10',
          :heartbeat_in_pthread            => true,
          :kombu_reconnect_delay           => '5.0',
          :amqp_durable_queues             => true,
          :kombu_compression               => 'gzip',
          :kombu_ssl_ca_certs              => '/etc/ca.cert',
          :kombu_ssl_certfile              => '/etc/certfile',
          :kombu_ssl_keyfile               => '/etc/key',
          :kombu_ssl_version               => 'TLSv1',
          :rabbit_ha_queues                => true,
          :rabbit_quorum_queue             => true,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
          :rabbit_retry_interval           => '1',
        )
        is_expected.to contain_oslo__messaging__amqp('nova_config').with(
          :idle_timeout  => '60',
          :trace         => true,
          :ssl_ca_file   => '/etc/ca.cert',
          :ssl_cert_file => '/etc/certfile',
          :ssl_key_file  => '/etc/key',
          :username      => 'amqp_user',
          :password      => 'password',
        )
        is_expected.to contain_oslo__messaging__notifications('nova_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'ceilometer.compute.nova_notifier',
          :topics        => 'openstack',
        )
      end

      it 'configures host' do
        is_expected.to contain_nova_config('DEFAULT/host').with_value('test-001.example.org')
      end

      it 'configures my_ip' do
        is_expected.to contain_nova_config('DEFAULT/my_ip').with_value('192.0.2.1')
      end

      it 'configures upgrade_levels' do
        is_expected.to contain_nova_config('upgrade_levels/cert').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/compute').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/conductor').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/scheduler').with_value('1.0.0')

        is_expected.to contain_nova_config('upgrade_levels/cells').with_ensure('absent')
        is_expected.to contain_nova_config('upgrade_levels/intercell').with_ensure('absent')
      end

      it 'configures various things' do
        is_expected.to contain_nova_config('DEFAULT/state_path').with_value('/var/lib/nova2')
        is_expected.to contain_oslo__concurrency('nova_config').with(
          :lock_path => '/var/locky/path'
        )
        is_expected.to contain_nova_config('DEFAULT/service_down_time').with_value('60')
        is_expected.to contain_nova_config('notifications/notification_format').with_value('unversioned')
        is_expected.to contain_nova_config('DEFAULT/report_interval').with_value('10')
        is_expected.to contain_nova_config('DEFAULT/periodic_fuzzy_delay').with_value('61')
        is_expected.to contain_nova_config('vif_plug_ovs/ovsdb_connection').with_value('tcp:127.0.0.1:6640')
        is_expected.to contain_nova_config('DEFAULT/long_rpc_timeout').with_value('1800')
        is_expected.to contain_nova_config('DEFAULT/ssl_only').with_value(true)
        is_expected.to contain_nova_config('DEFAULT/cert').with_value('/etc/ssl/private/snakeoil.pem')
        is_expected.to contain_nova_config('DEFAULT/key').with_value('/etc/ssl/certs/snakeoil.pem')
        is_expected.to contain_nova_config('console/ssl_ciphers').with_value('kEECDH+aECDSA+AES:kEECDH+AES+aRSA:kEDH+aRSA+AES')
        is_expected.to contain_nova_config('console/ssl_minimum_version').with_value('tlsv1_2')
        is_expected.to contain_nova_config('DEFAULT/dhcp_domain').with_value('foo')
        is_expected.to contain_nova_config('DEFAULT/instance_name_template').with_value('instance-%08x');
      end

      context 'with multiple notification_driver' do
        before { params.merge!( :notification_driver => ['ceilometer.compute.nova_notifier', 'nova.openstack.common.notifier.rpc_notifier']) }

        it { is_expected.to contain_oslo__messaging__notifications('nova_config').with(
          :driver => ['ceilometer.compute.nova_notifier', 'nova.openstack.common.notifier.rpc_notifier'],
        ) }
      end
    end

    context 'with notify_on_state_change parameter' do
      let :params do
        { :notify_on_state_change => 'vm_state' }
      end

      it 'configures database' do
        is_expected.to contain_nova_config('notifications/notify_on_state_change').with_value('vm_state')
      end
    end

    context 'with ssh public key' do
      let :params do
        {
          :nova_public_key => {'type' => 'ssh-rsa',
                               'key'  => 'keydata'}
        }
      end

      it 'should install ssh public key' do
        is_expected.to contain_ssh_authorized_key('nova-migration-public-key').with(
          :ensure => 'present',
          :key => 'keydata',
          :type => 'ssh-rsa'
        )
      end
    end

    context 'with ssh public key missing key type' do
      let :params do
        {
          :nova_public_key => {'key'  => 'keydata'}
        }
      end

      it 'should raise an error' do
        expect {
          is_expected.to contain_ssh_authorized_key('nova-migration-public-key').with(
            :ensure => 'present',
            :key => 'keydata'
          )
        }.to raise_error Puppet::Error, /You must provide both a key type and key data./
      end
    end

    context 'with ssh public key missing key data' do
      let :params do
        {
          :nova_public_key => {'type' => 'ssh-rsa'}
        }
      end

      it 'should raise an error' do
        expect {
          is_expected.to contain_ssh_authorized_key('nova-migration-public-key').with(
            :ensure => 'present',
            :key => 'keydata'
          )
        }.to raise_error Puppet::Error, /You must provide both a key type and key data./
      end
    end

    {
      'ssh-rsa'     => 'id_rsa',
      'ssh-dsa'     => 'id_dsa',
      'ssh-ecdsa'   => 'id_ecdsa',
      'ssh-ed25519' => 'id_ed25519'
    }.each do |keytype, keyname|
      context "with ssh private key(#{keytype})" do
        let :params do
          {
            :nova_private_key => {'type' => keytype,
                                  'key'  => 'keydata'}
          }
        end

        it 'should install ssh private key' do
          is_expected.to contain_file("/var/lib/nova/.ssh/#{keyname}").with(
            :content   => 'keydata',
            :mode      => '0600',
            :owner     => 'nova',
            :group     => 'nova',
            :show_diff => false,
          )
        end
      end
    end

    context 'with ssh private key missing key type' do
      let :params do
        {
          :nova_private_key => {'key'  => 'keydata'}
        }
      end

      it 'should raise an error' do
        expect {
          is_expected.to contain_file('/var/lib/nova/.ssh/id_rsa').with(
            :content => 'keydata',
          )
        }.to raise_error Puppet::Error, /You must provide both a key type and key data./
      end
    end

    context 'with ssh private key having incorrect key type' do
      let :params do
        {
          :nova_private_key => {'type' => 'invalid',
                                'key'  => 'keydata'}
        }
      end

      it 'should raise an error' do
        expect {
          is_expected.to contain_file('/var/lib/nova/.ssh/id_rsa').with(
            :content => 'keydata'
          )
        }.to raise_error Puppet::Error, /Unable to determine name of private key file./
      end
    end

    context 'with ssh private key missing key data' do
      let :params do
        {
          :nova_private_key => {'type' => 'ssh-rsa'}
        }
      end

      it 'should raise an error' do
        expect {
          is_expected.to contain_file('/var/lib/nova/.ssh/id_rsa').with(
            :content => 'keydata'
          )
        }.to raise_error Puppet::Error, /You must provide both a key type and key data./
      end
    end

    context 'with SSL socket options set' do
      let :params do
        {
          :use_ssl          => true,
          :enabled_ssl_apis => ['osapi_compute'],
          :cert_file        => '/path/to/cert',
          :ca_file          => '/path/to/ca',
          :key_file         => '/path/to/key',
        }
      end

      it { is_expected.to contain_nova_config('DEFAULT/enabled_ssl_apis').with_value('osapi_compute') }
      it { is_expected.to contain_nova_config('wsgi/ssl_ca_file').with_value('/path/to/ca') }
      it { is_expected.to contain_nova_config('wsgi/ssl_cert_file').with_value('/path/to/cert') }
      it { is_expected.to contain_nova_config('wsgi/ssl_key_file').with_value('/path/to/key') }
    end

    context 'with SSL socket options set with wrong parameters' do
      let :params do
        {
          :use_ssl          => true,
          :enabled_ssl_apis => ['osapi_compute'],
          :ca_file          => '/path/to/ca',
          :key_file         => '/path/to/key',
        }
      end

      it_raises 'a Puppet::Error', /The cert_file parameter is required when use_ssl is set to true/
    end

    context 'with SSL socket options set to false' do
      let :params do
        {
          :use_ssl          => false,
          :enabled_ssl_apis => [],
          :cert_file        => false,
          :ca_file          => false,
          :key_file         => false,
        }
      end

      it { is_expected.to contain_nova_config('DEFAULT/enabled_ssl_apis').with_ensure('absent') }
      it { is_expected.to contain_nova_config('wsgi/ssl_ca_file').with_ensure('absent') }
      it { is_expected.to contain_nova_config('wsgi/ssl_cert_file').with_ensure('absent') }
      it { is_expected.to contain_nova_config('wsgi/ssl_key_file').with_ensure('absent') }
    end

    context 'with allocation ratios set' do
      let :params do
        {
          :cpu_allocation_ratio          => 32.0,
          :ram_allocation_ratio          => 2.0,
          :disk_allocation_ratio         => 1.5,
          :initial_cpu_allocation_ratio  => 64.0,
          :initial_ram_allocation_ratio  => 4.0,
          :initial_disk_allocation_ratio => 3.0,
        }
      end

      it { is_expected.to contain_nova_config('DEFAULT/cpu_allocation_ratio').with_value(32.0) }
      it { is_expected.to contain_nova_config('DEFAULT/ram_allocation_ratio').with_value(2.0) }
      it { is_expected.to contain_nova_config('DEFAULT/disk_allocation_ratio').with_value(1.5) }
      it { is_expected.to contain_nova_config('DEFAULT/initial_cpu_allocation_ratio').with_value(64.0) }
      it { is_expected.to contain_nova_config('DEFAULT/initial_ram_allocation_ratio').with_value(4.0) }
      it { is_expected.to contain_nova_config('DEFAULT/initial_disk_allocation_ratio').with_value(3.0) }
    end

    context 'with array used for console_ssl_ciphers' do
      let :params do
        {
          :console_ssl_ciphers => ['kEECDH+aECDSA+AES', 'kEECDH+AES+aRSA', 'kEDH+aRSA+AES']
        }
      end
      it {is_expected.to contain_nova_config('console/ssl_ciphers').with_value('kEECDH+aECDSA+AES:kEECDH+AES+aRSA:kEDH+aRSA+AES') }
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
        let (:platform_params) do
          { :nova_common_package => 'nova-common',
            :lock_path           => '/var/lock/nova' }
        end
      when 'RedHat'
        let (:platform_params) do
          { :nova_common_package => 'openstack-nova-common',
            :lock_path           => '/var/lib/nova/tmp' }
        end
      end

      it_behaves_like 'nova'

    end
  end

end
