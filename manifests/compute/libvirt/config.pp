# == Class: nova::compute::libvirt::config
#
# This class is used to manage arbitrary libvirtd configurations.
#
# === Parameters
#
# [*libvirtd_config*]
#   (optional) Allow configuration of arbitrary libvirtd configurations.
#   The value is an hash of libvirtd_config resources. Example:
#   { 'foo' => { value => 'fooValue'},
#     'bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   libvirtd_config:
#     foo:
#       value: fooValue
#     bar:
#       value: barValue
#
# [*virtlogd_config*]
#   (optional) Allow configuration of arbitrary virtlogd configurations.
#   The value is an hash of virtlogd_config resources.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class nova::compute::libvirt::config (
  $libvirtd_config = {},
  $virtlogd_config = {},
) {

  include nova::deps

  validate_legacy(Hash, 'validate_hash', $libvirtd_config)
  validate_legacy(Hash, 'validate_hash', $virtlogd_config)

  create_resources('libvirtd_config', $libvirtd_config)
  create_resources('virtlogd_config', $virtlogd_config)
}
