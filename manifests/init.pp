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
# [*api_database_connection*]
#   (optional) Connection url for the nova API database.
#   Defaults to undef.
#
# [*api_slave_connection*]
#   (optional) Connection url to connect to nova API slave database (read-only).
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
#     zmq (for zeromq)
#   Defaults to 'rabbit'
#
# [*image_service*]
#   (optional) Service used to search for and retrieve images.
#   Defaults to 'nova.image.glance.GlanceImageService'
#
# [*glance_api_servers*]
#   (optional) List of addresses for api servers.
#   Defaults to 'http://localhost:9292'
#
# [*memcached_servers*]
#   (optional) Use memcached instead of in-process cache. Supply a list of memcached server IP's:Memcached Port.
#   Defaults to $::os_service_default.
#
# [*rabbit_host*]
#   (optional) Location of rabbitmq installation. (string value)
#   Defaults to 'localhost'
#
# [*rabbit_hosts*]
#   (optional) List of clustered rabbit servers. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_port*]
#   (optional) Port for rabbitmq instance. (port value)
#   Defaults to $::os_service_default
#
# [*rabbit_password*]
#   (optional) Password used to connect to rabbitmq. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_userid*]
#   (optional) User used to connect to rabbitmq. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_virtual_host*]
#   (optional) The RabbitMQ virtual host. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (optional) Boolean. Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   Requires kombu >= 3.0.7 and amqp >= 1.4.0. (integer value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period
#   to check the heartbeat on RabbitMQ connection.
#   i.e. rabbit_heartbeat_rate=2 when rabbit_heartbeat_timeout_threshold=60,
#   the heartbeat will be checked every 30 seconds. (integer value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification. (floating point value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq. (boolean value)
#   Defaults to $::os_service_default
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
#   Defaults to $::os_service_default.
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to ::os_service_default
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
# [*install_utilities*]
#   (optional) Install nova utilities (Extra packages used by nova tools)
#   Defaults to undef
#
# [*verbose*]
#   (optional) Set log output to verbose output.
#   Defaults to undef
#
class nova(
  $ensure_package                     = 'present',
  $database_connection                = undef,
  $slave_connection                   = undef,
  $api_database_connection            = undef,
  $api_slave_connection               = undef,
  $database_idle_timeout              = undef,
  $database_min_pool_size             = undef,
  $database_max_pool_size             = undef,
  $database_max_retries               = undef,
  $database_retry_interval            = undef,
  $database_max_overflow              = undef,
  $rpc_backend                        = $::os_service_default,
  $image_service                      = 'nova.image.glance.GlanceImageService',
  # these glance params should be optional
  # this should probably just be configured as a glance client
  $glance_api_servers                 = 'http://localhost:9292',
  $memcached_servers                  = $::os_service_default,
  $rabbit_host                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $auth_strategy                      = 'keystone',
  $service_down_time                  = 60,
  $log_dir                            = undef,
  $state_path                         = '/var/lib/nova',
  $lock_path                          = $::nova::params::lock_path,
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
  $notification_driver                = $::os_service_default,
  $notification_topics                = $::os_service_default,
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
  $install_utilities                  = undef,
  $verbose                            = undef,
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

  if $image_service == 'nova.image.glance.GlanceImageService' {
    if $glance_api_servers {
      nova_config { 'glance/api_servers': value => $glance_api_servers }
    }
  }

  nova_config {
    'DEFAULT/image_service':                value => $image_service;
    'DEFAULT/auth_strategy':                value => $auth_strategy;
    'keystone_authtoken/memcached_servers': value => join(any2array($memcached_servers), ',');
  }

  # we keep "nova.openstack.common.rpc.impl_kombu" for backward compatibility
  # but since Icehouse, "rabbit" is enough.
  if $rpc_backend in [$::os_service_default, 'nova.openstack.common.rpc.impl_kombu', 'rabbit'] {
    oslo::messaging::rabbit {'nova_config':
      rabbit_password             => $rabbit_password,
      rabbit_userid               => $rabbit_userid,
      rabbit_virtual_host         => $rabbit_virtual_host,
      rabbit_use_ssl              => $rabbit_use_ssl,
      heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
      heartbeat_rate              => $rabbit_heartbeat_rate,
      kombu_reconnect_delay       => $kombu_reconnect_delay,
      amqp_durable_queues         => $amqp_durable_queues,
      kombu_compression           => $kombu_compression,
      kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
      kombu_ssl_certfile          => $kombu_ssl_certfile,
      kombu_ssl_keyfile           => $kombu_ssl_keyfile,
      kombu_ssl_version           => $kombu_ssl_version,
      rabbit_hosts                => $rabbit_hosts,
      rabbit_host                 => $rabbit_host,
      rabbit_port                 => $rabbit_port,
      rabbit_ha_queues            => $rabbit_ha_queues,
    }
  } else {
    nova_config { 'DEFAULT/rpc_backend': value => $rpc_backend }
  }

  # SSL Options
  if $use_ssl {
    nova_config {
      'DEFAULT/enabled_ssl_apis' : value => join($enabled_ssl_apis, ',');
      'ssl/cert_file' :            value => $cert_file;
      'ssl/key_file' :             value => $key_file;
      'DEFAULT/ssl_cert_file' :    value => $cert_file;
      'DEFAULT/ssl_key_file' :     value => $key_file;
    }
    if $ca_file {
      nova_config { 'ssl/ca_file' :
        value => $ca_file,
      }
      nova_config { 'DEFAULT/ssl_ca_file' :
        value => $ca_file,
      }
    } else {
      nova_config { 'ssl/ca_file' :
        ensure => absent,
      }
    }
  } else {
    nova_config {
      'DEFAULT/enabled_ssl_apis' : ensure => absent;
      'ssl/cert_file' :            ensure => absent;
      'ssl/key_file' :             ensure => absent;
      'ssl/ca_file' :              ensure => absent;
    }
  }

  oslo::messaging::notifications { 'nova_config':
    driver => $notification_driver,
    topics => $notification_topics,
  }

  nova_config {
    'cinder/catalog_info':         value => $cinder_catalog_info;
    'DEFAULT/notify_api_faults':   value => $notify_api_faults;
    # Following may need to be broken out to different nova services
    'DEFAULT/state_path':          value => $state_path;
    'DEFAULT/service_down_time':   value => $service_down_time;
    'DEFAULT/rootwrap_config':     value => $rootwrap_config;
    'DEFAULT/report_interval':     value => $report_interval;
    'DEFAULT/use_ipv6':            value => $use_ipv6;
  }

  oslo::concurrency { 'nova_config': lock_path => $lock_path }

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

  # Deprecated in Juno, removed in Kilo
  nova_config {
    'DEFAULT/rabbit_userid':       ensure => absent;
    'DEFAULT/rabbit_host':         ensure => absent;
    'DEFAULT/rabbit_port':         ensure => absent;
    'DEFAULT/rabbit_password':     ensure => absent;
    'DEFAULT/rabbit_virtual_host': ensure => absent;
  }

}
