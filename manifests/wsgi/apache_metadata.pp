# == Class: nova::wsgi::apache_metadata
#
# Class to serve Nova Metadata API with apache mod_wsgi in place of nova-metadata-api service.
#
# When using this class you should disable your nova-metadata-api_port service.
#
# == Parameters
#
#   [*servername*]
#     The servername for the virtualhost.
#     Optional. Defaults to $::fqdn
#
#   [*ensure_package*]
#     (optional) Control the ensure parameter for the Nova Placement API package resource.
#     Defaults to 'present'
#
#   [*api_port*]
#     The port for Nova API service.
#     Optional. Defaults to 8775
#
#   [*bind_host*]
#     The host/ip address Apache will listen on.
#     Optional. Defaults to undef (listen on all ip addresses).
#
#   [*path*]
#     The prefix for the endpoint.
#     Optional. Defaults to '/'
#
#   [*ssl*]
#     Use ssl ? (boolean)
#     Optional. Defaults to true
#
#   [*workers*]
#     Number of WSGI workers to spawn.
#     Optional. Defaults to $::os_workers
#
#   [*priority*]
#     (optional) The priority for the vhost.
#     Defaults to '10'
#
#   [*threads*]
#     (optional) The number of threads for the vhost.
#     Defaults to 1
#
#   [*wsgi_process_display_name*]
#     (optional) Name of the WSGI process display-name.
#     Defaults to undef
#
#   [*ssl_cert*]
#   [*ssl_key*]
#   [*ssl_chain*]
#   [*ssl_ca*]
#   [*ssl_crl_path*]
#   [*ssl_crl*]
#   [*ssl_certs_dir*]
#     apache::vhost ssl parameters.
#     Optional. Default to apache::vhost 'ssl_*' defaults.
#
#   [*access_log_file*]
#     The log file name for the virtualhost.
#     Optional. Defaults to false.
#
#   [*access_log_format*]
#     The log format for the virtualhost.
#     Optional. Defaults to false.
#
#   [*error_log_file*]
#     The error log file name for the virtualhost.
#     Optional. Defaults to undef.
#
#   [*custom_wsgi_process_options*]
#     (optional) gives you the oportunity to add custom process options or to
#     overwrite the default options for the WSGI main process.
#     eg. to use a virtual python environment for the WSGI process
#     you could set it to:
#     { python-path => '/my/python/virtualenv' }
#     Defaults to {}
#
# == Dependencies
#
#   requires Class['apache'] & Class['nova'] & Class['nova::metadata']
#
# == Examples
#
#   include apache
#
#   class { 'nova::wsgi::apache_metadata': }
#
class nova::wsgi::apache_metadata (
  $servername                  = $::fqdn,
  $api_port                    = 8775,
  $bind_host                   = undef,
  $path                        = '/',
  $ssl                         = true,
  $workers                     = $::os_workers,
  $ssl_cert                    = undef,
  $ssl_key                     = undef,
  $ssl_chain                   = undef,
  $ssl_ca                      = undef,
  $ssl_crl_path                = undef,
  $ssl_crl                     = undef,
  $ssl_certs_dir               = undef,
  $wsgi_process_display_name   = undef,
  $threads                     = 1,
  $priority                    = '10',
  $ensure_package              = 'present',
  $access_log_file             = false,
  $access_log_format           = false,
  $error_log_file              = undef,
  $custom_wsgi_process_options = {},
) {

  include nova::params
  include apache
  include apache::mod::wsgi
  if $ssl {
    include apache::mod::ssl
  }

  nova::generic_service { 'metadata-api':
    service_name   => false,
    package_name   => $::nova::params::api_package_name,
    ensure_package => $ensure_package,
  }

  if ! defined(Class[::nova::metadata]) {
    fail('::nova::metadata class must be declared in composition layer.')
  }

  Service <| title == 'httpd' |> { tag +> 'nova-service' }

  ::openstacklib::wsgi::apache { 'nova_metadata_wsgi':
    bind_host                   => $bind_host,
    bind_port                   => $api_port,
    group                       => 'nova',
    path                        => $path,
    priority                    => $priority,
    servername                  => $servername,
    ssl                         => $ssl,
    ssl_ca                      => $ssl_ca,
    ssl_cert                    => $ssl_cert,
    ssl_certs_dir               => $ssl_certs_dir,
    ssl_chain                   => $ssl_chain,
    ssl_crl                     => $ssl_crl,
    ssl_crl_path                => $ssl_crl_path,
    ssl_key                     => $ssl_key,
    threads                     => $threads,
    user                        => 'nova',
    workers                     => $workers,
    wsgi_daemon_process         => 'nova-metadata',
    wsgi_process_display_name   => $wsgi_process_display_name,
    wsgi_process_group          => 'nova-metadata',
    wsgi_script_dir             => $::nova::params::nova_wsgi_script_path,
    wsgi_script_file            => 'nova-metadata-api',
    wsgi_script_source          => $::nova::params::nova_metadata_wsgi_script_source,
    custom_wsgi_process_options => $custom_wsgi_process_options,
    access_log_file             => $access_log_file,
    access_log_format           => $access_log_format,
    error_log_file              => $error_log_file,
  }

}
