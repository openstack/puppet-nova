# == Class: nova:patch::config
#
# This class is aim to configure nova.patch parameters
#
# === Parameters:
#
# [*monkey_patch*]
#   (optional) Apply monkey patching or not
#   Defaults to false
#
# [*monkey_patch_modules*]
#   (optional) List of modules/decorators to monkey patch
#   Defaults to $::os_service_default
#
class nova::patch::config (
  $monkey_patch                        = false,
  $monkey_patch_modules                = $::os_service_default,
) {

  include ::nova::deps

  $monkey_patch_modules_real = pick(join(any2array($monkey_patch_modules), ','), $::os_service_default)

  nova_config {
    'DEFAULT/monkey_patch':         value => $monkey_patch;
    'DEFAULT/monkey_patch_modules': value => $monkey_patch_modules_real;
  }
}
