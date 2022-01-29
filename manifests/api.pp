# == Class: nova::api
#
# Setup and configure the Nova API endpoint
#
# === Parameters
#
# [*enabled*]
#   (optional) Whether the nova api service will be run
#   Defaults to true
#
# [*api_paste_config*]
#   (optional) File name for the paste.deploy config for nova-api
#   Defaults to 'api-paste.ini'
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) Whether the nova api package will be installed
#   Defaults to 'present'
#
# [*api_bind_address*]
#   (optional) IP address for nova-api server to listen
#   Defaults to $::os_service_default
#
# [*metadata_listen*]
#   (optional) IP address  for metadata server to listen
#   Defaults to $::os_service_default
#
# [*metadata_listen_port*]
#   (optional) The port on which the metadata API will listen.
#   Defaults to $::os_service_default
#
# [*enabled_apis*]
#   (optional) A list of apis to enable
#   Defaults to ['osapi_compute', 'metadata']
#
# [*osapi_compute_workers*]
#   (optional) Number of workers for OpenStack API service
#   Defaults to $::os_workers
#
# [*osapi_compute_listen_port*]
#   (optional) The port on which the OpenStack API will listen.
#   Defaults to $::os_service_default
#
# [*metadata_workers*]
#   (optional) Number of workers for metadata service
#   Defaults to $::os_workers
#
# [*instance_name_template*]
#   (optional) Template string to be used to generate instance names. Using
#   this parameter might cause incomplete settings in case nova services are
#   distributed among multiple nodes.
#   Defaults to undef
#
# [*sync_db*]
#   (optional) Run nova-manage db sync on api nodes after installing the package.
#   Defaults to true
#
# [*sync_db_api*]
#   (optional) Run nova-manage api_db sync on api nodes after installing the package.
#   Defaults to true
#
# [*db_online_data_migrations*]
#   (optional) Run nova-manage db online_data_migrations on api nodes after
#   installing the package - required on upgrade.
#   Defaults to false.
#
# [*enable_proxy_headers_parsing*]
#   (optional) This determines if the HTTPProxyToWSGI
#   middleware should parse the proxy headers or not.(boolean value)
#   Defaults to $::os_service_default
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $::os_service_default.
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of nova-api.
#   If the value is 'httpd', this means nova-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'nova::wsgi::apache'...}
#   to make nova be a web app using apache mod_wsgi.
#   Defaults to '$::nova::params::api_service_name'
#
# [*metadata_service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of nova-api-metadata.
#   If the value is undef, no management of the service will be
#   done by puppet. If the value is defined, and manage_service
#   is set to true, the service will be managed by Puppet.
#   Default to $::nova::params::api_metadata_service_name
#
# [*max_limit*]
#   (optional) This option is limit the maximum number of items in a single response.
#   Defaults to $::os_service_default
#
# [*compute_link_prefix*]
#   (optional) This string is prepended to the normal URL that is returned in links
#   to the OpenStack Compute API.
#   Defaults to $::os_service_default
#
# [*glance_link_prefix*]
#   (optional) This string is prepended to the normal URL that is returned in links
#   to Glance resources.
#   Defaults to $::os_service_default
#
# [*hide_server_address_states*]
#   (optional) This option is a list of all instance states for which network address
#   information should not be returned from the API.
#   Defaults to $::os_service_default
#
# [*allow_instance_snapshots*]
#   (optional) Operators can turn off the ability for a user to take snapshots of their
#   instances by setting this option to False
#   Defaults to $::os_service_default
#
# [*enable_network_quota*]
#   (optional) This option is used to enable or disable quota checking for tenant networks
#   Defaults to $::os_service_default
#
# [*enable_instance_password*]
#   (optional) Enables returning of the instance password by the relevant server API calls
#   Defaults to $::os_service_default
#
# [*password_length*]
#   (optional) Length of generated instance admin passwords (integer value)
#   Defaults to $::os_service_default
#
# [*allow_resize_to_same_host*]
#   (optional) Allow destination machine to match source for resize.
#   Defaults to false
#
# [*instance_list_per_project_cells*]
#   (optional) Only query cell databases in which the tenant has mapped
#   instances
#   Defaults to $::os_service_default
#
# [*instance_list_cells_batch_strategy*]
#   (optional) The method by which the API queries cell databases in smaller
#   batches during large instance list operations.
#   Defaults to $::os_service_default
#
# [*instance_list_cells_batch_fixed_size*]
#   (optional) This controls batch size of instances requested from each cell
#   database if ``instance_list_cells_batch_strategy``` is set to ``fixed``
#   Defaults to $::os_service_default
#
# [*list_records_by_skipping_down_cells*]
#   (optional) Whether to skip the down cells and return the results from
#   the up cells.
#   Defaults to $::os_service_default
#
# DEPRECATED
#
# [*nova_metadata_wsgi_enabled*]
#   Wether nova metadata api is run via wsgi. Since running metadata via eventlet is
#   going to be removed in the Sein release we can deprecate this and plan to remove
#   metadata handling from api class.
#   Defaults to false
#
# [*validate*]
#   (optional) Whether to validate the service is working after any service refreshes
#   Defaults to undef
#
# [*validation_options*]
#   (optional) Service validation options
#   Should be a hash of options defined in openstacklib::service_validation
#   If empty, defaults values are taken from openstacklib function.
#   Default command list nova flavors.
#   Require validate set at True.
#   Defaults to undef
#
# [*use_forwarded_for*]
#   (optional) Treat X-Forwarded-For as the canonical remote address. Only
#   enable this if you have a sanitizing proxy.
#   Defaults to undef
#
class nova::api(
  $enabled                                     = true,
  $manage_service                              = true,
  $api_paste_config                            = 'api-paste.ini',
  $ensure_package                              = 'present',
  $api_bind_address                            = $::os_service_default,
  $osapi_compute_listen_port                   = $::os_service_default,
  $metadata_listen                             = $::os_service_default,
  $metadata_listen_port                        = $::os_service_default,
  $enabled_apis                                = ['osapi_compute', 'metadata'],
  $osapi_compute_workers                       = $::os_workers,
  $metadata_workers                            = $::os_workers,
  $sync_db                                     = true,
  $sync_db_api                                 = true,
  $db_online_data_migrations                   = false,
  $instance_name_template                      = undef,
  $service_name                                = $::nova::params::api_service_name,
  $metadata_service_name                       = $::nova::params::api_metadata_service_name,
  $enable_proxy_headers_parsing                = $::os_service_default,
  $max_request_body_size                       = $::os_service_default,
  $max_limit                                   = $::os_service_default,
  $compute_link_prefix                         = $::os_service_default,
  $glance_link_prefix                          = $::os_service_default,
  $hide_server_address_states                  = $::os_service_default,
  $allow_instance_snapshots                    = $::os_service_default,
  $enable_network_quota                        = $::os_service_default,
  $enable_instance_password                    = $::os_service_default,
  $password_length                             = $::os_service_default,
  $allow_resize_to_same_host                   = false,
  $instance_list_per_project_cells             = $::os_service_default,
  $instance_list_cells_batch_strategy          = $::os_service_default,
  $instance_list_cells_batch_fixed_size        = $::os_service_default,
  $list_records_by_skipping_down_cells         = $::os_service_default,
  # DEPRECATED PARAMETER
  $nova_metadata_wsgi_enabled                  = false,
  $validate                                    = undef,
  $validation_options                          = undef,
  $use_forwarded_for                           = undef,
) inherits nova::params {

  include nova::deps
  include nova::db
  include nova::policy
  include nova::keystone::authtoken
  include nova::availability_zone
  include nova::pci

  if !$nova_metadata_wsgi_enabled {
    warning('Running nova metadata api via evenlet is deprecated and will be removed in Stein release.')
  }

  if $validate != undef {
    warning('The nova::api::validate parameter has been deprecated and has no effect')
  }
  if $validation_options != undef {
    warning('The nova::api::validation_options parameter has been deprecated and has no effect')
  }

  if $use_forwarded_for != undef {
    warning('The use_forwarded_for parameter has been deprecated.')
  }

  if $instance_name_template != undef {
    warning("The nova::api::instance_name_template parameter may result \
in incomplete settings in case nova services are distributed among multiple \
nodes. Use the nova::instance_name_template parameter instead.")
    nova_config {
      'DEFAULT/instance_name_template': value => $instance_name_template;
    }
  } else {
    # Try best to clean up the parameter
    if defined(Class['nova']) and $::nova::instance_name_template == undef {
      nova_config {
        'DEFAULT/instance_name_template': value => $::os_service_default;
      }
    }
  }

  # enable metadata in eventlet if we do not run metadata via wsgi (nova::metadata)
  if ('metadata' in $enabled_apis and $service_name == 'httpd' and !$nova_metadata_wsgi_enabled) {
    $enable_metadata = true
  } else {
    $enable_metadata = false
  }

  # sanitize service_name and prepare DEFAULT/enabled_apis parameter
  if $service_name == $::nova::params::api_service_name {
    # if running evenlet, we use the original puppet parameter
    # so people can enable custom service names and we keep backward compatibility.
    $enabled_apis_real = $enabled_apis
    $service_enabled   = $enabled
  } elsif $service_name == 'httpd' {
    # when running wsgi, we want to enable metadata in eventlet if part of enabled_apis
    # but only if we do not run metadata via wsgi (nova::metadata)
    if $enable_metadata {
      $enabled_apis_real = ['metadata']
      $service_enabled   = $enabled
    } else {
      # otherwise, set it to empty list
      $enabled_apis_real = []
      # if running wsgi for compute, and metadata disabled
      # we don't need to enable nova-api service.
      $service_enabled   = false
    }
    policy_rcd { 'nova-api':
      ensure   => present,
      set_code => '101',
      before   => Package['nova-api'],
    }
    Service <| title == 'httpd' |> { tag +> 'nova-service' }
    # make sure we start apache before nova-api to avoid binding issues
    Service['nova-api'] -> Service[$service_name]
  } else {
    fail("Invalid service_name. Either nova-api/openstack-nova-api for running \
as a standalone service, or httpd for being run by a httpd server")
  }

  nova::generic_service { 'api':
    enabled        => $service_enabled,
    manage_service => $manage_service,
    ensure_package => $ensure_package,
    package_name   => $::nova::params::api_package_name,
    service_name   => $::nova::params::api_service_name,
  }

  if $::nova::params::api_metadata_service_name {
    nova::generic_service { 'api-metadata':
      enabled        => $service_enabled,
      manage_service => $manage_service,
      ensure_package => $ensure_package,
      package_name   => $::nova::params::api_package_name,
      service_name   => $::nova::params::api_metadata_service_name,
    }
  }

  if !$nova_metadata_wsgi_enabled {
    nova_config {
      'DEFAULT/metadata_workers':     value => $metadata_workers;
      'DEFAULT/metadata_listen':      value => $metadata_listen;
      'DEFAULT/metadata_listen_port': value => $metadata_listen_port;
    }
  } else {
    nova_config {
      'DEFAULT/metadata_workers':     ensure => absent;
      'DEFAULT/metadata_listen':      ensure => absent;
      'DEFAULT/metadata_listen_port': ensure => absent;
    }
  }

  oslo::middleware {'nova_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }

  nova_config {
    'DEFAULT/enabled_apis':                     value => join($enabled_apis_real, ',');
    'wsgi/api_paste_config':                    value => $api_paste_config;
    'DEFAULT/osapi_compute_listen':             value => $api_bind_address;
    'DEFAULT/osapi_compute_listen_port':        value => $osapi_compute_listen_port;
    'DEFAULT/osapi_compute_workers':            value => $osapi_compute_workers;
    'DEFAULT/enable_network_quota':             value => $enable_network_quota;
    'DEFAULT/password_length':                  value => $password_length;
    'api/use_forwarded_for':                    value => pick($use_forwarded_for, $::os_service_default);
    'api/max_limit':                            value => $max_limit;
    'api/compute_link_prefix':                  value => $compute_link_prefix;
    'api/glance_link_prefix':                   value => $glance_link_prefix;
    'api/hide_server_address_states':           value => $hide_server_address_states;
    'api/allow_instance_snapshots':             value => $allow_instance_snapshots;
    'api/enable_instance_password':             value => $enable_instance_password;
    'DEFAULT/allow_resize_to_same_host':        value => $allow_resize_to_same_host;
    'api/instance_list_per_project_cells':      value => $instance_list_per_project_cells;
    'api/instance_list_cells_batch_strategy':   value => $instance_list_cells_batch_strategy;
    'api/instance_list_cells_batch_fixed_size': value => $instance_list_cells_batch_fixed_size;
    'api/list_records_by_skipping_down_cells':  value => $list_records_by_skipping_down_cells;
  }

  # Added arg and if statement prevents this from being run
  # where db is not active i.e. the compute
  if $sync_db {
    include nova::db::sync
  }
  if $sync_db_api {
    include nova::db::sync_api
  }
  if $db_online_data_migrations {
    include nova::db::online_data_migrations
  }
}
