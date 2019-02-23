# Class nova::vendordata
#
# Configures nova vendordata options
#
# === Parameters:
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
# [*vendordata_dynamic_failure_fatal*]
#   (optional) Should failures to fetch dynamic vendordata be fatal to
#   instance boot?
#   Defaults to $::os_service_default
#
#  [*vendordata_dynamic_auth_auth_type*]
#   (optional) Authentication type to load for vendordata dynamic plugins.
#   Defaults to $::os_service_default
#
#  [*vendordata_dynamic_auth_auth_url*]
#   (optional) URL to use for authenticating.
#   Defaults to $::os_service_default
#
#  [*vendordata_dynamic_auth_os_region_name*]
#   (optional) Region name for the vendordata dynamic plugin credentials.
#   Defaults to $::os_service_default
#
#  [*vendordata_dynamic_auth_password*]
#   (optional) Password for the vendordata dynamic plugin credentials.
#   Defaults to $::os_service_default
#
#  [*vendordata_dynamic_auth_project_domain_name*]
#   (optional) Project domain name for the vendordata dynamic plugin
#    credentials.
#   Defaults to 'Default'
#
#  [*vendordata_dynamic_auth_project_name*]
#   (optional) Project name for the vendordata dynamic plugin credentials.
#   Defaults to $::os_service_default
#
#  [*vendordata_dynamic_auth_user_domain_name*]
#   (optional) User domain name for the vendordata dynamic plugin credentials.
#   Defaults to 'Default'
#
#  [*vendordata_dynamic_auth_username*]
#   (optional) User name for the vendordata dynamic plugin credentials.
#   Defaults to $::os_service_default
#
# DEPRECATED
#
#  [*vendordata_caller*]
#   (optional) calling class to be able to consider if we come from
#   ::nova::metadata or ::nova::api. This is only needed until the backward
#   compatability in parameters are removed in these classes.
#   Defaults to undef.
#
class nova::vendordata(
  $vendordata_jsonfile_path                    = $::os_service_default,
  $vendordata_providers                        = $::os_service_default,
  $vendordata_dynamic_targets                  = $::os_service_default,
  $vendordata_dynamic_connect_timeout          = $::os_service_default,
  $vendordata_dynamic_read_timeout             = $::os_service_default,
  $vendordata_dynamic_failure_fatal            = $::os_service_default,
  $vendordata_dynamic_auth_auth_type           = $::os_service_default,
  $vendordata_dynamic_auth_auth_url            = $::os_service_default,
  $vendordata_dynamic_auth_os_region_name      = $::os_service_default,
  $vendordata_dynamic_auth_password            = $::os_service_default,
  $vendordata_dynamic_auth_project_domain_name = 'Default',
  $vendordata_dynamic_auth_project_name        = $::os_service_default,
  $vendordata_dynamic_auth_user_domain_name    = 'Default',
  $vendordata_dynamic_auth_username            = $::os_service_default,
  # DEPRECATED
  $vendordata_caller                           = undef,
) inherits nova::params {
  include ::nova::deps

  # TODO(mschuppert): In order to keep backward compatibility we rely on the
  # pick function. When vendordata parameters got removed from ::nova::api and
  # ::nova::metadata, we remove the checkes here.
  if $vendordata_caller {
    if ($vendordata_caller == 'metadata') {
      # lint:ignore:140chars
      $vendordata_jsonfile_path_real                    = pick($::nova::metadata::vendordata_jsonfile_path, $vendordata_jsonfile_path)
      $vendordata_providers_pick                        = pick($::nova::metadata::vendordata_providers, $vendordata_providers)
      $vendordata_dynamic_targets_pick                  = pick($::nova::metadata::vendordata_dynamic_targets, $vendordata_dynamic_targets)
      $vendordata_dynamic_connect_timeout_real          = pick($::nova::metadata::vendordata_dynamic_connect_timeout, $vendordata_dynamic_connect_timeout)
      $vendordata_dynamic_read_timeout_real             = pick($::nova::metadata::vendordata_dynamic_read_timeout, $vendordata_dynamic_read_timeout)
      $vendordata_dynamic_failure_fatal_real            = pick($::nova::metadata::vendordata_dynamic_failure_fatal, $vendordata_dynamic_failure_fatal)
      $vendordata_dynamic_auth_auth_type_real           = pick($::nova::metadata::vendordata_dynamic_auth_auth_type, $vendordata_dynamic_auth_auth_type)
      $vendordata_dynamic_auth_auth_url_real            = pick($::nova::metadata::vendordata_dynamic_auth_auth_url, $vendordata_dynamic_auth_auth_url)
      $vendordata_dynamic_auth_os_region_name_real      = pick($::nova::metadata::vendordata_dynamic_auth_os_region_name, $vendordata_dynamic_auth_os_region_name)
      $vendordata_dynamic_auth_password_real            = pick($::nova::metadata::vendordata_dynamic_auth_password, $vendordata_dynamic_auth_password)
      $vendordata_dynamic_auth_project_domain_name_real = pick($::nova::metadata::vendordata_dynamic_auth_project_domain_name, $vendordata_dynamic_auth_project_domain_name)
      $vendordata_dynamic_auth_project_name_real        = pick($::nova::metadata::vendordata_dynamic_auth_project_name, $vendordata_dynamic_auth_project_name)
      $vendordata_dynamic_auth_user_domain_name_real    = pick($::nova::metadata::vendordata_dynamic_auth_user_domain_name, $vendordata_dynamic_auth_user_domain_name)
      $vendordata_dynamic_auth_username_real            = pick($::nova::metadata::vendordata_dynamic_auth_username, $vendordata_dynamic_auth_username)
    } elsif ($vendordata_caller == 'api') {
      $vendordata_jsonfile_path_real                    = pick($::nova::api::vendordata_jsonfile_path, $vendordata_jsonfile_path)
      $vendordata_providers_pick                        = pick($::nova::api::vendordata_providers, $vendordata_providers)
      $vendordata_dynamic_targets_pick                  = pick($::nova::api::vendordata_dynamic_targets, $vendordata_dynamic_targets)
      $vendordata_dynamic_connect_timeout_real          = pick($::nova::api::vendordata_dynamic_connect_timeout, $vendordata_dynamic_connect_timeout)
      $vendordata_dynamic_read_timeout_real             = pick($::nova::api::vendordata_dynamic_read_timeout, $vendordata_dynamic_read_timeout)
      $vendordata_dynamic_failure_fatal_real            = pick($::nova::api::vendordata_dynamic_failure_fatal, $vendordata_dynamic_failure_fatal)
      $vendordata_dynamic_auth_auth_type_real           = pick($::nova::api::vendordata_dynamic_auth_auth_type, $vendordata_dynamic_auth_auth_type)
      $vendordata_dynamic_auth_auth_url_real            = pick($::nova::api::vendordata_dynamic_auth_auth_url, $vendordata_dynamic_auth_auth_url)
      $vendordata_dynamic_auth_os_region_name_real      = pick($::nova::api::vendordata_dynamic_auth_os_region_name, $vendordata_dynamic_auth_os_region_name)
      $vendordata_dynamic_auth_password_real            = pick($::nova::api::vendordata_dynamic_auth_password, $vendordata_dynamic_auth_password)
      $vendordata_dynamic_auth_project_domain_name_real = pick($::nova::api::vendordata_dynamic_auth_project_domain_name, $vendordata_dynamic_auth_project_domain_name)
      $vendordata_dynamic_auth_project_name_real        = pick($::nova::api::vendordata_dynamic_auth_project_name, $vendordata_dynamic_auth_project_name)
      $vendordata_dynamic_auth_user_domain_name_real    = pick($::nova::api::vendordata_dynamic_auth_user_domain_name, $vendordata_dynamic_auth_user_domain_name)
      $vendordata_dynamic_auth_username_real            = pick($::nova::api::vendordata_dynamic_auth_username, $vendordata_dynamic_auth_username)
      # lint:endignore
    }
  } else {
    $vendordata_jsonfile_path_real                    = $vendordata_jsonfile_path
    $vendordata_providers_pick                        = $vendordata_providers
    $vendordata_dynamic_targets_pick                  = $vendordata_dynamic_targets
    $vendordata_dynamic_connect_timeout_real          = $vendordata_dynamic_connect_timeout
    $vendordata_dynamic_read_timeout_real             = $vendordata_dynamic_read_timeout
    $vendordata_dynamic_failure_fatal_real            = $vendordata_dynamic_failure_fatal
    $vendordata_dynamic_auth_auth_type_real           = $vendordata_dynamic_auth_auth_type
    $vendordata_dynamic_auth_auth_url_real            = $vendordata_dynamic_auth_auth_url
    $vendordata_dynamic_auth_os_region_name_real      = $vendordata_dynamic_auth_os_region_name
    $vendordata_dynamic_auth_password_real            = $vendordata_dynamic_auth_password
    $vendordata_dynamic_auth_project_domain_name_real = $vendordata_dynamic_auth_project_domain_name
    $vendordata_dynamic_auth_project_name_real        = $vendordata_dynamic_auth_project_name
    $vendordata_dynamic_auth_user_domain_name_real    = $vendordata_dynamic_auth_user_domain_name
    $vendordata_dynamic_auth_username_real            = $vendordata_dynamic_auth_username
  }

  if !is_service_default($vendordata_providers_pick) and !empty($vendordata_providers_pick){
    validate_legacy(Array, 'validate_array', $vendordata_providers_pick)
    $vendordata_providers_real = join($vendordata_providers_pick, ',')
  } else {
    $vendordata_providers_real = $::os_service_default
  }

  if !is_service_default($vendordata_dynamic_targets_pick) and !empty($vendordata_dynamic_targets_pick){
    validate_legacy(Array, 'validate_array', $vendordata_dynamic_targets_pick)
    $vendordata_dynamic_targets_real = join($vendordata_dynamic_targets_pick, ',')
  } else {
    $vendordata_dynamic_targets_real = $::os_service_default
  }

  nova_config {
    'api/vendordata_jsonfile_path':                value => $vendordata_jsonfile_path_real;
    'api/vendordata_providers':                    value => $vendordata_providers_real;
    'api/vendordata_dynamic_targets':              value => $vendordata_dynamic_targets_real;
    'api/vendordata_dynamic_connect_timeout':      value => $vendordata_dynamic_connect_timeout_real;
    'api/vendordata_dynamic_read_timeout':         value => $vendordata_dynamic_read_timeout_real;
    'api/vendordata_dynamic_failure_fatal':        value => $vendordata_dynamic_failure_fatal_real;
    'vendordata_dynamic_auth/auth_type':           value => $vendordata_dynamic_auth_auth_type_real;
    'vendordata_dynamic_auth/auth_url':            value => $vendordata_dynamic_auth_auth_url_real;
    'vendordata_dynamic_auth/os_region_name':      value => $vendordata_dynamic_auth_os_region_name_real;
    'vendordata_dynamic_auth/password':            value => $vendordata_dynamic_auth_password_real, secret => true;
    'vendordata_dynamic_auth/project_domain_name': value => $vendordata_dynamic_auth_project_domain_name_real;
    'vendordata_dynamic_auth/project_name':        value => $vendordata_dynamic_auth_project_name_real;
    'vendordata_dynamic_auth/user_domain_name':    value => $vendordata_dynamic_auth_user_domain_name_real;
    'vendordata_dynamic_auth/username':            value => $vendordata_dynamic_auth_username_real;
  }
}
