class nova::api(
  $enabled           = false,
  $ensure_package    = 'present',
  $auth_strategy     = 'keystone',
  $auth_host         = '127.0.0.1',
  $auth_port         = 35357,
  $auth_protocol     = 'http',
  $admin_tenant_name = 'services',
  $admin_user        = 'nova',
  $admin_password    = 'passw0rd',
  $api_bind_address  = '0.0.0.0',
  $enabled_apis      = 'ec2,osapi_compute,osapi_volume,metadata'
) {

  include nova::params

  $auth_uri = "${auth_protocol}://${auth_host}:${auth_port}/v2.0"

  exec { 'initial-db-sync':
    command     => '/usr/bin/nova-manage db sync',
    refreshonly => true,
    require     => [Package[$::nova::params::common_package_name], Nova_config['sql_connection']],
  }

  Package<| title == 'nova-api' |> -> Exec['initial-db-sync']
  Package<| title == 'nova-api' |> -> File['/etc/nova/api-paste.ini']


  nova::generic_service { 'api':
    enabled        => $enabled,
    ensure_package => $ensure_package,
    package_name   => $::nova::params::api_package_name,
    service_name   => $::nova::params::api_service_name,
  }

  if 'occiapi' in $enabled_apis {
    if !defined(Package['python-pip']) {
        package {'python-pip':
                ensure => latest,
        }
    }
    if !defined(Package['pyssf']){
        package {'pyssf':
            provider => pip,
            ensure   => latest,
            require  => Package['python-pip']
        }
    }
    package { 'openstackocci' :
      provider  => 'pip',
      ensure    => latest,
      require => Package['python-pip'],
    }
  }

  nova_config { 'enabled_apis': value => $enabled_apis; }

  nova_config { 'api_paste_config': value => '/etc/nova/api-paste.ini'; }

  nova_config {
    'ec2_listen':           value => $api_bind_address;
    'osapi_compute_listen': value => $api_bind_address;
    'metadata_listen':      value => $api_bind_address;
    'osapi_volume_listen':  value => $api_bind_address;
  }

  file { '/etc/nova/api-paste.ini':
    content => template('nova/api-paste.ini.erb'),
    require => Class['nova'],
    notify  => Service['nova-api'],
  }
}
