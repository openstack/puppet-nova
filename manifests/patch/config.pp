# == Class: nova:patch::config
#
# DEPRECATED !!!
# This class is aim to configure nova.patch parameters
#
# === Parameters:
#
# [*monkey_patch*]
#   (optional) Apply monkey patching or not
#   Defaults to $facts['os_service_default']
#
# [*monkey_patch_modules*]
#   (optional) List of modules/decorators to monkey patch
#   Defaults to $facts['os_service_default']
#
class nova::patch::config (
  $monkey_patch         = $facts['os_service_default'],
  $monkey_patch_modules = $facts['os_service_default'],
) {

  include nova::deps

  warning("The nova::patch::config class has been deprecated \"
and will be removed in the future release.")

  $monkey_patch_modules_real = pick(join(any2array($monkey_patch_modules), ','), $facts['os_service_default'])

  nova_config {
    'DEFAULT/monkey_patch':         value => $monkey_patch;
    'DEFAULT/monkey_patch_modules': value => $monkey_patch_modules_real;
  }
}
