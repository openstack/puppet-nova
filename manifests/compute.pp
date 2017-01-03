# == Class: nova::compute
#
# Installs the nova-compute service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the nova-compute service
#   Defaults to true
#
# [*heal_instance_info_cache_interval*]
#   (optional) Controls how often the instance info should be updated.
#    Defaults to '60' , to disable you can set the value to zero.
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) The state for the nova-compute package
#   Defaults to 'present'
#
# [*vnc_enabled*]
#   (optional) Whether to use a VNC proxy
#   Defaults to true
#
# [*vncserver_proxyclient_address*]
#   (optional) The IP address of the server running the VNC proxy client
#   Defaults to '127.0.0.1'
#
# [*vncproxy_host*]
#   (optional) The host of the VNC proxy server
#   Defaults to false
#
# [*vncproxy_protocol*]
#   (optional) The protocol to communicate with the VNC proxy server
#   Defaults to 'http'
#
# [*vncproxy_port*]
#   (optional) The port to communicate with the VNC proxy server
#   Defaults to '6080'
#
# [*vncproxy_path*]
#   (optional) The path at the end of the uri for communication with the VNC proxy server
#   Defaults to '/vnc_auto.html'
#
# [*vnc_keymap*]
#   (optional) The keymap to use with VNC (ls -alh /usr/share/qemu/keymaps to list available keymaps)
#   Defaults to 'en-us'
#
# [*force_config_drive*]
#   (optional) Whether to force the config drive to be attached to all VMs
#   Defaults to false
#
# [*virtio_nic*]
#   (optional) Whether to use virtio for the nic driver of VMs
#   Defaults to false
#
# [*neutron_enabled*]
#   (optional) Whether to use Neutron for networking of VMs
#   Defaults to true
#
# [*install_bridge_utils*]
#   (optional) Whether to install the bridge-utils package or not.
#   Applicable only for cases when Neutron was disabled
#   Defaults to true
#
# [*instance_usage_audit*]
#   (optional) Generate periodic compute.instance.exists notifications.
#   Defaults to false
#
# [*instance_usage_audit_period*]
#   (optional) Time period to generate instance usages for.
#   Time period must be hour, day, month or year
#   Defaults to 'month'
#
#  [*force_raw_images*]
#   (optional) Force backing images to raw format.
#   Defaults to true
#
#  [*reserved_host_memory*]
#   Reserved host memory
#   The amount of memory in MB reserved for the host.
#   Defaults to '512'
#
#  [*pci_passthrough*]
#   (optional) Pci passthrough list of hash.
#   Defaults to $::os_service_default
#   Example of format:
#  "[ { 'vendor_id':'1234','product_id':'5678' },
#     { 'vendor_id':'4321','product_id':'8765','physical_network':'default' } ] "
#
#  [*config_drive_format*]
#    (optional) Config drive format. One of iso9660 (default) or vfat
#    Defaults to undef
#
#  [*allow_resize_to_same_host*]
#    (optional) Allow destination machine to match source for resize.
#    Useful when testing in single-host environments.
#    Defaults to false
#
#  [*resize_confirm_window*]
#   (optional) Automatically confirm resizes after N seconds.
#   Resize functionality will save the existing server before resizing.
#   After the resize completes, user is requested to confirm the resize.
#   The user has the opportunity to either confirm or revert all
#   changes. Confirm resize removes the original server and changes
#   server status from resized to active. Setting this option to a time
#   period (in seconds) will automatically confirm the resize if the
#   server is in resized state longer than that time.
#   Defaults to $::os_service_default
#
#  [*vcpu_pin_set*]
#    (optional) A list or range of physical CPU cores to reserve
#    for virtual machine processes
#    Defaults to $::os_service_default
#
#  [*resume_guests_state_on_host_boot*]
#   (optional) This option specifies whether to start guests that were running before the
#   host rebooted. It ensures that all of the instances on a Nova compute node
#   resume their state each time the compute node boots or restarts.
#   Defaults to $::os_service_default
#
# [*keymgr_api_class*]
#   (optional) Key Manager service.
#   Example of valid value: castellan.key_manager.barbican_key_manager.BarbicanKeyManager
#   Defaults to $::os_service_default
#
# [*barbican_auth_endpoint*]
#   (optional) Keystone v3 API URL.
#   Example: http://localhost:5000/v3
#   Defaults to $::os_service_default
#
# [*barbican_endpoint*]
#   (optional) Barbican URL.
#   Defaults to $::os_service_default
#
# [*barbican_api_version*]
#   (optional) Barbican API version.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
#  [*default_availability_zone*]
#   (optional) Default compute node availability zone.
#   Defaults to undef
#
#  [*default_schedule_zone*]
#   (optional) Availability zone to use when user doesn't specify one.
#   Defaults to undef
#
#  [*internal_service_availability_zone*]
#   (optional) The availability zone to show internal services under.
#   Defaults to undef
#
#  [*network_device_mtu*]
#   (optional) Deprecated. The MTU size for the interfaces managed by nova
#   Defaults to undef
#
#  [*compute_manager*]
#   Deprecated. Compute manager
#   The driver that will manage the running instances.
#   Defaults to $::os_service_default
#
class nova::compute (
  $enabled                            = true,
  $manage_service                     = true,
  $ensure_package                     = 'present',
  $vnc_enabled                        = true,
  $vncserver_proxyclient_address      = '127.0.0.1',
  $vncproxy_host                      = false,
  $vncproxy_protocol                  = 'http',
  $vncproxy_port                      = '6080',
  $vncproxy_path                      = '/vnc_auto.html',
  $vnc_keymap                         = 'en-us',
  $force_config_drive                 = false,
  $virtio_nic                         = false,
  $neutron_enabled                    = true,
  $install_bridge_utils               = true,
  $instance_usage_audit               = false,
  $instance_usage_audit_period        = 'month',
  $force_raw_images                   = true,
  $reserved_host_memory               = '512',
  $heal_instance_info_cache_interval  = '60',
  $pci_passthrough                    = $::os_service_default,
  $config_drive_format                = $::os_service_default,
  $allow_resize_to_same_host          = false,
  $resize_confirm_window              = $::os_service_default,
  $vcpu_pin_set                       = $::os_service_default,
  $resume_guests_state_on_host_boot   = $::os_service_default,
  $keymgr_api_class                   = $::os_service_default,
  $barbican_auth_endpoint             = $::os_service_default,
  $barbican_endpoint                  = $::os_service_default,
  $barbican_api_version               = $::os_service_default,
  # DEPRECATED PARAMETERS
  $default_availability_zone          = undef,
  $default_schedule_zone              = undef,
  $internal_service_availability_zone = undef,
  $network_device_mtu                 = undef,
  $compute_manager                    = $::os_service_default,
) {

  include ::nova::deps
  include ::nova::params

  if $default_availability_zone {
    warning("The default_availability_zone parameter is deprecated and will be removed in a \
future release. Use default_availability_zone parameter of nova class instead.")
  }

  if $default_schedule_zone {
    warning("The default_schedule_zone parameter is deprecated and will be removed in a \
future release. Use default_schedule_zone parameter of nova class instead.")
  }

  if $internal_service_availability_zone {
    warning("The internal_service_availability_zone parameter is deprecated and will be \
removed in a future release. Use internal_service_availability_zone parameter of nova class instead.")
  }

  if $network_device_mtu {
    warning('network_device_mtu parameter is deprecated, has no effect and will be removed in a future release.')
  }

  if $compute_manager {
    warning("compute_manager is marked as deprecated in Nova but still needed when Ironic \
is used. It will be removed once Nova removes it.")
  }

  $vcpu_pin_set_real = pick(join(any2array($vcpu_pin_set), ','), $::os_service_default)

  # in the case of pci_passthrough, we can't use the same mechanism as vcpu_pin_set because
  # the value is computed in a function and it makes things more complex. Let's just check if
  # a value is set or if it's empty.
  if !is_service_default($pci_passthrough) and !empty($pci_passthrough) {
    $pci_passthrough_real = check_array_of_hash($pci_passthrough)
  } else {
    $pci_passthrough_real = $::os_service_default
  }

  # cryptsetup is required when Barbican is encrypting volumes
  if $keymgr_api_class =~ /barbican/ {
    ensure_packages('cryptsetup', {
      ensure => present,
      tag    => 'openstack',
    })
  }

  include ::nova::availability_zone

  nova_config {
    'DEFAULT/reserved_host_memory_mb':           value => $reserved_host_memory;
    'DEFAULT/compute_manager':                   value => $compute_manager;
    'DEFAULT/heal_instance_info_cache_interval': value => $heal_instance_info_cache_interval;
    'DEFAULT/allow_resize_to_same_host':         value => $allow_resize_to_same_host;
    'DEFAULT/pci_passthrough_whitelist':         value => $pci_passthrough_real;
    'DEFAULT/resize_confirm_window':             value => $resize_confirm_window;
    'DEFAULT/vcpu_pin_set':                      value => $vcpu_pin_set_real;
    'DEFAULT/resume_guests_state_on_host_boot':  value => $resume_guests_state_on_host_boot;
    'key_manager/api_class':                     value => $keymgr_api_class;
    'barbican/auth_endpoint':                    value => $barbican_auth_endpoint;
    'barbican/barbican_endpoint':                value => $barbican_endpoint;
    'barbican/barbican_api_version':             value => $barbican_api_version;
  }

  if ($vnc_enabled) {
    include ::nova::vncproxy::common

    nova_config {
      'vnc/vncserver_proxyclient_address': value =>
        $vncserver_proxyclient_address;
      'vnc/keymap':                        value => $vnc_keymap;
    }
  } else {
    nova_config {
      'vnc/vncserver_proxyclient_address': ensure => absent;
      'vnc/keymap':                        ensure => absent;
    }
  }
  nova_config {
    'vnc/enabled': value => $vnc_enabled;
  }

  if $neutron_enabled != true and $install_bridge_utils {
    # Install bridge-utils if we use nova-network
    package { 'bridge-utils':
      ensure => present,
      tag    => ['openstack', 'nova-support-package'],
    }
  }

  nova::generic_service { 'compute':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::compute_package_name,
    service_name   => $::nova::params::compute_service_name,
    ensure_package => $ensure_package,
    before         => Exec['networking-refresh']
  }

  if $force_config_drive {
    nova_config { 'DEFAULT/force_config_drive': value => true }
  } else {
    nova_config { 'DEFAULT/force_config_drive': ensure => absent }
  }

  if $virtio_nic {
    # Enable the virtio network card for instances
    nova_config { 'DEFAULT/libvirt_use_virtio_for_bridges': value => true }
  }

  if $instance_usage_audit and $instance_usage_audit_period in ['hour', 'day', 'month', 'year'] {
    nova_config {
      'DEFAULT/instance_usage_audit':        value => $instance_usage_audit;
      'DEFAULT/instance_usage_audit_period': value => $instance_usage_audit_period;
    }
  } else {
    nova_config {
      'DEFAULT/instance_usage_audit':        ensure => absent;
      'DEFAULT/instance_usage_audit_period': ensure => absent;
    }
  }

  nova_config {
    'DEFAULT/force_raw_images': value => $force_raw_images;
  }

  if is_service_default($config_drive_format) or $config_drive_format == 'iso9660' {
    ensure_packages($::nova::params::genisoimage_package_name, {
      tag => ['openstack', 'nova-support-package'],
    })
  }

  nova_config {
    'DEFAULT/config_drive_format': value => $config_drive_format;
  }

}
