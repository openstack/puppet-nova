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
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $::os_service_default.
#
# [*rpc_backend*]
#   (optional) The rpc backend implementation to use, can be:
#     rabbit (for rabbitmq)
#     zmq (for zeromq)
#   Defaults to $::os_service_default
#
# [*image_service*]
#   (optional) Service used to search for and retrieve images.
#   Defaults to 'nova.image.glance.GlanceImageService'
#
# [*glance_api_servers*]
#   (optional) List of addresses for api servers.
#   Defaults to 'http://localhost:9292'
#
# [*rabbit_host*]
#   (optional) Location of rabbitmq installation. (string value)
#   Defaults to $::os_service_default
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
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $::os_service_default.
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $::os_service_default.
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $::os_service_default.
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $::os_service_default.
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $::os_service_default.
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default.
#
# [*amqp_allow_insecure_clients*]
#   (Optional) Accept clients using either SSL or plain TCP
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
#
# [*host*]
#   (Optional) Name of this node. This is typically a hostname, FQDN, or
#   IP address.
#   Defaults to $::os_service_default.
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
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
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
#   Defaults to $::os_service_default
#
# [*cinder_catalog_info*]
#   (optional) Info to match when looking for cinder in the service
#   catalog. Format is: separated values of the form:
#   <service_type>:<service_name>:<endpoint_type>
#   Defaults to 'volumev2:cinderv2:publicURL'
#
# [*upgrade_level_cells*]
#  (optional) Sets a version cap for messages sent to local cells services
#  Defaults to $::os_service_default
#
# [*upgrade_level_cert*]
#  (optional) Sets a version cap for messages sent to cert services
#  Defaults to $::os_service_default
#
# [*upgrade_level_compute*]
#  (optional) Sets a version cap for messages sent to compute services
#  Defaults to $::os_service_default
#
# [*upgrade_level_conductor*]
#  (optional) Sets a version cap for messages sent to conductor services
#  Defaults to $::os_service_default
#
# [*upgrade_level_console*]
#  (optional) Sets a version cap for messages sent to console services
#  Defaults to $::os_service_default
#
# [*upgrade_level_consoleauth*]
#  (optional) Sets a version cap for messages sent to consoleauth services
#  Defaults to $::os_service_default
#
# [*upgrade_level_intercell*]
#  (optional) Sets a version cap for messages sent between cells services
#  Defaults to $::os_service_default
#
# [*upgrade_level_network*]
#  (optional) Sets a version cap for messages sent to network services
#  Defaults to $::os_service_default
#
# [*upgrade_level_scheduler*]
#  (optional) Sets a version cap for messages sent to scheduler services
#  Defaults to $::os_service_default
#
# [*use_ipv6*]
#   (optional) Use IPv6 or not.
#   Defaults to $::os_service_default
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the nova config.
#   Defaults to false.
#
# [*block_device_allocate_retries*]
#   (optional) Number of times to retry block device allocation on failures
#   Defaults to $::os_service_default
#
# [*block_device_allocate_retries_interval*]
#   (optional) Waiting time interval (seconds) between block device allocation
#   retries on failures
#   Defaults to $::os_service_default
#
# [*cpu_allocation_ratio*]
#   (optional) Virtual CPU to physical CPU allocation ratio which affects all
#   CPU filters.  This can be set on the scheduler, or can be overridden
#   per compute node.
#   Defaults to $::os_service_default
#
# [*ram_allocation_ratio*]
#   (optional) Virtual ram to physical ram allocation ratio which affects all
#   ram filters. This can be set on the scheduler, or can be overridden
#   per compute node.
#   Defaults to $::os_service_default
#
# [*disk_allocation_ratio*]
#   (optional) Virtual disk to physical disk allocation ratio which is used
#   by the disk filter. This can be set on the scheduler, or can be overridden
#   per compute node.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*verbose*]
#   (optional) Set log output to verbose output.
#   Defaults to undef
#
# [*memcached_servers*]
#   (optional) DEPRECATED. Use memcached_servers from
#   nova::keystone::authtoken class instead.
#   memcached server IP's:Memcached Port.
#   Defaults to undef
#
class nova(
  $ensure_package                         = 'present',
  $database_connection                    = undef,
  $slave_connection                       = undef,
  $api_database_connection                = undef,
  $api_slave_connection                   = undef,
  $block_device_allocate_retries          = $::os_service_default,
  $block_device_allocate_retries_interval = $::os_service_default,
  $database_idle_timeout                  = undef,
  $database_min_pool_size                 = undef,
  $database_max_pool_size                 = undef,
  $database_max_retries                   = undef,
  $database_retry_interval                = undef,
  $database_max_overflow                  = undef,
  $default_transport_url                  = $::os_service_default,
  $rpc_response_timeout                   = $::os_service_default,
  $rpc_backend                            = $::os_service_default,
  $image_service                          = 'nova.image.glance.GlanceImageService',
  # these glance params should be optional
  # this should probably just be configured as a glance client
  $glance_api_servers                     = 'http://localhost:9292',
  $rabbit_host                            = $::os_service_default,
  $rabbit_hosts                           = $::os_service_default,
  $rabbit_password                        = $::os_service_default,
  $rabbit_port                            = $::os_service_default,
  $rabbit_userid                          = $::os_service_default,
  $rabbit_virtual_host                    = $::os_service_default,
  $rabbit_use_ssl                         = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold     = $::os_service_default,
  $rabbit_heartbeat_rate                  = $::os_service_default,
  $rabbit_ha_queues                       = $::os_service_default,
  $kombu_ssl_ca_certs                     = $::os_service_default,
  $kombu_ssl_certfile                     = $::os_service_default,
  $kombu_ssl_keyfile                      = $::os_service_default,
  $kombu_ssl_version                      = $::os_service_default,
  $kombu_reconnect_delay                  = $::os_service_default,
  $kombu_compression                      = $::os_service_default,
  $amqp_durable_queues                    = $::os_service_default,
  $amqp_server_request_prefix             = $::os_service_default,
  $amqp_broadcast_prefix                  = $::os_service_default,
  $amqp_group_request_prefix              = $::os_service_default,
  $amqp_container_name                    = $::os_service_default,
  $amqp_idle_timeout                      = $::os_service_default,
  $amqp_trace                             = $::os_service_default,
  $amqp_ssl_ca_file                       = $::os_service_default,
  $amqp_ssl_cert_file                     = $::os_service_default,
  $amqp_ssl_key_file                      = $::os_service_default,
  $amqp_ssl_key_password                  = $::os_service_default,
  $amqp_allow_insecure_clients            = $::os_service_default,
  $amqp_sasl_mechanisms                   = $::os_service_default,
  $amqp_sasl_config_dir                   = $::os_service_default,
  $amqp_sasl_config_name                  = $::os_service_default,
  $amqp_username                          = $::os_service_default,
  $amqp_password                          = $::os_service_default,
  $host                                   = $::os_service_default,
  $auth_strategy                          = 'keystone',
  $service_down_time                      = 60,
  $log_dir                                = undef,
  $state_path                             = '/var/lib/nova',
  $lock_path                              = $::nova::params::lock_path,
  $debug                                  = undef,
  $periodic_interval                      = '60',
  $report_interval                        = '10',
  $rootwrap_config                        = '/etc/nova/rootwrap.conf',
  $use_ssl                                = false,
  $enabled_ssl_apis                       = ['metadata', 'osapi_compute'],
  $ca_file                                = false,
  $cert_file                              = false,
  $key_file                               = false,
  $nova_public_key                        = undef,
  $nova_private_key                       = undef,
  $use_syslog                             = undef,
  $use_stderr                             = undef,
  $log_facility                           = undef,
  $notification_transport_url             = $::os_service_default,
  $notification_driver                    = $::os_service_default,
  $notification_topics                    = $::os_service_default,
  $notify_api_faults                      = false,
  $notify_on_state_change                 = undef,
  $os_region_name                         = $::os_service_default,
  $cinder_catalog_info                    = 'volumev2:cinderv2:publicURL',
  $upgrade_level_cells                    = $::os_service_default,
  $upgrade_level_cert                     = $::os_service_default,
  $upgrade_level_compute                  = $::os_service_default,
  $upgrade_level_conductor                = $::os_service_default,
  $upgrade_level_console                  = $::os_service_default,
  $upgrade_level_consoleauth              = $::os_service_default,
  $upgrade_level_intercell                = $::os_service_default,
  $upgrade_level_network                  = $::os_service_default,
  $upgrade_level_scheduler                = $::os_service_default,
  $use_ipv6                               = $::os_service_default,
  $cpu_allocation_ratio                   = $::os_service_default,
  $ram_allocation_ratio                   = $::os_service_default,
  $disk_allocation_ratio                  = $::os_service_default,
  $purge_config                           = false,
  # DEPRECATED PARAMETERS
  $verbose                                = undef,
  $memcached_servers                      = undef,
) inherits nova::params {

  include ::nova::deps

  # maintain backward compatibility
  include ::nova::db
  include ::nova::logging

  validate_array($enabled_ssl_apis)
  if empty($enabled_ssl_apis) and $use_ssl {
      warning('enabled_ssl_apis is empty but use_ssl is set to true')
  }

  if $verbose {
    warning('verbose is deprecated, has no effect and will be removed after Newton cycle.')
  }

  if $memcached_servers {
    warning('nova::memcached_servers is deprecated, use nova::keystone::authtoken::memcached_servers instead.')
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
        fail("Unable to determine name of private key file.  Type specified was '${nova_private_key['type']}' \
but should be one of: ssh-rsa, ssh-dsa, ssh-ecdsa.")
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

  resources { 'nova_config':
    purge => $purge_config,
  }

  if $image_service == 'nova.image.glance.GlanceImageService' {
    if $glance_api_servers {
      nova_config { 'glance/api_servers': value => $glance_api_servers }
    }
  }

  # maintain backwards compatibility
  $real_cpu_allocation_ratio = pick($::nova::scheduler::filter::cpu_allocation_ratio, $cpu_allocation_ratio)
  ensure_resource('nova_config', 'DEFAULT/cpu_allocation_ratio', { value => $real_cpu_allocation_ratio })
  $real_ram_allocation_ratio = pick($::nova::scheduler::filter::ram_allocation_ratio, $ram_allocation_ratio)
  ensure_resource('nova_config', 'DEFAULT/ram_allocation_ratio', { value => $real_ram_allocation_ratio })
  $real_disk_allocation_ratio = pick($::nova::scheduler::filter::disk_allocation_ratio, $disk_allocation_ratio)
  ensure_resource('nova_config', 'DEFAULT/disk_allocation_ratio', { value => $real_disk_allocation_ratio })

  nova_config {
    'DEFAULT/image_service':                value => $image_service;
    'DEFAULT/auth_strategy':                value => $auth_strategy;
    'DEFAULT/host':                         value => $host;
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
  } elsif $rpc_backend == 'amqp' {
    oslo::messaging::amqp { 'nova_config':
      server_request_prefix  => $amqp_server_request_prefix,
      broadcast_prefix       => $amqp_broadcast_prefix,
      group_request_prefix   => $amqp_group_request_prefix,
      container_name         => $amqp_container_name,
      idle_timeout           => $amqp_idle_timeout,
      trace                  => $amqp_trace,
      ssl_ca_file            => $amqp_ssl_ca_file,
      ssl_cert_file          => $amqp_ssl_cert_file,
      ssl_key_file           => $amqp_ssl_key_file,
      ssl_key_password       => $amqp_ssl_key_password,
      allow_insecure_clients => $amqp_allow_insecure_clients,
      sasl_mechanisms        => $amqp_sasl_mechanisms,
      sasl_config_dir        => $amqp_sasl_config_dir,
      sasl_config_name       => $amqp_sasl_config_name,
      username               => $amqp_username,
      password               => $amqp_password,
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
      'wsgi/ssl_cert_file' :       value => $cert_file;
      'wsgi/ssl_key_file' :        value => $key_file;
    }
    if $ca_file {
      nova_config { 'ssl/ca_file' :
        value => $ca_file,
      }
      nova_config { 'wsgi/ssl_ca_file' :
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

  oslo::messaging::default { 'nova_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
  }

  oslo::messaging::notifications { 'nova_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  nova_config {
    'cinder/catalog_info':                            value => $cinder_catalog_info;
    'DEFAULT/notify_api_faults':                      value => $notify_api_faults;
    # Following may need to be broken out to different nova services
    'DEFAULT/state_path':                             value => $state_path;
    'DEFAULT/service_down_time':                      value => $service_down_time;
    'DEFAULT/rootwrap_config':                        value => $rootwrap_config;
    'DEFAULT/report_interval':                        value => $report_interval;
    'DEFAULT/use_ipv6':                               value => $use_ipv6;
    'DEFAULT/block_device_allocate_retries':          value => $block_device_allocate_retries;
    'DEFAULT/block_device_allocate_retries_interval': value => $block_device_allocate_retries_interval;
  }

  oslo::concurrency { 'nova_config': lock_path => $lock_path }

  if $notify_on_state_change and $notify_on_state_change in ['vm_state', 'vm_and_task_state'] {
    nova_config {
      'DEFAULT/notify_on_state_change': value => $notify_on_state_change;
    }
  } else {
    nova_config { 'DEFAULT/notify_on_state_change': ensure => absent; }
  }

  nova_config {
    'cinder/os_region_name':      value => $os_region_name;
    'upgrade_levels/cells':       value => $upgrade_level_cells;
    'upgrade_levels/cert':        value => $upgrade_level_cert;
    'upgrade_levels/compute':     value => $upgrade_level_compute;
    'upgrade_levels/conductor':   value => $upgrade_level_conductor;
    'upgrade_levels/console':     value => $upgrade_level_console;
    'upgrade_levels/consoleauth': value => $upgrade_level_consoleauth;
    'upgrade_levels/intercell':   value => $upgrade_level_intercell;
    'upgrade_levels/network':     value => $upgrade_level_network;
    'upgrade_levels/scheduler':   value => $upgrade_level_scheduler;
  }

}
