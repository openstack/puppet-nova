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
#   Defaults to '0.0.0.0'
#
# [*metadata_listen*]
#   (optional) IP address  for metadata server to listen
#   Defaults to '0.0.0.0'
#
# [*metadata_listen_port*]
#   (optional) The port on which the metadata API will listen.
#   Defaults to 8775
#
# [*enabled_apis*]
#   (optional) A list of apis to enable
#   Defaults to ['osapi_compute', 'metadata']
#
# [*use_forwarded_for*]
#   (optional) Treat X-Forwarded-For as the canonical remote address. Only
#   enable this if you have a sanitizing proxy.
#   Defaults to false
#
# [*osapi_compute_workers*]
#   (optional) Number of workers for OpenStack API service
#   Defaults to $::processorcount
#
# [*osapi_compute_listen_port*]
#   (optional) The port on which the OpenStack API will listen.
#   Defaults to port 8774
#
# [*metadata_workers*]
#   (optional) Number of workers for metadata service
#   Defaults to $::processorcount
#
# [*instance_name_template*]
#   (optional) Template string to be used to generate instance names
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
# [*neutron_metadata_proxy_shared_secret*]
#   (optional) Shared secret to validate proxies Neutron metadata requests
#   Defaults to undef
#
# [*pci_alias*]
#   (optional) Pci passthrough for controller:
#   Defaults to undef
#   Example
#   "[ {'vendor_id':'1234', 'product_id':'5678', 'name':'default'}, {...} ]"
#
# [*ratelimits*]
#   (optional) A string that is a semicolon-separated list of 5-tuples.
#   See http://docs.openstack.org/trunk/config-reference/content/configuring-compute-API.html
#   Example: '(POST, "*", .*, 10, MINUTE);(POST, "*/servers", ^/servers, 50, DAY);(PUT, "*", .*, 10, MINUTE)'
#   Defaults to undef
#
# [*ratelimits_factory*]
#   (optional) The rate limiting factory to use
#   Defaults to 'nova.api.openstack.compute.limits:RateLimitingMiddleware.factory'
#
# [*enable_proxy_headers_parsing*]
#   (optional) This determines if the HTTPProxyToWSGI
#   middleware should parse the proxy headers or not.(boolean value)
#   Defaults to $::os_service_default
#
# [*default_floating_pool*]
#   (optional) Default pool for floating IPs
#   Defaults to 'nova'
#
# [*validate*]
#   (optional) Whether to validate the service is working after any service refreshes
#   Defaults to false
#
# [*fping_path*]
#   (optional) Full path to fping.
#   Defaults to '/usr/sbin/fping'
#
# [*validation_options*]
#   (optional) Service validation options
#   Should be a hash of options defined in openstacklib::service_validation
#   If empty, defaults values are taken from openstacklib function.
#   Default command list nova flavors.
#   Require validate set at True.
#   Example:
#   nova::api::validation_options:
#     nova-api:
#       command: check_nova.py
#       path: /usr/bin:/bin:/usr/sbin:/sbin
#       provider: shell
#       tries: 5
#       try_sleep: 10
#   Defaults to {}
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
# [*metadata_cache_expiration*]
#   (optional) This option is the time (in seconds) to cache metadata.
#   Defaults to $::os_service_default
#
# [*vendordata_jsonfile_path*]
#   (optional) Represent the path to the data file.
#   Cloud providers may store custom data in vendor data file that will then be
#   available to the instances via the metadata service, and to the rendering of
#   config-drive. The default class for this, JsonFileVendorData, loads this
#   information from a JSON file, whose path is configured by this option
#   Defaults to $::os_service_default
#
# [*vendordata_providers*]
#   (optional) vendordata providers are how deployers can provide metadata via
#   configdrive and metadata that is specific to their deployment. There are
#   currently two supported providers: StaticJSON and DynamicJSON.
#   Defaults to $::os_service_default
#
# [*vendordata_dynamic_targets*]
#   (optional) A list of targets for the dynamic vendordata provider. These
#   targets are of the form <name>@<url>.
#   Defaults to $::os_service_default
#
# [*vendordata_dynamic_connect_timeout*]
#   (optional) Maximum wait time for an external REST service to connect.
#   Defaults to $::os_service_default
#
# [*vendordata_dynamic_read_timeout*]
#   (optional) Maximum wait time for an external REST service to return data
#   once connected.
#   Defaults to $::os_service_default
#
# [*osapi_max_limit*]
#   (optional) This option is limit the maximum number of items in a single response.
#   Defaults to $::os_service_default
#
# [*osapi_compute_link_prefix*]
#   (optional) This string is prepended to the normal URL that is returned in links
#   to the OpenStack Compute API.
#   Defaults to $::os_service_default
#
# [*osapi_glance_link_prefix*]
#   (optional) This string is prepended to the normal URL that is returned in links
#   to Glance resources.
#   Defaults to $::os_service_default
#
# [*osapi_hide_server_address_states*]
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
# [*install_cinder_client*]
#   (optional) Whether the cinder::client class should be used to install the cinder client.
#   Defaults to true
#
#  [*allow_resize_to_same_host*]
#   (optional) Allow destination machine to match source for resize. Note that this
#   is also settable in the compute class. In some sitautions you need it set here
#   and in others you need it set there.
#   Defaults to false
#
# DEPRECATED
#
# [*keystone_ec2_url*]
#   (optional) DEPRECATED. The keystone url where nova should send requests for ec2tokens
#   Defaults to undef
#
# [*volume_api_class*]
#   (optional) DEPRECATED. The name of the class that nova will use to access volumes. Cinder is the only option.
#   Defaults to undef
#
# [*ec2_listen_port*]
#   (optional) DEPRECATED. The port on which the EC2 API will listen.
#   Defaults to port undef
#
# [*auth_version*]
#   (optional) DEPRECATED. Use auth_token from
#   nova::keystone::authtoken class instead.
#   Defaults to undef
#
# [*osapi_v3*]
#   (optional) DEPRECATED. Enable or not Nova API v3
#   Defaults to undef
#
# [*ec2_workers*]
#   (optional) DEPRECATED. Number of workers for EC2 service
#   Defaults to undef
#
# [*conductor_workers*]
#   (optional) DEPRECATED. Use workers parameter of nova::conductor
#   Class instead.
#   Defaults to undef
#
# [*admin_tenant_name*]
#   (optional) DEPRECATED. Use project_name from
#   nova::keystone::authtoken class instead.
#   Defaults to undef
#
# [*admin_user*]
#   (optional) DEPRECATED. Use username from
#   nova::keystone::authtoken class instead.
#   Defaults to undef
#
# [*admin_password*]
#   (optional) DEPRECATED. Use password from
#   nova::keystone::authtoken class instead.
#   Defaults to undef
#
# [*identity_uri*]
#   (optional) DEPRECATED. Use auth_url from
#   nova::keystone::authtoken class instead.
#   Defaults to undef
#
# [*auth_uri*]
#   (optional) DEPRECATED. Use auth_uri from
#   nova::keystone::authtoken class instead.
#   Defaults to undef
#
class nova::api(
  $enabled                              = true,
  $manage_service                       = true,
  $api_paste_config                     = 'api-paste.ini',
  $ensure_package                       = 'present',
  $api_bind_address                     = '0.0.0.0',
  $osapi_compute_listen_port            = 8774,
  $metadata_listen                      = '0.0.0.0',
  $metadata_listen_port                 = 8775,
  $enabled_apis                         = ['osapi_compute', 'metadata'],
  $use_forwarded_for                    = false,
  $osapi_compute_workers                = $::processorcount,
  $metadata_workers                     = $::processorcount,
  $sync_db                              = true,
  $sync_db_api                          = true,
  $db_online_data_migrations            = false,
  $neutron_metadata_proxy_shared_secret = undef,
  $default_floating_pool                = 'nova',
  $pci_alias                            = undef,
  $ratelimits                           = undef,
  $ratelimits_factory                   =
    'nova.api.openstack.compute.limits:RateLimitingMiddleware.factory',
  $validate                             = false,
  $validation_options                   = {},
  $instance_name_template               = undef,
  $fping_path                           = '/usr/sbin/fping',
  $service_name                         = $::nova::params::api_service_name,
  $enable_proxy_headers_parsing         = $::os_service_default,
  $metadata_cache_expiration            = $::os_service_default,
  $vendordata_jsonfile_path             = $::os_service_default,
  $vendordata_providers                 = $::os_service_default,
  $vendordata_dynamic_targets           = $::os_service_default,
  $vendordata_dynamic_connect_timeout   = $::os_service_default,
  $vendordata_dynamic_read_timeout      = $::os_service_default,
  $osapi_max_limit                      = $::os_service_default,
  $osapi_compute_link_prefix            = $::os_service_default,
  $osapi_glance_link_prefix             = $::os_service_default,
  $osapi_hide_server_address_states     = $::os_service_default,
  $allow_instance_snapshots             = $::os_service_default,
  $enable_network_quota                 = $::os_service_default,
  $enable_instance_password             = $::os_service_default,
  $password_length                      = $::os_service_default,
  $install_cinder_client                = true,
  $allow_resize_to_same_host            = false,
  # DEPRECATED PARAMETER
  $conductor_workers                    = undef,
  $ec2_listen_port                      = undef,
  $ec2_workers                          = undef,
  $keystone_ec2_url                     = undef,
  $auth_version                         = undef,
  $volume_api_class                     = undef,
  $osapi_v3                             = undef,
  $admin_password                       = undef,
  $auth_uri                             = undef,
  $identity_uri                         = undef,
  $admin_tenant_name                    = undef,
  $admin_user                           = undef,
) inherits nova::params {

  include ::nova::deps
  include ::nova::db
  include ::nova::policy
  include ::nova::keystone::authtoken

  if $install_cinder_client {
    include ::cinder::client
    Class['cinder::client'] ~> Nova::Generic_service['api']
  }

  if $osapi_v3 {
    warning('osapi_v3 is deprecated, has no effect and will be removed in a future release.')
  }

  if $volume_api_class {
    warning('volume_api_class parameter is deprecated, has no effect and will be removed in a future release.')
  }

  if $ec2_listen_port or $ec2_workers or $keystone_ec2_url {
    warning('ec2_listen_port, ec2_workers and keystone_ec2_url are deprecated and have no effect. Deploy openstack/ec2-api instead.')
  }

  if $conductor_workers {
    warning('The conductor_workers parameter is deprecated and has no effect. Use workers parameter of nova::conductor class instead.')
  }

  if $instance_name_template {
    nova_config {
      'DEFAULT/instance_name_template': value => $instance_name_template;
    }
  } else {
    nova_config{
      'DEFAULT/instance_name_template': ensure => absent;
    }
  }

  if $auth_version {
    warning('nova::api::auth_version is deprecated, use nova::keystone::authtoken::auth_version instead.')
  }

  if $identity_uri {
    warning('nova::api::identity_uri is deprecated, use nova::keystone::authtoken::auth_url instead.')
  }

  if $auth_uri {
    warning('nova::api::auth_uri is deprecated, use nova::keystone::authtoken::auth_uri instead.')
  }

  if $admin_tenant_name {
    warning('nova::api::admin_tenant_name is deprecated, use nova::keystone::authtoken::project_name instead.')
  }

  if $admin_user {
    warning('nova::api::admin_user is deprecated, use nova::keystone::authtoken::username instead.')
  }

  if $admin_password {
    warning('nova::api::admin_password is deprecated, use nova::keystone::authtoken::password instead.')
  }


  if !is_service_default($vendordata_providers) and !empty($vendordata_providers){
    validate_array($vendordata_providers)
    $vendordata_providers_real = join($vendordata_providers, ',')
  } else {
    $vendordata_providers_real = $::os_service_default
  }

  if !is_service_default($vendordata_dynamic_targets) and !empty($vendordata_dynamic_targets){
    validate_array($vendordata_dynamic_targets)
    $vendordata_dynamic_targets_real = join($vendordata_dynamic_targets, ',')
  } else {
    $vendordata_dynamic_targets_real = $::os_service_default
  }

  # metadata can't be run in wsgi so we have to enable it in eventlet anyway.
  if ('metadata' in $enabled_apis and $service_name == 'httpd') {
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
    # make sure we start apache before nova-api to avoid binding issues
    Service[$service_name] -> Service['nova-api']
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

  nova_config {
    'wsgi/api_paste_config':                      value => $api_paste_config;
    'DEFAULT/enabled_apis':                       value => join($enabled_apis_real, ',');
    'DEFAULT/osapi_compute_listen':               value => $api_bind_address;
    'DEFAULT/metadata_listen':                    value => $metadata_listen;
    'DEFAULT/metadata_listen_port':               value => $metadata_listen_port;
    'DEFAULT/osapi_compute_listen_port':          value => $osapi_compute_listen_port;
    'DEFAULT/osapi_volume_listen':                value => $api_bind_address;
    'DEFAULT/osapi_compute_workers':              value => $osapi_compute_workers;
    'DEFAULT/metadata_workers':                   value => $metadata_workers;
    'DEFAULT/use_forwarded_for':                  value => $use_forwarded_for;
    'DEFAULT/default_floating_pool':              value => $default_floating_pool;
    'DEFAULT/fping_path':                         value => $fping_path;
    'DEFAULT/metadata_cache_expiration':          value => $metadata_cache_expiration;
    'DEFAULT/vendordata_jsonfile_path':           value => $vendordata_jsonfile_path;
    'DEFAULT/vendordata_providers':               value => $vendordata_providers_real;
    'DEFAULT/vendordata_dynamic_targets':         value => $vendordata_dynamic_targets_real;
    'DEFAULT/vendordata_dynamic_connect_timeout': value => $vendordata_dynamic_connect_timeout;
    'DEFAULT/vendordata_dynamic_read_timeout':    value => $vendordata_dynamic_read_timeout;
    'DEFAULT/osapi_max_limit':                    value => $osapi_max_limit;
    'DEFAULT/osapi_compute_link_prefix':          value => $osapi_compute_link_prefix;
    'DEFAULT/osapi_glance_link_prefix':           value => $osapi_glance_link_prefix;
    'DEFAULT/osapi_hide_server_address_states':   value => $osapi_hide_server_address_states;
    'DEFAULT/allow_instance_snapshots':           value => $allow_instance_snapshots;
    'DEFAULT/enable_network_quota':               value => $enable_network_quota;
    'DEFAULT/enable_instance_password':           value => $enable_instance_password;
    'DEFAULT/password_length':                    value => $password_length;
  }

  oslo::middleware {'nova_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }

  if ($neutron_metadata_proxy_shared_secret){
    nova_config {
      'neutron/service_metadata_proxy': value => true;
      'neutron/metadata_proxy_shared_secret':
        value => $neutron_metadata_proxy_shared_secret;
    }
  } else {
    nova_config {
      'neutron/service_metadata_proxy':       value  => false;
      'neutron/metadata_proxy_shared_secret': ensure => absent;
    }
  }

  if ($ratelimits != undef) {
    nova_paste_api_ini {
      'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
      'filter:ratelimit/limits':               value => $ratelimits;
    }
  }

  # Added arg and if statement prevents this from being run
  # where db is not active i.e. the compute
  if $sync_db {
    include ::nova::db::sync
  }
  if $sync_db_api {
    include ::nova::db::sync_api
  }
  if $db_online_data_migrations {
    include ::nova::db::online_data_migrations
  }

  # Remove auth configuration from api-paste.ini
  nova_paste_api_ini {
    'filter:authtoken/auth_uri':          ensure => absent;
    'filter:authtoken/auth_host':         ensure => absent;
    'filter:authtoken/auth_port':         ensure => absent;
    'filter:authtoken/auth_protocol':     ensure => absent;
    'filter:authtoken/admin_tenant_name': ensure => absent;
    'filter:authtoken/admin_user':        ensure => absent;
    'filter:authtoken/admin_password':    ensure => absent;
    'filter:authtoken/auth_admin_prefix': ensure => absent;
  }

  if $pci_alias {
    nova_config {
      'DEFAULT/pci_alias': value => check_array_of_hash($pci_alias);
    }
  }

  if $validate {
    #Shrinking the variables names in favor of not
    #having more than 140 chars per line
    #Admin user real
    $aur = pick($admin_user, $::nova::keystone::authtoken::username)
    #Admin password real
    $apr = pick($admin_password, $::nova::keystone::authtoken::password)
    #Admin tenan name real
    $atnr = pick($admin_tenant_name, $::nova::keystone::authtoken::project_name)
    #Keystone Auth URI
    $kau = $::nova::keystone::authtoken::auth_uri
    $defaults = {
      'nova-api' => {
        'command'  => "nova --os-auth-url ${kau} --os-project-name ${atnr} --os-username ${aur} --os-password ${apr} flavor-list",
      }
    }
    $validation_options_hash = merge ($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[nova-api]'})
  }

  ensure_resource('nova_config', 'DEFAULT/allow_resize_to_same_host', { value => $allow_resize_to_same_host })
}
