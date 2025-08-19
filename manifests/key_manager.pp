# == Class: nova::key_manager
#
# Setup and configure Key Manager options
#
# === Parameters
#
# [*backend*]
#   (Optional) Specify the key manager implementation.
#   Defaults to 'nova.keymgr.conf_key_mgr.ConfKeyManager'
#
class nova::key_manager (
  $backend = 'nova.keymgr.conf_key_mgr.ConfKeyManager',
) {
  include nova::deps

  oslo::key_manager { 'nova_config':
    backend => $backend,
  }
}
