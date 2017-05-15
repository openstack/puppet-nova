# == Define: nova::generic_service
#
# This defined type implements basic nova services.
# It is introduced to attempt to consolidate
# common code.
#
# It also allows users to specify ad-hoc services
# as needed
#
# This define creates a service resource with title nova-${name} and
# conditionally creates a package resource with title nova-${name}
#
# === Parameters:
#
# [*package_name*]
#   (mandatory) The package name (for the generic_service)
#
# [*service_name*]
#   (mandatory) The service name (for the generic_service)
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not
#   Defaults to false.
#
# [*manage_service*]
#   (optional) Manage or not the service (if a service_name is provided).
#   Defaults to true.
#
# [*ensure_package*]
#   (optional) Control the ensure parameter for the package resource.
#   Defaults to 'present'.
#
define nova::generic_service(
  $package_name,
  $service_name,
  $enabled        = true,
  $manage_service = true,
  $ensure_package = 'present'
) {

  include ::nova::deps
  include ::nova::params

  $nova_title = "nova-${name}"

  # I need to mark that ths package should be
  # installed before nova_config
  if ($package_name) {
    if !defined(Package[$nova_title]) and !defined(Package[$package_name]) {
      package { $nova_title:
        ensure => $ensure_package,
        name   => $package_name,
        tag    => ['openstack', 'nova-package'],
      }
    }
  }

  if $service_name {
    if $manage_service {
      if $enabled {
        $service_ensure = 'running'
      } else {
        $service_ensure = 'stopped'
      }
    }

    service { $nova_title:
      ensure    => $service_ensure,
      name      => $service_name,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'nova-service',
    }
  }
}
