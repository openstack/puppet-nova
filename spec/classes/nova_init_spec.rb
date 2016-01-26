require 'spec_helper'

describe 'nova' do

  shared_examples 'nova' do

    context 'with default parameters' do

     it 'contains the logging class' do
       is_expected.to contain_class('nova::logging')
     end

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

      it { is_expected.to contain_exec('networking-refresh').with(
        :command     => '/sbin/ifdown -a ; /sbin/ifup -a',
        :refreshonly => true
      )}

      it 'configures image service' do
        is_expected.to contain_nova_config('DEFAULT/image_service').with_value('nova.image.glance.GlanceImageService')
        is_expected.to contain_nova_config('glance/api_servers').with_value('localhost:9292')
      end

      it 'configures auth_strategy' do
        is_expected.to contain_nova_config('DEFAULT/auth_strategy').with_value('keystone')
        is_expected.to_not contain_nova_config('DEFAULT/use_deprecated_auth').with_value(false)
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('DEFAULT/rpc_backend').with_value('rabbit')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_host').with_value('localhost')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_password').with_value('guest').with_secret(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_port').with_value('5672')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('/')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('0')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/heartbeat_rate').with_value('2')
      end

      it 'configures various things' do
        is_expected.to contain_nova_config('DEFAULT/state_path').with_value('/var/lib/nova')
        is_expected.to contain_nova_config('oslo_concurrency/lock_path').with_value(platform_params[:lock_path])
        is_expected.to contain_nova_config('DEFAULT/service_down_time').with_value('60')
        is_expected.to contain_nova_config('DEFAULT/notification_driver').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rootwrap_config').with_value('/etc/nova/rootwrap.conf')
        is_expected.to contain_nova_config('DEFAULT/report_interval').with_value('10')
        is_expected.to contain_nova_config('DEFAULT/use_ipv6').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/os_region_name').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_userid').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_host').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_port').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_password').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_virtual_host').with_ensure('absent')
        is_expected.to contain_nova_config('cinder/os_region_name').with_ensure('absent')
        is_expected.to contain_nova_config('cinder/catalog_info').with('value' => 'volumev2:cinderv2:publicURL')
      end

      it 'does not install utilities' do
        is_expected.to_not contain_class('nova::utilities')
      end

    end

    context 'with overridden parameters' do

      let :params do
        { :verbose                            => true,
          :debug                              => true,
          :log_dir                            => '/var/log/nova2',
          :image_service                      => 'nova.image.local.LocalImageService',
          :rabbit_host                        => 'rabbit',
          :rabbit_userid                      => 'rabbit_user',
          :rabbit_port                        => '5673',
          :rabbit_password                    => 'password',
          :rabbit_ha_queues                   => 'undef',
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :lock_path                          => '/var/locky/path',
          :state_path                         => '/var/lib/nova2',
          :service_down_time                  => '120',
          :auth_strategy                      => 'foo',
          :ensure_package                     => '2012.1.1-15.el6',
          :memcached_servers                  => ['memcached01:11211', 'memcached02:11211'],
          :install_utilities                  => true,
          :notification_driver                => 'ceilometer.compute.nova_notifier',
          :notification_topics                => 'openstack',
          :notify_api_faults                  => true,
          :report_interval                    => '60',
          :os_region_name                     => 'MyRegion',
          :use_ipv6                           => true,
          :upgrade_level_cells                => '1.0.0',
          :upgrade_level_cert                 => '1.0.0',
          :upgrade_level_compute              => '1.0.0',
          :upgrade_level_conductor            => '1.0.0',
          :upgrade_level_console              => '1.0.0',
          :upgrade_level_consoleauth          => '1.0.0',
          :upgrade_level_intercell            => '1.0.0',
          :upgrade_level_network              => '1.0.0',
          :upgrade_level_scheduler            => '1.0.0' }
      end

      it 'installs packages' do
        is_expected.to contain_package('nova-common').with('ensure' => '2012.1.1-15.el6')
        is_expected.to contain_package('python-nova').with('ensure' => '2012.1.1-15.el6')
      end

      it 'configures image service' do
        is_expected.to contain_nova_config('DEFAULT/image_service').with_value('nova.image.local.LocalImageService')
        is_expected.to_not contain_nova_config('glance/api_servers')
      end

      it 'configures auth_strategy' do
        is_expected.to contain_nova_config('DEFAULT/auth_strategy').with_value('foo')
        is_expected.to_not contain_nova_config('DEFAULT/use_deprecated_auth').with_value(true)
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('DEFAULT/rpc_backend').with_value('rabbit')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_host').with_value('rabbit')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_password').with_value('password').with_secret(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_port').with_value('5673')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_userid').with_value('rabbit_user')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('/')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('60')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/heartbeat_rate').with_value('10')
      end

      it 'configures memcached_servers' do
        is_expected.to contain_nova_config('keystone_authtoken/memcached_servers').with_value('memcached01:11211,memcached02:11211')
      end

      it 'configures upgrade_levels' do
        is_expected.to contain_nova_config('upgrade_levels/cells').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/cert').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/compute').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/conductor').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/console').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/consoleauth').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/intercell').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/network').with_value('1.0.0')
        is_expected.to contain_nova_config('upgrade_levels/scheduler').with_value('1.0.0')
      end

      it 'configures various things' do
        is_expected.to contain_nova_config('DEFAULT/state_path').with_value('/var/lib/nova2')
        is_expected.to contain_nova_config('oslo_concurrency/lock_path').with_value('/var/locky/path')
        is_expected.to contain_nova_config('DEFAULT/service_down_time').with_value('120')
        is_expected.to contain_nova_config('DEFAULT/notification_driver').with_value('ceilometer.compute.nova_notifier')
        is_expected.to contain_nova_config('DEFAULT/notification_topics').with_value('openstack')
        is_expected.to contain_nova_config('DEFAULT/notify_api_faults').with_value(true)
        is_expected.to contain_nova_config('DEFAULT/report_interval').with_value('60')
        is_expected.to contain_nova_config('DEFAULT/use_ipv6').with_value('true')
        is_expected.to contain_nova_config('cinder/os_region_name').with_value('MyRegion')
        is_expected.to contain_nova_config('DEFAULT/os_region_name').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_userid').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_host').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_port').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_password').with_ensure('absent')
        is_expected.to contain_nova_config('DEFAULT/rabbit_virtual_host').with_ensure('absent')
      end

      context 'with multiple notification_driver' do
        before { params.merge!( :notification_driver => ['ceilometer.compute.nova_notifier', 'nova.openstack.common.notifier.rpc_notifier']) }

        it { is_expected.to contain_nova_config('DEFAULT/notification_driver').with_value(
          'ceilometer.compute.nova_notifier,nova.openstack.common.notifier.rpc_notifier'
        ) }
      end

      it 'installs utilities' do
        is_expected.to contain_class('nova::utilities')
      end

    end

    context 'with wrong notify_on_state_change parameter' do
      let :params do
        { :notify_on_state_change => 'vm_status' }
      end

      it 'configures database' do
        is_expected.to contain_nova_config('DEFAULT/notify_on_state_change').with_ensure('absent')
      end
    end

    context 'with notify_on_state_change parameter' do
      let :params do
        { :notify_on_state_change => 'vm_state' }
      end

      it 'configures database' do
        is_expected.to contain_nova_config('DEFAULT/notify_on_state_change').with_value('vm_state')
      end
    end

    context 'with rabbit_hosts parameter' do
      let :params do
        { :rabbit_hosts => ['rabbit:5673', 'rabbit2:5674'] }
      end

      it 'configures rabbit' do
        is_expected.to_not contain_nova_config('oslo_messaging_rabbit/rabbit_host')
        is_expected.to_not contain_nova_config('oslo_messaging_rabbit/rabbit_port')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_hosts').with_value('rabbit:5673,rabbit2:5674')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(false)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('1.0')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(false)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_version').with_ensure('absent')
      end
    end

    context 'with rabbit_hosts parameter (one server)' do
      let :params do
        { :rabbit_hosts => ['rabbit:5673'] }
      end

      it 'configures rabbit' do
        is_expected.to_not contain_nova_config('oslo_messaging_rabbit/rabbit_host')
        is_expected.to_not contain_nova_config('oslo_messaging_rabbit/rabbit_port')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_hosts').with_value('rabbit:5673')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(false)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('1.0')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(false)
      end
    end

    context 'with kombu_reconnect_delay set to 5.0' do
      let :params do
        { :kombu_reconnect_delay => '5.0' }
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('5.0')
      end
    end

    context 'with rabbit_ha_queues set to true' do
      let :params do
        { :rabbit_ha_queues => 'true' }
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true)
      end
    end

    context 'with rabbit_ha_queues set to false and with rabbit_hosts' do
      let :params do
        { :rabbit_ha_queues => 'false',
          :rabbit_hosts => ['rabbit:5673'] }
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(false)
      end
    end

    context 'with amqp_durable_queues parameter' do
      let :params do
        { :rabbit_hosts => ['rabbit:5673'],
          :amqp_durable_queues => 'true' }
      end

      it 'configures rabbit' do
        is_expected.to_not contain_nova_config('oslo_messaging_rabbit/rabbit_host')
        is_expected.to_not contain_nova_config('oslo_messaging_rabbit/rabbit_port')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_hosts').with_value('rabbit:5673')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(false)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_version').with_ensure('absent')
      end
    end

    context 'with rabbit ssl enabled with kombu' do
      let :params do
        { :rabbit_hosts       => ['rabbit:5673'],
          :rabbit_use_ssl     => 'true',
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1', }
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value('/etc/ca.cert')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value('/etc/certfile')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value('/etc/key')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1')
      end
    end

    context 'with rabbit ssl enabled without kombu' do
      let :params do
        { :rabbit_hosts       => ['rabbit:5673'],
          :rabbit_use_ssl     => 'true', }
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true)
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_version').with_value('TLSv1')
      end
    end

    context 'with rabbit ssl disabled' do
      let :params do
        {
          :rabbit_password    => 'pass',
          :rabbit_use_ssl     => false,
          :kombu_ssl_version  => 'TLSv1',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_nova_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('false')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_ensure('absent')
        is_expected.to contain_nova_config('oslo_messaging_rabbit/kombu_ssl_version').with_ensure('absent')
      end
    end

    context 'with rabbitmq rpc_backend with old parameter' do
      let :params do
        { :rpc_backend => 'nova.openstack.common.rpc.impl_kombu' }
      end

      it { is_expected.to contain_nova_config('DEFAULT/rpc_backend').with_value('nova.openstack.common.rpc.impl_kombu') }
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

    context 'with ssh private key' do
      let :params do
        {
          :nova_private_key => {'type' => 'ssh-rsa',
                                'key'  => 'keydata'}
        }
      end

      it 'should install ssh private key' do
        is_expected.to contain_file('/var/lib/nova/.ssh/id_rsa').with(
          :content => 'keydata'
        )
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
            :content => 'keydata'
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
      it { is_expected.to contain_nova_config('ssl/ca_file').with_value('/path/to/ca') }
      it { is_expected.to contain_nova_config('ssl/cert_file').with_value('/path/to/cert') }
      it { is_expected.to contain_nova_config('ssl/key_file').with_value('/path/to/key') }
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
      it { is_expected.to contain_nova_config('ssl/ca_file').with_ensure('absent') }
      it { is_expected.to contain_nova_config('ssl/cert_file').with_ensure('absent') }
      it { is_expected.to contain_nova_config('ssl/key_file').with_ensure('absent') }
    end

  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      })
    end

    let :platform_params do
      { :nova_common_package => 'nova-common',
        :lock_path           => '/var/lock/nova' }
    end

    it_behaves_like 'nova'
  end

  context 'on Ubuntu platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu'
      })
    end

    let :platform_params do
      { :nova_common_package => 'nova-common',
        :lock_path           => '/var/lock/nova' }
    end

    it_behaves_like 'nova'
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    let :platform_params do
      { :nova_common_package => 'openstack-nova-common',
        :lock_path           => '/var/lib/nova/tmp' }
    end

    it_behaves_like 'nova'

  end
end
