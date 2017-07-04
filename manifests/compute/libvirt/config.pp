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
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class nova::compute::libvirt::config (
  $libvirtd_config        = {},
) {

  validate_hash($libvirtd_config)

  create_resources('libvirtd_config', $libvirtd_config)
}
