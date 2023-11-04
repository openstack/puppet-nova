# == Class: nova::compute::provider
#
# Managing Resource Providers Using Config File
#
# === Parameters
#
# [*schema_version*]
#   (optional) Version ($Major, $minor) of the schema must successfully
#   parse documents conforming to ($Major, *)
#   Default to '1.0'
#
# [*custom_inventories*]
#   Array of hashes describing the custom provider inventory added via
#   the $config_file config file.
#   Format:
#   name/uuid - Resource providers to target can be identified by either
#   UUID or name. In addition, the value $COMPUTE_NODE can be used in
#   the UUID field to identify all nodes managed by the service.
#   Exactly one of uuid or name is mandatory. If neither uuid or name
#   is provided, the special uuid $COMPUTE_NODE gets set in the template
#
#   inventories - (Optional) Hash of custom provider inventories. 'total' is
#   a mandatory property. Any other optional properties not populated will
#   be given a default value by placement. If overriding a pre-existing
#   provider values will not be preserved from the existing inventory.
#
#   traits - (Optional) Array of additional traits.
#
#   Example :
#   [
#     {
#       uuid => '$COMPUTE_NODE',
#       inventories => {
#         'CUSTOM_EXAMPLE_RESOURCE_CLASS' => {
#           total            => '100',
#           reserved         => '0',
#           min_unit         => '1',
#           max_unit         => '10',
#           step_size        => '1',
#           allocation_ratio => '1.0'
#         },
#         'CUSTOM_ANOTHER_EXAMPLE_RESOURCE_CLASS' => {
#           total            => '100',
#         },
#       },
#       traits => ['CUSTOM_P_STATE_ENABLED','CUSTOM_C_STATE_ENABLED'],
#     },
#     {
#       name => 'EXAMPLE_RESOURCE_PROVIDER',
#       inventories => {
#         'CUSTOM_EXAMPLE_RESOURCE_CLASS' => {
#           total            => '10000',
#           reserved         => '100',
#         },
#       },
#     },
#   ]
#   Defaults to [].
#
# [*config_location*]
#   (Optional) Location of YAML files containing resource provider
#   configuration data.
#   Defaults to /etc/nova/provider_config
#
# [*config_file*]
#   (Optional) File name of the provider YAML file.
#   Defaults to 'provider.yaml'
#
class nova::compute::provider (
  $schema_version                                 = '1.0',
  Array[Hash[String[1], Any]] $custom_inventories = [],
  Stdlib::Absolutepath $config_location           = '/etc/nova/provider_config',
  String[1] $config_file                          = 'provider.yaml',
) {

  include nova::deps
  include nova::params

  nova_config {
    'compute/provider_config_location':  value => $config_location;
  }

  file { "${config_location}":
    ensure  => directory,
    mode    => '0750',
    owner   => $::nova::params::user,
    group   => $::nova::params::group,
    require => Anchor['nova::config::begin'],
    before  => Anchor['nova::config::end'],
  }

  if !empty($custom_inventories) {
    file { "${config_location}/${config_file}":
      ensure  => file,
      mode    => '0640',
      owner   => $::nova::params::user,
      group   => $::nova::params::group,
      content => template('nova/provider.yaml.erb'),
      require => Anchor['nova::config::begin'],
      notify  => Anchor['nova::config::end'],
    }
  }
}
