# Creates floating networks
#
# === Parameters:
#
# [*network*]
#  (mandatory) The network name to work on
#
define nova::manage::floating (
  $network
) {

  include nova::deps

  warning('The nova::manage::floating class is deprecated and has no effect')
}
