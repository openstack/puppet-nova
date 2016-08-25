# class: nova::keystone::authtoken
#
# Configure the keystone_authtoken section in the configuration file
#
# === Parameters
#
# [*username*]
#   (Optional) The name of the service user
#   Defaults to 'nova'
#
# [*password*]
#   (Optional) Password to create for the service user
#   Defaults to $::os_service_default
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http:://127.0.0.1:35357'
#
# [*project_name*]
#   (Optional) Service project name
#   Defaults to 'services'
#
# [*user_domain_name*]
#   (Optional) Name of domain for $username
#   Defaults to $::os_service_default
#
# [*project_domain_name*]
#   (Optional) Name of domain for $project_name
#   Defaults to $::os_service_default
#
# [*insecure*]
#   (Optional) If true, explicitly allow TLS without checking server cert
#   against any certificate authorities.  WARNING: not recommended.  Use with
#   caution.
#   Defaults to $:os_service_default
#
# [*auth_section*]
#   (Optional) Config Section from which to load plugin specific options
#   Defaults to $::os_service_default.
#
# [*auth_type*]
#   (Optional) Authentication type to load
#   Defaults to $::os_service_default
#
# [*auth_uri*]
#   (Optional) Complete public Identity API endpoint.
#   Defaults to 'http://127.0.0.1:5000/'.
#
# [*auth_version*]
#   (Optional) API version of the admin Identity API endpoint.
#   Defaults to $::os_service_default.
#
# [*cache*]
#   (Optional) Env key for the swift cache.
#   Defaults to $::os_service_default.
#
# [*cafile*]
#   (Optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to $::os_service_default.
#
# [*certfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $::os_service_default.
#
# [*check_revocations_for_cached*]
#   (Optional) If true, the revocation list will be checked for cached tokens.
#   This requires that PKI tokens are configured on the identity server.
#   boolean value.
#   Defaults to $::os_service_default.
#
# [*delay_auth_decision*]
#   (Optional) Do not handle authorization requests within the middleware, but
#   delegate the authorization decision to downstream WSGI components. Boolean
#   value
#   Defaults to $::os_service_default.
#
# [*enforce_token_bind*]
#   (Optional) Used to control the use and type of token binding. Can be set
#   to: "disabled" to not check token binding. "permissive" (default) to
#   validate binding information if the bind type is of a form known to the
#   server and ignore it if not. "strict" like "permissive" but if the bind
#   type is unknown the token will be rejected. "required" any form of token
#   binding is needed to be allowed. Finally the name of a binding method that
#   must be present in tokens. String value.
#   Defaults to $::os_service_default.
#
# [*hash_algorithms*]
#   (Optional) Hash algorithms to use for hashing PKI tokens. This may be a
#   single algorithm or multiple. The algorithms are those supported by Python
#   standard hashlib.new(). The hashes will be tried in the order given, so put
#   the preferred one first for performance. The result of the first hash will
#   be stored in the cache. This will typically be set to multiple values only
#   while migrating from a less secure algorithm to a more secure one. Once all
#   the old tokens are expired this option should be set to a single value for
#   better performance. List value.
#   Defaults to $::os_service_default.
#
# [*http_connect_timeout*]
#   (Optional) Request timeout value for communicating with Identity API
#   server.
#   Defaults to $::os_service_default.
#
# [*http_request_max_retries*]
#   (Optional) How many times are we trying to reconnect when communicating
#   with Identity API Server. Integer value
#   Defaults to $::os_service_default.
#
# [*include_service_catalog*]
#   (Optional) Indicate whether to set the X-Service-Catalog header. If False,
#   middleware will not ask for service catalog on token validation and will
#   not set the X-Service-Catalog header. Boolean value.
#   Defaults to $::os_service_default.
#
# [*keyfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $::os_service_default.
#
# [*memcache_pool_conn_get_timeout*]
#   (Optional) Number of seconds that an operation will wait to get a memcached
#   client connection from the pool. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_pool_dead_retry*]
#   (Optional) Number of seconds memcached server is considered dead before it
#   is tried again. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_pool_maxsize*]
#   (Optional) Maximum total number of open connections to every memcached
#    server. Integer value
#  Defaults to $::os_service_default.
#
# [*memcache_pool_socket_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused in
#   the pool before it is closed. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_pool_unused_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused in
#   the pool before it is closed. Integer value
#   Defaults to $::os_service_default.
#
# [*memcache_secret_key*]
#   (Optional, mandatory if memcache_security_strategy is defined) This string
#   is used for key derivation.
#   Defaults to $::os_service_default.
#
# [*memcache_security_strategy*]
#   (Optional) If defined, indicate whether token data should be authenticated
#   or authenticated and encrypted. If MAC, token data is authenticated (with
#   HMAC) in the cache. If ENCRYPT, token data is encrypted and authenticated in the
#   cache. If the value is not one of these options or empty, auth_token will
#   raise an exception on initialization.
#   Defaults to $::os_service_default.
#
# [*memcache_use_advanced_pool*]
#   (Optional)  Use the advanced (eventlet safe) memcached client pool. The
#   advanced pool will only work under python 2.x Boolean value
#   Defaults to $::os_service_default.
#
# [*memcached_servers*]
#   (Optional) Optionally specify a list of memcached server(s) to use for
#   caching. If left undefined, tokens will instead be cached in-process.
#   Defaults to $::os_service_default.
#
# [*region_name*]
#   (Optional) The region in which the identity server can be found.
#   Defaults to $::os_service_default.
#
# [*revocation_cache_time*]
#   (Optional) Determines the frequency at which the list of revoked tokens is
#   retrieved from the Identity service (in seconds). A high number of
#   revocation events combined with a low cache duration may significantly
#   reduce performance. Only valid for PKI tokens. Integer value
#   Defaults to $::os_service_default.
#
# [*signing_dir*]
#   (Optional) Directory used to cache files related to PKI tokens.
#   Defaults to $::os_service_default.
#
# [*token_cache_time*]
#   (Optional) In order to prevent excessive effort spent validating tokens,
#   the middleware caches previously-seen tokens for a configurable duration
#   (in seconds). Set to -1 to disable caching completely. Integer value
#   Defaults to $::os_service_default.
#
class nova::keystone::authtoken(
  $username                       = 'nova',
  $password                       = $::os_service_default,
  $auth_url                       = 'http://127.0.0.1:35357/',
  $project_name                   = 'services',
  $user_domain_name               = $::os_service_default,
  $project_domain_name            = $::os_service_default,
  $insecure                       = $::os_service_default,
  $auth_section                   = $::os_service_default,
  $auth_type                      = 'password',
  $auth_uri                       = 'http://127.0.0.1:5000/',
  $auth_version                   = $::os_service_default,
  $cache                          = $::os_service_default,
  $cafile                         = $::os_service_default,
  $certfile                       = $::os_service_default,
  $check_revocations_for_cached   = $::os_service_default,
  $delay_auth_decision            = $::os_service_default,
  $enforce_token_bind             = $::os_service_default,
  $hash_algorithms                = $::os_service_default,
  $http_connect_timeout           = $::os_service_default,
  $http_request_max_retries       = $::os_service_default,
  $include_service_catalog        = $::os_service_default,
  $keyfile                        = $::os_service_default,
  $memcache_pool_conn_get_timeout = $::os_service_default,
  $memcache_pool_dead_retry       = $::os_service_default,
  $memcache_pool_maxsize          = $::os_service_default,
  $memcache_pool_socket_timeout   = $::os_service_default,
  $memcache_pool_unused_timeout   = $::os_service_default,
  $memcache_secret_key            = $::os_service_default,
  $memcache_security_strategy     = $::os_service_default,
  $memcache_use_advanced_pool     = $::os_service_default,
  $memcached_servers              = $::os_service_default,
  $region_name                    = $::os_service_default,
  $revocation_cache_time          = $::os_service_default,
  $signing_dir                    = $::os_service_default,
  $token_cache_time               = $::os_service_default,
) {

  if is_service_default($password) and ! $::nova::api::admin_password {
    fail('Please set password for nova service user')
  }

  $username_real = pick($::nova::api::admin_user, $username)
  $password_real = pick($::nova::api::admin_password, $password)
  $project_name_real = pick($::nova::api::admin_tenant_name, $project_name)
  $auth_uri_real = pick($::nova::api::auth_uri, $auth_uri)
  $auth_version_real = pick($::nova::api::auth_version, $auth_version)
  $memcached_servers_real = pick($::nova::memcached_servers, $memcached_servers)
  $auth_url_real = pick($::nova::api::identity_uri, $auth_url)

  keystone::resource::authtoken { 'nova_config':
    username                       => $username_real,
    password                       => $password_real,
    project_name                   => $project_name_real,
    auth_url                       => $auth_url_real,
    auth_uri                       => $auth_uri_real,
    auth_version                   => $auth_version_real,
    auth_type                      => $auth_type,
    auth_section                   => $auth_section,
    user_domain_name               => $user_domain_name,
    project_domain_name            => $project_domain_name,
    insecure                       => $insecure,
    cache                          => $cache,
    cafile                         => $cafile,
    certfile                       => $certfile,
    check_revocations_for_cached   => $check_revocations_for_cached,
    delay_auth_decision            => $delay_auth_decision,
    enforce_token_bind             => $enforce_token_bind,
    hash_algorithms                => $hash_algorithms,
    http_connect_timeout           => $http_connect_timeout,
    http_request_max_retries       => $http_request_max_retries,
    include_service_catalog        => $include_service_catalog,
    keyfile                        => $keyfile,
    memcache_pool_conn_get_timeout => $memcache_pool_conn_get_timeout,
    memcache_pool_dead_retry       => $memcache_pool_dead_retry,
    memcache_pool_maxsize          => $memcache_pool_maxsize,
    memcache_pool_socket_timeout   => $memcache_pool_socket_timeout,
    memcache_secret_key            => $memcache_secret_key,
    memcache_security_strategy     => $memcache_security_strategy,
    memcache_use_advanced_pool     => $memcache_use_advanced_pool,
    memcache_pool_unused_timeout   => $memcache_pool_unused_timeout,
    memcached_servers              => $memcached_servers_real,
    region_name                    => $region_name,
    revocation_cache_time          => $revocation_cache_time,
    signing_dir                    => $signing_dir,
    token_cache_time               => $token_cache_time,
  }
}
