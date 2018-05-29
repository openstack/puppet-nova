# == Class: nova::metadata::novajoin::api
#
# The nova::metadata::novajoin::api class encapsulates an
# IPA Nova Join API service.
#
# === Parameters
#
# [*service_password*]
#   (required) Password for the novajoin service user.
#
# [*transport_url*]
#   (required) Transport URL for notifier service to talk to
#   the messaging queue.
#
# [*bind_address*]
#   (optional) IP address for novajoin server to listen
#   Defaults to '127.0.0.1'
#
# [*api_paste_config*]
#   (optional) Filename for the paste deploy file.
#   Defaults to '/etc/novajoin/join-api-paste.ini'.
#
# [*auth_strategy*]
#   (optional) Strategy to use for authentication.
#   Defaults to 'keystone'.
#
# [*auth_type*]
#   (optional) Authentication type.
#   Defaults to 'password'.
#
# [*cacert*]
#   (optional) CA cert file.
#   Defaults to '/etc/ipa/ca.crt'.
#
# [*connect_retries*]
#   (optional) Number of connection retries to IPA.
#   Defaults to 1.
#
# [*debug*]
#   (optional) Set log level to debug.
#   Defaults to false.
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true.
#
# [*enable_ipa_client_install*]
#   (optional) whether to perform ipa_client_install
#   Defaults to true.
#
# [*ensure_package*]
#   (optional) The state of novajoin packages.
#   Defaults to 'present'
#
# [*ipa_domain*]
#   (optional) IPA domain
#   Reads the value from /etc/ipa/default.conf if not defined.
#
# [*join_listen_port*]
#   (optional) Port for novajoin service to listen on.
#   Defaults to 9090
#
# [*keystone_auth_url*]
#   (optional) auth_url for the keystone instance.
#   Defaults to 'http:://127.0.0.1:5000'
#
# [*keytab*]
#   (optional) Kerberos client keytab file.
#   Defaults to '/etc/novajoin/krb5.keytab'
#
# [*log_dir*]
#   (optional) log directory.
#   Defaults to '/var/log/novajoin'
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*service_user*]
#   (optional) User that the novajoin services run as.
#   Defaults to 'novajoin'
#
# [*project_domain_name*]
#   (optional) Domain name containing project (for novajoin auth).
#   Defaults to 'default'
#
# [*project_name*]
#   (optional) Project name (for novajoin auth).
#   Defaults to 'service'
#
# [*user_domain_id*]
#   (optional) Domain for novajoin user.
#   Defaults to 'default'
#
# [*configure_kerberos*]
#   (optional) Whether or not to create a kerberos configuration file.
#   Defaults to false
#
# [*ipa_realm*]
#   (optional) Kerberos realm. If left empty, the kerberos configuration will
#   take the domain and upcase it.
#   Defaults to undef
#
class nova::metadata::novajoin::api (
  $transport_url,
  $bind_address              = '127.0.0.1',
  $api_paste_config          = '/etc/novajoin/join-api-paste.ini',
  $auth_strategy             = $::os_service_default,
  $auth_type                 = 'password',
  $cacert                    = '/etc/ipa/ca.crt',
  $connect_retries           = $::os_service_default,
  $debug                     = $::os_service_default,
  $enabled                   = true,
  $enable_ipa_client_install = true,
  $ensure_package            = 'present',
  $ipa_domain                = undef,
  $join_listen_port          = $::os_service_default,
  $keystone_auth_url         = 'http://127.0.0.1:5000/',
  $keytab                    = '/etc/novajoin/krb5.keytab',
  $log_dir                   = '/var/log/novajoin',
  $manage_service            = true,
  $service_password          = undef,
  $service_user              = 'novajoin',
  $project_domain_name       = 'default',
  $project_name              = 'service',
  $user_domain_id            = 'default',
  $configure_kerberos        = false,
  $ipa_realm                 = undef,
) {
  include ::nova::metadata::novajoin::authtoken

  if ! $service_user {
    fail('service_user is missing')
  }

  if ! $service_password {
    fail('service_password is missing')
  }

  case $::osfamily {
    'RedHat': {
      $package_name        = 'python-novajoin'
      $service_name        = 'novajoin-server'
      $notify_service_name = 'novajoin-notify'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }
  } # Case $::osfamily

  if $enable_ipa_client_install {
    require ::ipaclient
    # If we're installing IPA here, the hostname fact won't be populated yet,
    # so we'll use a command to get it.
    $ipa_hostname_real = '`grep xmlrpc_uri /etc/ipa/default.conf | cut -d/ -f3`'
  } else {
    # This assumes that the current node is already IPA enrolled, so the
    # fact will work here.
    $ipa_hostname_real = $::ipa_hostname
  }

  package { 'python-novajoin':
    ensure => $ensure_package,
    name   => $package_name,
    tag    => ['openstack', 'novajoin-package'],
  }

  file { '/var/log/novajoin':
    ensure  => directory,
    owner   => $service_user,
    group   => $service_user,
    recurse => true,
  }

  if $ipa_domain != undef {
    novajoin_config {
      'DEFAULT/domain': value => $ipa_domain;
    }
    $ipa_domain_real = $ipa_domain
  } else {
    $ipa_domain_real = $::domain
  }

  if $configure_kerberos {
    if $ipa_realm != undef {
      $ipa_realm_real
    } else {
      $ipa_realm_real = upcase($ipa_domain_real)
    }

    file { '/etc/novajoin/krb5.conf':
      content => template('nova/krb5.conf.erb'),
      owner   => $service_user,
      group   => $service_user,
    }
  }

  novajoin_config {
    'DEFAULT/join_listen':                     value => $bind_address;
    'DEFAULT/api_paste_config':                value => $api_paste_config;
    'DEFAULT/auth_strategy':                   value => $auth_strategy;
    'DEFAULT/cacert':                          value => $cacert;
    'DEFAULT/connect_retries':                 value => $connect_retries;
    'DEFAULT/debug':                           value => $debug;
    'DEFAULT/join_listen_port':                value => $join_listen_port;
    'DEFAULT/keytab':                          value => $keytab;
    'DEFAULT/log_dir':                         value => $log_dir;
    'DEFAULT/transport_url':                   value => $transport_url;
    'service_credentials/auth_type':           value => $auth_type;
    'service_credentials/auth_url':            value => $keystone_auth_url;
    'service_credentials/password':            value => $service_password;
    'service_credentials/username':            value => $service_user;
    'service_credentials/project_name':        value => $project_name;
    'service_credentials/user_domain_id':      value => $user_domain_id;
    'service_credentials/project_domain_name':
      value => $project_domain_name;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'novajoin-server':
    ensure     => $service_ensure,
    name       => $service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'openstack',
  }

  service { 'novajoin-notify':
    ensure     => $service_ensure,
    name       => $notify_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'openstack',
  }

  exec { 'get-service-user-keytab':
    command => "/usr/bin/kinit -kt /etc/krb5.keytab && ipa-getkeytab -s ${ipa_hostname_real} \
                -p nova/${::fqdn} -k ${keytab}",
    creates => $keytab,
  }

  ensure_resource('file', $keytab, { owner => $service_user, require => Exec['get-service-user-keytab'] })

  Package<| tag == 'novajoin-package' |> -> Exec['get-service-user-keytab']
  Novajoin_config<||> ~> Service<| title == 'novajoin-server'|>
  Novajoin_config<||> ~> Service<| title == 'novajoin-notify'|>
  Exec['get-service-user-keytab'] ~> Service['novajoin-server']
  Exec['get-service-user-keytab'] ~> Service['novajoin-notify']
  Exec['get-service-user-keytab'] ~> Service<| title == 'nova-api'|>
}
