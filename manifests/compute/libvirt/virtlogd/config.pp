# == Class: nova::compute::libvirt::virtlogd::config
#
# This class is used to manage arbitrary virtlogd configurations.
#
# === Parameters
#
# [*virtlogd_config*]
#   (optional) Allow configuration of arbitrary libvirtd configurations.
#   The value is an hash of virtlogd_config resources. Example:
#   { 'foo' => { value => 'fooValue'},
#     'bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   virtlogd_config:
#     foo:
#       value: fooValue
#     bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class nova::compute::libvirt::virtlogd::config (
  $virtlogd_config        = {},
) {

  validate_legacy(Hash, 'validate_hash', $virtlogd_config)

  create_resources('virtlogd_config', $virtlogd_config)
}
