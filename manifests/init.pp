# == Class: nova
#
# This class is used to specify configuration parameters that are common
# across all nova services.
#
# === Parameters:
#
# [*ensure_package*]
#   (optional) The state of nova packages
#   Defaults to 'present'
#
# [*database_connection*]
#   (optional) Connection url for the nova database.
#   Defaults to undef.
#
# [*slave_connection*]
#   (optional) Connection url to connect to nova slave database (read-only).
#   Defaults to undef.
#
# [*database_max_retries*]
#   (optional) Maximum database connection retries during startup.
#   Defaults to undef.
#
# [*database_idle_timeout*]
#   (optional) Timeout before idle database connections are reaped.
#   Defaults to undef.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to undef.
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to: undef.
#
# [*rpc_backend*]
#   (optional) The rpc backend implementation to use, can be:
#     rabbit (for rabbitmq)
#     qpid (for qpid)
#     zmq (for zeromq)
#   Defaults to 'rabbit'
#
# [*image_service*]
#   (optional) Service used to search for and retrieve images.
#   Defaults to 'nova.image.glance.GlanceImageService'
#
# [*glance_api_servers*]
#   (optional) List of addresses for api servers.
#   Defaults to 'localhost:9292'
#
# [*memcached_servers*]
#   (optional) Use memcached instead of in-process cache. Supply a list of memcached server IP's:Memcached Port.
#   Defaults to false
#
# [*rabbit_host*]
#   (optional) Location of rabbitmq installation.
#   Defaults to 'localhost'
#
# [*rabbit_hosts*]
#   (optional) List of clustered rabbit servers.
#   Defaults to undef
#
# [*rabbit_port*]
#   (optional) Port for rabbitmq instance.
#   Defaults to '5672'
#
# [*rabbit_password*]
#   (optional) Password used to connect to rabbitmq.
#   Defaults to 'guest'
#
# [*rabbit_userid*]
#   (optional) User used to connect to rabbitmq.
#   Defaults to 'guest'
#
# [*rabbit_virtual_host*]
#   (optional) The RabbitMQ virtual host.
#   Defaults to '/'
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to false
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ.
#   Defaults to undef
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to 0
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to 2
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to undef
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to undef
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to undef
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to 'TLSv1'
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to '1.0'
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to false
#
# [*auth_strategy*]
#   (optional) The strategy to use for auth: noauth or keystone.
#   Defaults to 'keystone'
#
# [*service_down_time*]
#   (optional) Maximum time since last check-in for up service.
#   Defaults to 60
#
# [*log_dir*]
#   (optional) Directory where logs should be stored.
#   If set to boolean false, it will not log to any directory.
#   Defaults to undef
#
# [*state_path*]
#   (optional) Directory for storing state.
#   Defaults to '/var/lib/nova'
#
# [*lock_path*]
#   (optional) Directory for lock files.
#   On RHEL will be '/var/lib/nova/tmp' and on Debian '/var/lock/nova'
#   Defaults to $::nova::params::lock_path
#
# [*verbose*]
#   (optional) Set log output to verbose output.
#   Defaults to undef
#
# [*debug*]
#   (optional) Set log output to debug output.
#   Defaults to undef
#
# [*periodic_interval*]
#   (optional) Seconds between running periodic tasks.
#   Defaults to '60'
#
# [*report_interval*]
#   (optional) Interval at which nodes report to data store.
#    Defaults to '10'
#
# [*rootwrap_config*]
#   (optional) Path to the rootwrap configuration file to use for running commands as root
#   Defaults to '/etc/nova/rootwrap.conf'
#
# [*use_syslog*]
#   (optional) Use syslog for logging
#   Defaults to undef
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef
#
# [*log_facility*]
#   (optional) Syslog facility to receive log lines.
#   Defaults to undef
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false, not set
#
# [*enabled_ssl_apis*]
#   (optional) List of APIs to SSL enable
#   Defaults to []
#   Possible values : 'osapi_compute', 'metadata'
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to false, not set
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to false, not set
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to false, not set_
#
# [*nova_public_key*]
#   (optional) Install public key in .ssh/authorized_keys for the 'nova' user.
#   Expects a hash of the form { type => 'key-type', key => 'key-data' } where
#   'key-type' is one of (ssh-rsa, ssh-dsa, ssh-ecdsa) and 'key-data' is the
#   actual key data (e.g, 'AAAA...').
#
# [*nova_private_key*]
#   (optional) Install private key into .ssh/id_rsa (or appropriate equivalent
#   for key type).  Expects a hash of the form { type => 'key-type', key =>
#   'key-data' }, where 'key-type' is one of (ssh-rsa, ssh-dsa, ssh-ecdsa) and
#   'key-data' is the contents of the private key file.
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to undef
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to 'notifications'
#
# [*notify_api_faults*]
#   (optional) If set, send api.fault notifications on caught
#   exceptions in the API service
#   Defaults to false
#
# [*notify_on_state_change*]
#   (optional) If set, send compute.instance.update notifications
#   on instance state changes. Valid values are None for no notifications,
#   "vm_state" for notifications on VM state changes, or "vm_and_task_state"
#   for notifications on VM and task state changes.
#   Defaults to undef
#
# [*os_region_name*]
#   (optional) Sets the os_region_name flag. For environments with
#   more than one endpoint per service, this is required to make
#   things such as cinder volume attach work. If you don't set this
#   and you have multiple endpoints, you will get AmbiguousEndpoint
#   exceptions in the nova API service.
#   Defaults to undef
#
# [*cinder_catalog_info*]
#   (optional) Info to match when looking for cinder in the service
#   catalog. Format is: separated values of the form:
#   <service_type>:<service_name>:<endpoint_type>
#   Defaults to 'volumev2:cinderv2:publicURL'
#
# [*upgrade_level_cells*]
#  (optional) Sets a version cap for messages sent to local cells services
#  Defaults to undef
#
# [*upgrade_level_cert*]
#  (optional) Sets a version cap for messages sent to cert services
#  Defaults to undef
#
# [*upgrade_level_compute*]
#  (optional) Sets a version cap for messages sent to compute services
#  Defaults to undef
#
# [*upgrade_level_conductor*]
#  (optional) Sets a version cap for messages sent to conductor services
#  Defaults to undef
#
# [*upgrade_level_console*]
#  (optional) Sets a version cap for messages sent to console services
#  Defaults to undef
#
# [*upgrade_level_consoleauth*]
#  (optional) Sets a version cap for messages sent to consoleauth services
#  Defaults to undef
#
# [*upgrade_level_intercell*]
#  (optional) Sets a version cap for messages sent between cells services
#  Defaults to undef
#
# [*upgrade_level_network*]
#  (optional) Sets a version cap for messages sent to network services
#  Defaults to undef
#
# [*upgrade_level_scheduler*]
#  (optional) Sets a version cap for messages sent to scheduler services
#  Defaults to undef
#
# [*use_ipv6*]
#   (optional) Use IPv6 or not.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*qpid_hostname*]
#   (optional) Location of qpid server
#   Defaults to undef
#
# [*qpid_port*]
#   (optional) Port for qpid server
#   Defaults to undef
#
# [*qpid_username*]
#   (optional) Username to use when connecting to qpid
#   Defaults to undef
#
# [*qpid_password*]
#   (optional) Password to use when connecting to qpid
#   Defaults to undef
#
# [*qpid_heartbeat*]
#   (optional) Seconds between connection keepalive heartbeats
#   Defaults to undef
#
# [*qpid_protocol*]
#   (optional) Transport to use, either 'tcp' or 'ssl''
#   Defaults to undef
#
# [*qpid_sasl_mechanisms*]
#   (optional) Enable one or more SASL mechanisms
#   Defaults to undef
#
# [*qpid_tcp_nodelay*]
#   (optional) Disable Nagle algorithm
#   Defaults to undef
#
# [*install_utilities*]
#   (optional) Install nova utilities (Extra packages used by nova tools)
#   Defaults to undef
#
class nova(
  $ensure_package                     = 'present',
  $database_connection                = undef,
  $slave_connection                   = undef,
  $database_idle_timeout              = undef,
  $database_min_pool_size             = undef,
  $database_max_pool_size             = undef,
  $database_max_retries               = undef,
  $database_retry_interval            = undef,
  $database_max_overflow              = undef,
  $rpc_backend                        = 'rabbit',
  $image_service                      = 'nova.image.glance.GlanceImageService',
  # these glance params should be optional
  # this should probably just be configured as a glance client
  $glance_api_servers                 = 'localhost:9292',
  $memcached_servers                  = false,
  $rabbit_host                        = 'localhost',
  $rabbit_hosts                       = undef,
  $rabbit_password                    = 'guest',
  $rabbit_port                        = '5672',
  $rabbit_userid                      = 'guest',
  $rabbit_virtual_host                = '/',
  $rabbit_use_ssl                     = false,
  $rabbit_heartbeat_timeout_threshold = 0,
  $rabbit_heartbeat_rate              = 2,
  $rabbit_ha_queues                   = undef,
  $kombu_ssl_ca_certs                 = undef,
  $kombu_ssl_certfile                 = undef,
  $kombu_ssl_keyfile                  = undef,
  $kombu_ssl_version                  = 'TLSv1',
  $kombu_reconnect_delay              = '1.0',
  $amqp_durable_queues                = false,
  $auth_strategy                      = 'keystone',
  $service_down_time                  = 60,
  $log_dir                            = undef,
  $state_path                         = '/var/lib/nova',
  $lock_path                          = $::nova::params::lock_path,
  $verbose                            = undef,
  $debug                              = undef,
  $periodic_interval                  = '60',
  $report_interval                    = '10',
  $rootwrap_config                    = '/etc/nova/rootwrap.conf',
  $use_ssl                            = false,
  $enabled_ssl_apis                   = ['metadata', 'osapi_compute'],
  $ca_file                            = false,
  $cert_file                          = false,
  $key_file                           = false,
  $nova_public_key                    = undef,
  $nova_private_key                   = undef,
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_facility                       = undef,
  $notification_driver                = undef,
  $notification_topics                = 'notifications',
  $notify_api_faults                  = false,
  $notify_on_state_change             = undef,
  $os_region_name                     = undef,
  $cinder_catalog_info                = 'volumev2:cinderv2:publicURL',
  $upgrade_level_cells                = undef,
  $upgrade_level_cert                 = undef,
  $upgrade_level_compute              = undef,
  $upgrade_level_conductor            = undef,
  $upgrade_level_console              = undef,
  $upgrade_level_consoleauth          = undef,
  $upgrade_level_intercell            = undef,
  $upgrade_level_network              = undef,
  $upgrade_level_scheduler            = undef,
  $use_ipv6                           = $::os_service_default,
  # DEPRECATED PARAMETERS
  $qpid_hostname                      = undef,
  $qpid_port                          = undef,
  $qpid_username                      = undef,
  $qpid_password                      = undef,
  $qpid_sasl_mechanisms               = undef,
  $qpid_heartbeat                     = undef,
  $qpid_protocol                      = undef,
  $qpid_tcp_nodelay                   = undef,
  $install_utilities                  = undef,
) inherits nova::params {

  include ::nova::deps

  # maintain backward compatibility
  include ::nova::db
  include ::nova::logging

  validate_array($enabled_ssl_apis)
  if empty($enabled_ssl_apis) and $use_ssl {
      warning('enabled_ssl_apis is empty but use_ssl is set to true')
  }

  if $use_ssl {
    if !$cert_file {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if !$key_file {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  if $kombu_ssl_ca_certs and !$rabbit_use_ssl {
    fail('The kombu_ssl_ca_certs parameter requires rabbit_use_ssl to be set to true')
  }
  if $kombu_ssl_certfile and !$rabbit_use_ssl {
    fail('The kombu_ssl_certfile parameter requires rabbit_use_ssl to be set to true')
  }
  if $kombu_ssl_keyfile and !$rabbit_use_ssl {
    fail('The kombu_ssl_keyfile parameter requires rabbit_use_ssl to be set to true')
  }
  if ($kombu_ssl_certfile and !$kombu_ssl_keyfile) or ($kombu_ssl_keyfile and !$kombu_ssl_certfile) {
    fail('The kombu_ssl_certfile and kombu_ssl_keyfile parameters must be used together')
  }

  if $nova_public_key or $nova_private_key {
    file { '/var/lib/nova/.ssh':
      ensure  => directory,
      mode    => '0700',
      owner   => 'nova',
      group   => 'nova',
      require => Anchor['nova::config::begin'],
      before  => Anchor['nova::config::end'],
    }

    if $nova_public_key {
      if ! $nova_public_key['key'] or ! $nova_public_key['type'] {
        fail('You must provide both a key type and key data.')
      }

      ssh_authorized_key { 'nova-migration-public-key':
        ensure  => present,
        key     => $nova_public_key['key'],
        type    => $nova_public_key['type'],
        user    => 'nova',
        require => File['/var/lib/nova/.ssh'],
      }
    }

    if $nova_private_key {
      if ! $nova_private_key[key] or ! $nova_private_key['type'] {
        fail('You must provide both a key type and key data.')
      }

      $nova_private_key_file = $nova_private_key['type'] ? {
        'ssh-rsa'   => '/var/lib/nova/.ssh/id_rsa',
        'ssh-dsa'   => '/var/lib/nova/.ssh/id_dsa',
        'ssh-ecdsa' => '/var/lib/nova/.ssh/id_ecdsa',
        default     => undef
      }

      if ! $nova_private_key_file {
        fail("Unable to determine name of private key file.  Type specified was '${nova_private_key['type']}' but should be one of: ssh-rsa, ssh-dsa, ssh-ecdsa.")
      }

      file { $nova_private_key_file:
        content => $nova_private_key[key],
        mode    => '0600',
        owner   => 'nova',
        group   => 'nova',
        require => File['/var/lib/nova/.ssh'],
      }
    }
  }

  if $install_utilities {
    class { '::nova::utilities': }
  }

  package { 'python-nova':
    ensure => $ensure_package,
    tag    => ['openstack', 'nova-package'],
  }

  package { 'nova-common':
    ensure  => $ensure_package,
    name    => $::nova::params::common_package_name,
    require => Package['python-nova'],
    tag     => ['openstack', 'nova-package'],
  }

  # used by debian/ubuntu in nova::network_bridge to refresh
  # interfaces based on /etc/network/interfaces
  exec { 'networking-refresh':
    command     => '/sbin/ifdown -a ; /sbin/ifup -a',
    refreshonly => true,
  }

  nova_config { 'DEFAULT/image_service': value => $image_service }

  if $image_service == 'nova.image.glance.GlanceImageService' {
    if $glance_api_servers {
      nova_config { 'glance/api_servers': value => $glance_api_servers }
    }
  }

  nova_config { 'DEFAULT/auth_strategy': value => $auth_strategy }

  if $memcached_servers {
    nova_config { 'DEFAULT/memcached_servers': value  => join($memcached_servers, ',') }
  } else {
    nova_config { 'DEFAULT/memcached_servers': ensure => absent }
  }

  # we keep "nova.openstack.common.rpc.impl_kombu" for backward compatibility
  # but since Icehouse, "rabbit" is enough.
  if $rpc_backend == 'nova.openstack.common.rpc.impl_kombu' or $rpc_backend == 'rabbit' {
    # I may want to support exporting and collecting these
    nova_config {
      'oslo_messaging_rabbit/rabbit_password':              value => $rabbit_password, secret => true;
      'oslo_messaging_rabbit/rabbit_userid':                value => $rabbit_userid;
      'oslo_messaging_rabbit/rabbit_virtual_host':          value => $rabbit_virtual_host;
      'oslo_messaging_rabbit/rabbit_use_ssl':               value => $rabbit_use_ssl;
      'oslo_messaging_rabbit/heartbeat_timeout_threshold':  value => $rabbit_heartbeat_timeout_threshold;
      'oslo_messaging_rabbit/heartbeat_rate':               value => $rabbit_heartbeat_rate;
      'oslo_messaging_rabbit/kombu_reconnect_delay':        value => $kombu_reconnect_delay;
      'oslo_messaging_rabbit/amqp_durable_queues':          value => $amqp_durable_queues;
    }

    if $rabbit_use_ssl {

      if $kombu_ssl_ca_certs {
        nova_config { 'oslo_messaging_rabbit/kombu_ssl_ca_certs': value => $kombu_ssl_ca_certs; }
      } else {
        nova_config { 'oslo_messaging_rabbit/kombu_ssl_ca_certs': ensure => absent; }
      }

      if $kombu_ssl_certfile or $kombu_ssl_keyfile {
        nova_config {
          'oslo_messaging_rabbit/kombu_ssl_certfile': value => $kombu_ssl_certfile;
          'oslo_messaging_rabbit/kombu_ssl_keyfile':  value => $kombu_ssl_keyfile;
        }
      } else {
        nova_config {
          'oslo_messaging_rabbit/kombu_ssl_certfile': ensure => absent;
          'oslo_messaging_rabbit/kombu_ssl_keyfile':  ensure => absent;
        }
      }

      if $kombu_ssl_version {
        nova_config { 'oslo_messaging_rabbit/kombu_ssl_version':  value => $kombu_ssl_version; }
      } else {
        nova_config { 'oslo_messaging_rabbit/kombu_ssl_version':  ensure => absent; }
      }

    } else {
      nova_config {
        'oslo_messaging_rabbit/kombu_ssl_ca_certs': ensure => absent;
        'oslo_messaging_rabbit/kombu_ssl_certfile': ensure => absent;
        'oslo_messaging_rabbit/kombu_ssl_keyfile':  ensure => absent;
        'oslo_messaging_rabbit/kombu_ssl_version':  ensure => absent;
      }
    }

    if $rabbit_hosts {
      nova_config { 'oslo_messaging_rabbit/rabbit_hosts':     value => join($rabbit_hosts, ',') }
    } else {
      nova_config { 'oslo_messaging_rabbit/rabbit_host':      value => $rabbit_host }
      nova_config { 'oslo_messaging_rabbit/rabbit_port':      value => $rabbit_port }
      nova_config { 'oslo_messaging_rabbit/rabbit_hosts':     value => "${rabbit_host}:${rabbit_port}" }
    }

    if $rabbit_ha_queues == undef {
      if $rabbit_hosts {
        nova_config { 'oslo_messaging_rabbit/rabbit_ha_queues': value => true }
      } else {
        nova_config { 'oslo_messaging_rabbit/rabbit_ha_queues': value => false }
      }
    } else {
      nova_config { 'oslo_messaging_rabbit/rabbit_ha_queues': value => $rabbit_ha_queues }
    }
  }

  # we keep "nova.openstack.common.rpc.impl_qpid" for backward compatibility
  # but since Icehouse, "qpid" is enough.
  if $rpc_backend == 'nova.openstack.common.rpc.impl_qpid' or $rpc_backend == 'qpid' {
    warning('Qpid driver is removed from Oslo.messaging in the Mitaka release')
  }

  # SSL Options
  if $use_ssl {
    nova_config {
      'DEFAULT/enabled_ssl_apis' : value => join($enabled_ssl_apis, ',');
      'DEFAULT/ssl_cert_file' :    value => $cert_file;
      'DEFAULT/ssl_key_file' :     value => $key_file;
    }
    if $ca_file {
      nova_config { 'DEFAULT/ssl_ca_file' :
        value => $ca_file,
      }
    } else {
      nova_config { 'DEFAULT/ssl_ca_file' :
        ensure => absent,
      }
    }
  } else {
    nova_config {
      'DEFAULT/enabled_ssl_apis' : ensure => absent;
      'DEFAULT/ssl_cert_file' :    ensure => absent;
      'DEFAULT/ssl_key_file' :     ensure => absent;
      'DEFAULT/ssl_ca_file' :      ensure => absent;
    }
  }

  if $notification_driver {
    nova_config {
      'DEFAULT/notification_driver': value => join(any2array($notification_driver), ',');
    }
  } else {
    nova_config { 'DEFAULT/notification_driver': ensure => absent; }
  }

  nova_config {
    'cinder/catalog_info':         value => $cinder_catalog_info;
    'DEFAULT/rpc_backend':         value => $rpc_backend;
    'DEFAULT/notification_topics': value => $notification_topics;
    'DEFAULT/notify_api_faults':   value => $notify_api_faults;
    # Following may need to be broken out to different nova services
    'DEFAULT/state_path':          value => $state_path;
    'DEFAULT/lock_path':           value => $lock_path;
    'DEFAULT/service_down_time':   value => $service_down_time;
    'DEFAULT/rootwrap_config':     value => $rootwrap_config;
    'DEFAULT/report_interval':     value => $report_interval;
    'DEFAULT/use_ipv6':            value => $use_ipv6;
  }

  if $notify_on_state_change and $notify_on_state_change in ['vm_state', 'vm_and_task_state'] {
    nova_config {
      'DEFAULT/notify_on_state_change': value => $notify_on_state_change;
    }
  } else {
    nova_config { 'DEFAULT/notify_on_state_change': ensure => absent; }
  }

  if $os_region_name {
    nova_config {
      'cinder/os_region_name':    value => $os_region_name;
    }
  }
  else {
    nova_config {
      'cinder/os_region_name':    ensure => absent;
    }
  }

  if $upgrade_level_cells {
    nova_config {
      'upgrade_levels/cells':   value => $upgrade_level_cells;
    }
  }
  else {
    nova_config {
      'upgrade_levels/cells':   ensure => absent;
    }
  }

  if $upgrade_level_cert {
    nova_config {
      'upgrade_levels/cert':   value => $upgrade_level_cert;
    }
  }
  else {
    nova_config {
      'upgrade_levels/cert':   ensure => absent;
    }
  }

  if $upgrade_level_compute {
    nova_config {
      'upgrade_levels/compute':   value => $upgrade_level_compute;
    }
  }
  else {
    nova_config {
      'upgrade_levels/compute':   ensure => absent;
    }
  }

  if $upgrade_level_conductor {
    nova_config {
      'upgrade_levels/conductor':   value => $upgrade_level_conductor;
    }
  }
  else {
    nova_config {
      'upgrade_levels/conductor':   ensure => absent;
    }
  }

  if $upgrade_level_console {
    nova_config {
      'upgrade_levels/console':   value => $upgrade_level_console;
    }
  }
  else {
    nova_config {
      'upgrade_levels/console':   ensure => absent;
    }
  }

  if $upgrade_level_consoleauth {
    nova_config {
      'upgrade_levels/consoleauth':   value => $upgrade_level_consoleauth;
    }
  }
  else {
    nova_config {
      'upgrade_levels/consoleauth':   ensure => absent;
    }
  }

  if $upgrade_level_intercell {
    nova_config {
      'upgrade_levels/intercell':   value => $upgrade_level_intercell;
    }
  }
  else {
    nova_config {
      'upgrade_levels/intercell':   ensure => absent;
    }
  }

  if $upgrade_level_network {
    nova_config {
      'upgrade_levels/network':   value => $upgrade_level_network;
    }
  }
  else {
    nova_config {
      'upgrade_levels/network':   ensure => absent;
    }
  }

  if $upgrade_level_scheduler {
    nova_config {
      'upgrade_levels/scheduler':   value => $upgrade_level_scheduler;
    }
  }
  else {
    nova_config {
      'upgrade_levels/scheduler':   ensure => absent;
    }
  }

  # Deprecated in Juno, removed in Kilo
  nova_config {
    'DEFAULT/os_region_name':       ensure => absent;
  }
}
