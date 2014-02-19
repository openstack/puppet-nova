require 'spec_helper'

describe 'nova' do

  shared_examples 'nova' do

    context 'with default parameters' do

      it 'installs packages' do
        should contain_package('python').with_ensure('present')
        should contain_package('python-greenlet').with(
          :ensure  => 'present',
          :require => 'Package[python]'
        )
        should contain_package('python-nova').with(
          :ensure  => 'present',
          :require => 'Package[python-greenlet]'
        )
        should contain_package('nova-common').with(
          :name   => platform_params[:nova_common_package],
          :ensure => 'present'
        )
      end

      it 'creates user and group' do
        should contain_group('nova').with(
          :ensure  => 'present',
          :system  => true,
          :require => 'Package[nova-common]'
        )
        should contain_user('nova').with(
          :ensure  => 'present',
          :gid     => 'nova',
          :system  => true,
          :require => 'Package[nova-common]'
        )
      end

      it 'creates various files and folders' do
        should contain_file('/var/log/nova').with(
          :ensure  => 'directory',
          :mode    => '0750',
          :owner   => 'nova',
          :group   => 'nova',
          :require => 'Package[nova-common]'
        )
        should contain_file('/etc/nova/nova.conf').with(
          :mode    => '0640',
          :owner   => 'nova',
          :group   => 'nova',
          :require => 'Package[nova-common]'
        )
      end

      it 'configures rootwrap' do
        should contain_nova_config('DEFAULT/rootwrap_config').with_value('/etc/nova/rootwrap.conf')
      end

      it { should contain_exec('networking-refresh').with(
        :command     => '/sbin/ifdown -a ; /sbin/ifup -a',
        :refreshonly => true
      )}

      it 'configures database' do
        should_not contain_nova_config('database/connection')
        should_not contain_nova_config('database/idle_timeout').with_value('3600')
      end

      it 'configures image service' do
        should contain_nova_config('DEFAULT/image_service').with_value('nova.image.glance.GlanceImageService')
        should contain_nova_config('DEFAULT/glance_api_servers').with_value('localhost:9292')
      end

      it 'configures auth_strategy' do
        should contain_nova_config('DEFAULT/auth_strategy').with_value('keystone')
        should_not contain_nova_config('DEFAULT/use_deprecated_auth').with_value(false)
      end

      it 'configures rabbit' do
        should contain_nova_config('DEFAULT/rpc_backend').with_value('nova.openstack.common.rpc.impl_kombu')
        should contain_nova_config('DEFAULT/rabbit_host').with_value('localhost')
        should contain_nova_config('DEFAULT/rabbit_password').with_value('guest').with_secret(true)
        should contain_nova_config('DEFAULT/rabbit_port').with_value('5672')
        should contain_nova_config('DEFAULT/rabbit_userid').with_value('guest')
        should contain_nova_config('DEFAULT/rabbit_virtual_host').with_value('/')
      end

      it 'configures various things' do
        should contain_nova_config('DEFAULT/verbose').with_value(false)
        should contain_nova_config('DEFAULT/debug').with_value(false)
        should contain_nova_config('DEFAULT/log_dir').with_value('/var/log/nova')
        should contain_nova_config('DEFAULT/state_path').with_value('/var/lib/nova')
        should contain_nova_config('DEFAULT/lock_path').with_value(platform_params[:lock_path])
        should contain_nova_config('DEFAULT/service_down_time').with_value('60')
        should contain_nova_config('DEFAULT/rootwrap_config').with_value('/etc/nova/rootwrap.conf')
        should_not contain_nova_config('DEFAULT/notification_driver')
      end

      it 'disables syslog' do
        should contain_nova_config('DEFAULT/use_syslog').with_value(false)
      end
    end

    context 'with overridden parameters' do

      let :params do
        { :database_connection      => 'mysql://user:pass@db/db',
          :database_idle_timeout    => '30',
          :verbose                  => true,
          :debug                    => true,
          :log_dir                  => '/var/log/nova2',
          :image_service            => 'nova.image.local.LocalImageService',
          :rabbit_host              => 'rabbit',
          :rabbit_userid            => 'rabbit_user',
          :rabbit_port              => '5673',
          :rabbit_password          => 'password',
          :lock_path                => '/var/locky/path',
          :state_path               => '/var/lib/nova2',
          :service_down_time        => '120',
          :auth_strategy            => 'foo',
          :ensure_package           => '2012.1.1-15.el6',
          :monitoring_notifications => true,
          :memcached_servers        => ['memcached01:11211', 'memcached02:11211'] }
      end

      it 'installs packages' do
        should contain_package('nova-common').with('ensure' => '2012.1.1-15.el6')
        should contain_package('python-nova').with('ensure' => '2012.1.1-15.el6')
      end

      it 'configures database' do
        should contain_nova_config('database/connection').with_value('mysql://user:pass@db/db').with_secret(true)
        should contain_nova_config('database/idle_timeout').with_value('30')
      end

      it 'configures image service' do
        should contain_nova_config('DEFAULT/image_service').with_value('nova.image.local.LocalImageService')
        should_not contain_nova_config('DEFAULT/glance_api_servers')
      end

      it 'configures auth_strategy' do
        should contain_nova_config('DEFAULT/auth_strategy').with_value('foo')
        should_not contain_nova_config('DEFAULT/use_deprecated_auth').with_value(true)
      end

      it 'configures rabbit' do
        should contain_nova_config('DEFAULT/rpc_backend').with_value('nova.openstack.common.rpc.impl_kombu')
        should contain_nova_config('DEFAULT/rabbit_host').with_value('rabbit')
        should contain_nova_config('DEFAULT/rabbit_password').with_value('password').with_secret(true)
        should contain_nova_config('DEFAULT/rabbit_port').with_value('5673')
        should contain_nova_config('DEFAULT/rabbit_userid').with_value('rabbit_user')
        should contain_nova_config('DEFAULT/rabbit_virtual_host').with_value('/')
      end

      it 'configures memcached_servers' do
        should contain_nova_config('DEFAULT/memcached_servers').with_value('memcached01:11211,memcached02:11211')
      end

      it 'configures various things' do
        should contain_nova_config('DEFAULT/verbose').with_value(true)
        should contain_nova_config('DEFAULT/debug').with_value(true)
        should contain_nova_config('DEFAULT/log_dir').with_value('/var/log/nova2')
        should contain_nova_config('DEFAULT/state_path').with_value('/var/lib/nova2')
        should contain_nova_config('DEFAULT/lock_path').with_value('/var/locky/path')
        should contain_nova_config('DEFAULT/service_down_time').with_value('120')
        should contain_nova_config('DEFAULT/notification_driver').with_value('nova.openstack.common.notifier.rpc_notifier')
      end

      context 'with logging directory disabled' do
        before { params.merge!( :log_dir => false) }

        it { should contain_nova_config('DEFAULT/log_dir').with_ensure('absent') }
      end

    end

    context 'with deprecated sql parameters' do
      let :params do
        { :sql_connection   => 'mysql://user:pass@db/db',
          :sql_idle_timeout => '30' }
      end

      it 'configures database' do
        should contain_nova_config('database/connection').with_value('mysql://user:pass@db/db').with_secret(true)
        should contain_nova_config('database/idle_timeout').with_value('30')
      end
    end

    context 'with syslog enabled' do
      let :params do
        { :use_syslog => 'true' }
      end

      it 'configures syslog' do
        should contain_nova_config('DEFAULT/use_syslog').with_value(true)
        should contain_nova_config('DEFAULT/syslog_log_facility').with_value('LOG_USER')
      end
    end

    context 'with syslog enabled and log_facility parameter' do
      let :params do
        { :use_syslog   => 'true',
          :log_facility => 'LOG_LOCAL0' }
      end

      it 'configures syslog' do
        should contain_nova_config('DEFAULT/use_syslog').with_value(true)
        should contain_nova_config('DEFAULT/syslog_log_facility').with_value('LOG_LOCAL0')
      end
    end

    context 'with rabbit_hosts parameter' do
      let :params do
        { :rabbit_hosts => ['rabbit:5673', 'rabbit2:5674'] }
      end

      it 'configures rabbit' do
        should_not contain_nova_config('DEFAULT/rabbit_host')
        should_not contain_nova_config('DEFAULT/rabbit_port')
        should contain_nova_config('DEFAULT/rabbit_hosts').with_value('rabbit:5673,rabbit2:5674')
        should contain_nova_config('DEFAULT/rabbit_ha_queues').with_value(true)
      end
    end

    context 'with rabbit_hosts parameter (one server)' do
      let :params do
        { :rabbit_hosts => ['rabbit:5673'] }
      end

      it 'configures rabbit' do
        should_not contain_nova_config('DEFAULT/rabbit_host')
        should_not contain_nova_config('DEFAULT/rabbit_port')
        should contain_nova_config('DEFAULT/rabbit_hosts').with_value('rabbit:5673')
        should contain_nova_config('DEFAULT/rabbit_ha_queues').with_value(true)
      end
    end

    context 'with qpid rpc_backend' do
      let :params do
        { :rpc_backend => 'nova.openstack.common.rpc.impl_qpid' }
      end

      context 'with default parameters' do
        it 'configures qpid' do
          should contain_nova_config('DEFAULT/rpc_backend').with_value('nova.openstack.common.rpc.impl_qpid')
          should contain_nova_config('DEFAULT/qpid_hostname').with_value('localhost')
          should contain_nova_config('DEFAULT/qpid_port').with_value('5672')
          should contain_nova_config('DEFAULT/qpid_username').with_value('guest')
          should contain_nova_config('DEFAULT/qpid_password').with_value('guest').with_secret(true)
          should contain_nova_config('DEFAULT/qpid_heartbeat').with_value('60')
          should contain_nova_config('DEFAULT/qpid_protocol').with_value('tcp')
          should contain_nova_config('DEFAULT/qpid_tcp_nodelay').with_value(true)
        end
      end

      context 'with qpid_password parameter (without qpid_sasl_mechanisms)' do
        before do
          params.merge!({ :qpid_password => 'guest' })
        end
        it { should contain_nova_config('DEFAULT/qpid_sasl_mechanisms').with_ensure('absent') }
      end

      context 'with qpid_password parameter (with qpid_sasl_mechanisms)' do
        before do
          params.merge!({
            :qpid_password        => 'guest',
            :qpid_sasl_mechanisms => 'A'
          })
        end
        it { should contain_nova_config('DEFAULT/qpid_sasl_mechanisms').with_value('A') }
      end

      context 'with qpid_password parameter (with array of qpid_sasl_mechanisms)' do
        before do
          params.merge!({
            :qpid_password        => 'guest',
            :qpid_sasl_mechanisms => [ 'DIGEST-MD5', 'GSSAPI', 'PLAIN' ]
          })
        end
        it { should contain_nova_config('DEFAULT/qpid_sasl_mechanisms').with_value('DIGEST-MD5 GSSAPI PLAIN') }
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :nova_common_package => 'nova-common',
        :lock_path           => '/var/lock/nova' }
    end

    it_behaves_like 'nova'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :nova_common_package => 'openstack-nova-common',
        :lock_path           => '/var/lib/nova/tmp' }
    end

    it_behaves_like 'nova'
  end
end
