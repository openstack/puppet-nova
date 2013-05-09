#
# installs and configures nova api service
#
# * admin_password
# * enabled
# * ensure_package
# * auth_strategy
# * auth_host
# * auth_port
# * auth_protocol
# * admin_tenant_name
# * admin_user
# * enabled_apis
#
class nova::api(
  $admin_password,
  $enabled           = false,
  $ensure_package    = 'present',
  $auth_strategy     = 'keystone',
  $auth_host         = '127.0.0.1',
  $auth_port         = 35357,
  $auth_protocol     = 'http',
  $admin_tenant_name = 'services',
  $admin_user        = 'nova',
  $api_bind_address  = '0.0.0.0',
  $metadata_listen   = '0.0.0.0',
  $enabled_apis      = 'ec2,osapi_compute,metadata',
  $volume_api_class  = 'nova.volume.cinder.API',
  $workers           = $::processorcount,
  $sync_db           = true
) {

  include nova::params
  require keystone::python

  Package<| title == 'nova-api' |> -> Nova_paste_api_ini<| |>

  Package<| title == 'nova-common' |> -> Class['nova::api']

  Nova_paste_api_ini<| |> ~> Exec['post-nova_config']
  Nova_paste_api_ini<| |> ~> Service['nova-api']

  class {'cinder::client':
     notify         => Service[$::nova::params::api_service_name],
  }

  nova::generic_service { 'api':
    enabled        => $enabled,
    ensure_package => $ensure_package,
    package_name   => $::nova::params::api_package_name,
    service_name   => $::nova::params::api_service_name,
  }

  nova_config {
    'DEFAULT/api_paste_config':      value => '/etc/nova/api-paste.ini';
    'DEFAULT/enabled_apis':          value => $enabled_apis;
    'DEFAULT/volume_api_class':      value => $volume_api_class;
    'DEFAULT/ec2_listen':            value => $api_bind_address;
    'DEFAULT/osapi_compute_listen':  value => $api_bind_address;
    'DEFAULT/metadata_listen':       value => $metadata_listen;
    'DEFAULT/osapi_volume_listen':   value => $api_bind_address;
    'DEFAULT/osapi_compute_workers': value => $workers;
  }

  nova_paste_api_ini {
    'filter:authtoken/auth_host':         value => $auth_host;
    'filter:authtoken/auth_port':         value => $auth_port;
    'filter:authtoken/auth_protocol':     value => $auth_protocol;
    'filter:authtoken/admin_tenant_name': value => $admin_tenant_name;
    'filter:authtoken/admin_user':        value => $admin_user;
    'filter:authtoken/admin_password':    value => $admin_password;
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

  # Added arg and if statement prevents this from being run where db is not active i.e. the compute
  if $sync_db {
    Package<| title == 'nova-api' |> -> Exec['nova-db-sync']
    exec { "nova-db-sync":
      command     => "/usr/bin/nova-manage db sync",
      refreshonly => "true",
      subscribe   => Exec['post-nova_config'],
    }
  }

}
