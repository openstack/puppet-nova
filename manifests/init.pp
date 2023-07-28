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
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $facts['os_service_default'].
#
# [*long_rpc_timeout*]
#   (Optional) An alternative timeout value for RPC calls that have
#   the potential to take a long time.
#   Defaults to $facts['os_service_default'].
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $facts['os_service_default']
#
# [*executor_thread_pool_size*]
#   (Optional) Size of executor thread pool when executor is threading or eventlet.
#   Defaults to $facts['os_service_default'].
#
# [*rabbit_use_ssl*]
#   (optional) Boolean. Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   Requires kombu >= 3.0.7 and amqp >= 1.4.0. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period
#   to check the heartbeat on RabbitMQ connection.
#   i.e. rabbit_heartbeat_rate=2 when rabbit_heartbeat_timeout_threshold=60,
#   the heartbeat will be checked every 30 seconds. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_retry_interval*]
#   (Optional) How frequently to retry connecting with RabbitMQ.
#   (integer value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification. (floating point value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may not be available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $facts['os_service_default'].
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $facts['os_service_default'].
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $facts['os_service_default'].
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $facts['os_service_default'].
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $facts['os_service_default'].
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $facts['os_service_default'].
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $facts['os_service_default'].
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $facts['os_service_default'].
#
# [*host*]
#   (Optional) Name of this node. This is typically a hostname, FQDN, or
#   IP address.
#   Defaults to $facts['os_service_default'].
#
# [*service_down_time*]
#   (optional) Maximum time since last check-in for up service.
#   Defaults to $facts['os_service_default'].
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
# [*report_interval*]
#   (optional) Interval at which nodes report to data store.
#   Defaults to $facts['os_service_default']
#
# [*periodic_fuzzy_delay*]
#   (otional) Number of seconds to randomly delay when starting the periodic
#   task scheduler to reduce stampeding.
#   Defaults to $facts['os_service_default']
#
# [*rootwrap_config*]
#   (optional) Path to the rootwrap configuration file to use for running commands as root
#   Defaults to '/etc/nova/rootwrap.conf'
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
#   (optional) Certificate file to use when starting API server securely
#   Defaults to false, not set
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to false, not set
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to false, not set
#
# [*nova_public_key*]
#   (optional) Install public key in .ssh/authorized_keys for the 'nova' user.
#   Expects a hash of the form { type => 'key-type', key => 'key-data' } where
#   'key-type' is one of (ssh-rsa, ssh-dsa, ssh-ecdsa, ssh-ed25519) and
#   'key-data' is the actual key data (e.g, 'AAAA...').
#
# [*nova_private_key*]
#   (optional) Install private key into .ssh/id_rsa (or appropriate equivalent
#   for key type).  Expects a hash of the form { type => 'key-type', key =>
#   'key-data' }, where 'key-type' is one of (ssh-rsa, ssh-dsa, ssh-ecdsa,
#   ssh-ed25519) and 'key-data' is the contents of the private key file.
#
# [*ssl_only*]
#   (optional) Disallow non-encrypted connections.
#   Defaults to $facts['os_service_default']
#
# [*cert*]
#   (optional) Path to SSL certificate file.
#   Defaults to $facts['os_service_default']
#
# [*key*]
#   (optional) SSL key file (if separate from cert).
#   Defaults to $facts['os_service_default']
#
# [*console_ssl_ciphers*]
#   (optional) OpenSSL cipher preference string that specifies what ciphers to
#   allow for TLS connections from clients.  See the man page for the OpenSSL
#   'ciphers' command for details of the cipher preference string format and
#   allowed values.
#   Defaults to $facts['os_service_default']
#
# [*console_ssl_minimum_version*]
#   (optional) Minimum allowed SSL/TLS protocol version.  Valid values are
#   'default', 'tlsv1_1', 'tlsv1_2', and 'tlsv1_3'.  A value of 'default' will
#   use the underlying system OpenSSL defaults.
#   Defaults to $facts['os_service_default']
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $facts['os_service_default'].
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to facts['os_service_default']
#
# [*notification_format*]
#   (optional) Format used for OpenStack notifications
#   Defaults to facts['os_service_default']
#
# [*notify_on_state_change*]
#   (optional) If set, send compute.instance.update notifications
#   on instance state changes. Valid values are None for no notifications,
#   "vm_state" for notifications on VM state changes, or "vm_and_task_state"
#   for notifications on VM and task state changes.
#   Defaults to facts['os_service_default']
#
# [*ovsdb_connection*]
#   (optional) Sets the ovsdb connection string. This is used by os-vif
#   to interact with openvswitch on the host.
#   Defaults to $facts['os_service_default']
#
# [*upgrade_level_compute*]
#  (optional) Sets a version cap for messages sent to compute services
#  Defaults to $facts['os_service_default']
#
# [*upgrade_level_conductor*]
#  (optional) Sets a version cap for messages sent to conductor services
#  Defaults to $facts['os_service_default']
#
# [*upgrade_level_scheduler*]
#  (optional) Sets a version cap for messages sent to scheduler services
#  Defaults to $facts['os_service_default']
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the nova config.
#   Defaults to false.
#
# [*cpu_allocation_ratio*]
#   (optional) Virtual CPU to physical CPU allocation ratio which affects all
#   CPU filters.  This can be set on the scheduler, or can be overridden
#   per compute node.
#   Defaults to $facts['os_service_default']
#
# [*ram_allocation_ratio*]
#   (optional) Virtual ram to physical ram allocation ratio which affects all
#   ram filters. This can be set on the scheduler, or can be overridden
#   per compute node.
#   Defaults to $facts['os_service_default']
#
# [*disk_allocation_ratio*]
#   (optional) Virtual disk to physical disk allocation ratio which is used
#   by the disk filter. This can be set on the scheduler, or can be overridden
#   per compute node.
#   Defaults to $facts['os_service_default']
#
# [*initial_cpu_allocation_ratio*]
#   (optional) Initial virtual CPU to physical CPU allocation ratio.
#   Defaults to $facts['os_service_default']
#
# [*initial_ram_allocation_ratio*]
#   (optional) Initial virtual RAM to physical RAM allocation ratio.
#   Defaults to $facts['os_service_default']
#
# [*initial_disk_allocation_ratio*]
#   (optional) Initial virtual disk to physical disk allocation ratio.
#   Defaults to $facts['os_service_default']
#
# [*my_ip*]
#   (optional) IP address of this host on the management network.
#   If unset, will determine the IP programmatically based on the default route.
#   If unable to do so, will use "127.0.0.1".
#   Defaults to $facts['os_service_default'].
#
# [*dhcp_domain*]
#   (optional) domain to use for building the hostnames
#   Defaults to $facts['os_service_default']
#
# [*instance_name_template*]
#   (optional) Template string to be used to generate instance names
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
# [*auth_strategy*]
#   (optional) The strategy to use for auth: noauth or keystone.
#   Defaults to undef
#
# [*upgrade_level_cert*]
#  (optional) Sets a version cap for messages sent to cert services
#  Defaults to undef
#
# [*upgrade_level_cells*]
#  (optional) Sets a version cap for messages sent to local cells services
#  Defaults to undef
#
# [*upgrade_level_intercell*]
#  (optional) Sets a version cap for messages sent between cells services
#  Defaults to undef
#
# [*periodic_interval*]
#  (optional) Seconds between running periodic tasks.
#  Defaults to undef
#
class nova(
  $ensure_package                         = 'present',
  $default_transport_url                  = $facts['os_service_default'],
  $rpc_response_timeout                   = $facts['os_service_default'],
  $long_rpc_timeout                       = $facts['os_service_default'],
  $control_exchange                       = $facts['os_service_default'],
  $executor_thread_pool_size              = $facts['os_service_default'],
  $rabbit_use_ssl                         = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold     = $facts['os_service_default'],
  $rabbit_heartbeat_rate                  = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread            = $facts['os_service_default'],
  $rabbit_ha_queues                       = $facts['os_service_default'],
  $rabbit_retry_interval                  = $facts['os_service_default'],
  $kombu_ssl_ca_certs                     = $facts['os_service_default'],
  $kombu_ssl_certfile                     = $facts['os_service_default'],
  $kombu_ssl_keyfile                      = $facts['os_service_default'],
  $kombu_ssl_version                      = $facts['os_service_default'],
  $kombu_reconnect_delay                  = $facts['os_service_default'],
  $kombu_failover_strategy                = $facts['os_service_default'],
  $kombu_compression                      = $facts['os_service_default'],
  $amqp_durable_queues                    = $facts['os_service_default'],
  $amqp_server_request_prefix             = $facts['os_service_default'],
  $amqp_broadcast_prefix                  = $facts['os_service_default'],
  $amqp_group_request_prefix              = $facts['os_service_default'],
  $amqp_container_name                    = $facts['os_service_default'],
  $amqp_idle_timeout                      = $facts['os_service_default'],
  $amqp_trace                             = $facts['os_service_default'],
  $amqp_ssl_ca_file                       = $facts['os_service_default'],
  $amqp_ssl_cert_file                     = $facts['os_service_default'],
  $amqp_ssl_key_file                      = $facts['os_service_default'],
  $amqp_ssl_key_password                  = $facts['os_service_default'],
  $amqp_sasl_mechanisms                   = $facts['os_service_default'],
  $amqp_sasl_config_dir                   = $facts['os_service_default'],
  $amqp_sasl_config_name                  = $facts['os_service_default'],
  $amqp_username                          = $facts['os_service_default'],
  $amqp_password                          = $facts['os_service_default'],
  $host                                   = $facts['os_service_default'],
  $service_down_time                      = $facts['os_service_default'],
  $state_path                             = '/var/lib/nova',
  $lock_path                              = $::nova::params::lock_path,
  $report_interval                        = $facts['os_service_default'],
  $periodic_fuzzy_delay                   = $facts['os_service_default'],
  $rootwrap_config                        = '/etc/nova/rootwrap.conf',
  Boolean $use_ssl                        = false,
  Array[String[1]] $enabled_ssl_apis      = ['metadata', 'osapi_compute'],
  $ca_file                                = false,
  $cert_file                              = false,
  $key_file                               = false,
  Optional[Hash] $nova_public_key         = undef,
  Optional[Hash] $nova_private_key        = undef,
  $ssl_only                               = $facts['os_service_default'],
  $cert                                   = $facts['os_service_default'],
  $key                                    = $facts['os_service_default'],
  $console_ssl_ciphers                    = $facts['os_service_default'],
  $console_ssl_minimum_version            = $facts['os_service_default'],
  $notification_transport_url             = $facts['os_service_default'],
  $notification_driver                    = $facts['os_service_default'],
  $notification_topics                    = $facts['os_service_default'],
  $notification_format                    = $facts['os_service_default'],
  $notify_on_state_change                 = $facts['os_service_default'],
  $ovsdb_connection                       = $facts['os_service_default'],
  $upgrade_level_compute                  = $facts['os_service_default'],
  $upgrade_level_conductor                = $facts['os_service_default'],
  $upgrade_level_scheduler                = $facts['os_service_default'],
  $cpu_allocation_ratio                   = $facts['os_service_default'],
  $ram_allocation_ratio                   = $facts['os_service_default'],
  $disk_allocation_ratio                  = $facts['os_service_default'],
  $initial_cpu_allocation_ratio           = $facts['os_service_default'],
  $initial_ram_allocation_ratio           = $facts['os_service_default'],
  $initial_disk_allocation_ratio          = $facts['os_service_default'],
  Boolean $purge_config                   = false,
  $my_ip                                  = $facts['os_service_default'],
  $dhcp_domain                            = $facts['os_service_default'],
  $instance_name_template                 = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $auth_strategy                          = undef,
  $upgrade_level_cert                     = undef,
  $upgrade_level_cells                    = undef,
  $upgrade_level_intercell                = undef,
  $periodic_interval                      = undef,
) inherits nova::params {

  include nova::deps
  include nova::workarounds

  if empty($enabled_ssl_apis) and $use_ssl {
      warning('enabled_ssl_apis is empty but use_ssl is set to true')
  }

  if $upgrade_level_cert != undef {
    warning("The upgrade_level_cert parameter is deprecated and will be removed \
in a future release.")
  }

  [ 'upgrade_level_cells', 'upgrade_level_intercell' ].each |String $ug_cell_opt| {
    if getvar($ug_cell_opt) != undef {
      warning("The ${ug_cell_opt} is deprecated and has no effect.")
    }
  }

  if $periodic_interval != undef {
    warning('The periodic_interval parameter is deprecated and has no effect.')
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
      owner   => $::nova::params::user,
      group   => $::nova::params::group,
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
        user    => $::nova::params::user,
        require => File['/var/lib/nova/.ssh'],
      }
    }

    if $nova_private_key {
      if ! $nova_private_key['key'] or ! $nova_private_key['type'] {
        fail('You must provide both a key type and key data.')
      }

      $nova_private_key_file = $nova_private_key['type'] ? {
        'ssh-rsa'     => '/var/lib/nova/.ssh/id_rsa',
        'ssh-dsa'     => '/var/lib/nova/.ssh/id_dsa',
        'ssh-ecdsa'   => '/var/lib/nova/.ssh/id_ecdsa',
        'ssh-ed25519' => '/var/lib/nova/.ssh/id_ed25519',
        default       => undef
      }

      if ! $nova_private_key_file {
        fail("Unable to determine name of private key file.  Type specified was '${nova_private_key['type']}' \
but should be one of: ssh-rsa, ssh-dsa, ssh-ecdsa, ssh-ed25519.")
      }

      file { $nova_private_key_file:
        content => $nova_private_key[key],
        mode    => '0600',
        owner   => $::nova::params::user,
        group   => $::nova::params::group,
        require => File['/var/lib/nova/.ssh'],
      }
    }
  }

  package { 'python-nova':
    ensure => $ensure_package,
    name   => $::nova::params::python_package_name,
    tag    => ['openstack', 'nova-package'],
  }

  package { 'nova-common':
    ensure  => $ensure_package,
    name    => $::nova::params::common_package_name,
    require => Package['python-nova'],
    tag     => ['openstack', 'nova-package'],
  }

  resources { 'nova_config':
    purge => $purge_config,
  }

  if $auth_strategy {
    warning('The auth_strategy parameter is deprecated, and will be removed in a future release.')
  }
  nova_config {
    'api/auth_strategy': value => pick($auth_strategy, $facts['os_service_default'])
  }

  nova_config {
    'DEFAULT/ssl_only':                      value => $ssl_only;
    'DEFAULT/cert':                          value => $cert;
    'DEFAULT/key':                           value => $key;
    'console/ssl_ciphers':                   value => join(any2array($console_ssl_ciphers), ':');
    'console/ssl_minimum_version':           value => $console_ssl_minimum_version;
    'DEFAULT/my_ip':                         value => $my_ip;
    'DEFAULT/host':                          value => $host;
    'DEFAULT/cpu_allocation_ratio':          value => $cpu_allocation_ratio;
    'DEFAULT/ram_allocation_ratio':          value => $ram_allocation_ratio;
    'DEFAULT/disk_allocation_ratio':         value => $disk_allocation_ratio;
    'DEFAULT/initial_cpu_allocation_ratio':  value => $initial_cpu_allocation_ratio;
    'DEFAULT/initial_ram_allocation_ratio':  value => $initial_ram_allocation_ratio;
    'DEFAULT/initial_disk_allocation_ratio': value => $initial_disk_allocation_ratio;
    'DEFAULT/dhcp_domain':                   value => $dhcp_domain;
    'DEFAULT/instance_name_template':        value => $instance_name_template;
  }

  oslo::messaging::rabbit {'nova_config':
    rabbit_use_ssl              => $rabbit_use_ssl,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    heartbeat_in_pthread        => $rabbit_heartbeat_in_pthread,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_failover_strategy     => $kombu_failover_strategy,
    amqp_durable_queues         => $amqp_durable_queues,
    kombu_compression           => $kombu_compression,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_version           => $kombu_ssl_version,
    rabbit_ha_queues            => $rabbit_ha_queues,
    rabbit_retry_interval       => $rabbit_retry_interval,
  }

  oslo::messaging::amqp { 'nova_config':
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
    username              => $amqp_username,
    password              => $amqp_password,
  }

  # SSL Options
  if $use_ssl {
    nova_config {
      'DEFAULT/enabled_ssl_apis': value => join($enabled_ssl_apis, ',');
      'wsgi/ssl_cert_file':       value => $cert_file;
      'wsgi/ssl_key_file':        value => $key_file;
    }

    if $ca_file {
      nova_config {
        'wsgi/ssl_ca_file': value => $ca_file;
      }
    } else {
      nova_config {
        'wsgi/ssl_ca_file': ensure => absent;
      }
    }
  } else {
    nova_config {
      'DEFAULT/enabled_ssl_apis': ensure => absent;
      'wsgi/ssl_cert_file':       ensure => absent;
      'wsgi/ssl_key_file':        ensure => absent;
      'wsgi/ssl_ca_file':         ensure => absent;
    }
  }

  oslo::messaging::default { 'nova_config':
    executor_thread_pool_size => $executor_thread_pool_size,
    transport_url             => $default_transport_url,
    rpc_response_timeout      => $rpc_response_timeout,
    control_exchange          => $control_exchange,
  }

  nova_config {
    'DEFAULT/long_rpc_timeout': value => $long_rpc_timeout;
  }

  oslo::messaging::notifications { 'nova_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  nova_config {
    'vif_plug_ovs/ovsdb_connection':        value  => $ovsdb_connection;
    'notifications/notification_format':    value  => $notification_format;
    'notifications/notify_on_state_change': value  => $notify_on_state_change;
    # Following may need to be broken out to different nova services
    'DEFAULT/state_path':                   value => $state_path;
    'DEFAULT/service_down_time':            value => $service_down_time;
    'DEFAULT/rootwrap_config':              value => $rootwrap_config;
    'DEFAULT/report_interval':              value => $report_interval;
    'DEFAULT/periodic_fuzzy_delay':         value => $periodic_fuzzy_delay;
  }

  oslo::concurrency { 'nova_config': lock_path => $lock_path }

  nova_config {
    'upgrade_levels/cert':        value => pick($upgrade_level_cert, $facts['os_service_default']);
    'upgrade_levels/compute':     value => $upgrade_level_compute;
    'upgrade_levels/conductor':   value => $upgrade_level_conductor;
    'upgrade_levels/scheduler':   value => $upgrade_level_scheduler;
  }

  nova_config {
    'upgrade_levels/cells':     ensure => absent;
    'upgrade_levels/intercell': ensure => absent;
  }
}
