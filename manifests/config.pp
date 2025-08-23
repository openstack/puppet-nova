# == Class: nova::config
#
# This class is used to manage arbitrary Nova configurations.
#
# example xxx_config
#   (optional) Allow configuration of arbitrary Nova configurations.
#   The value is a hash of xxx_config resources. Example:
#   server_config =>
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#
#   NOTE: { 'DEFAULT/foo': value => 'fooValue'; 'DEFAULT/bar': value => 'barValue'} is invalid.
#
#   In yaml format, Example:
#   server_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# === Parameters
#
# [*nova_config*]
#   (optional) Allow configuration of nova.conf configurations.
#
# [*nova_api_paste_ini*]
#   (optional) Allow configuration of api-paste.ini configurations.
#
# [*nova_rootwrap_config*]
#   (optional) Allow configuration of rootwrap.conf configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class nova::config (
  Hash $nova_config          = {},
  Hash $nova_api_paste_ini   = {},
  Hash $nova_rootwrap_config = {},
) {
  include nova::deps

  create_resources('nova_config', $nova_config)
  create_resources('nova_api_paste_ini', $nova_api_paste_ini)
  create_resources('nova_rootwrap_config', $nova_rootwrap_config)
}
