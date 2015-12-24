# == Class: nova::availability_zone
#
# nova availability zone configuration
#
# === Parameters:
#
#  [*default_availability_zone*]
#   (optional) Default compute node availability zone.
#   Defaults to $::os_service_default
#
#  [*default_schedule_zone*]
#   (optional) Availability zone to use when user doesn't specify one.
#   Defaults to $::os_service_default
#
#  [*internal_service_availability_zone*]
#   (optional) The availability zone to show internal services under.
#   Defaults to $::os_service_default
#
class nova::availability_zone (
  $default_availability_zone          = $::os_service_default,
  $default_schedule_zone              = $::os_service_default,
  $internal_service_availability_zone = $::os_service_default,
) {

  # NOTE(dalees): In order to keep backward compatibility from nova::compute we
  # rely on the pick function.
  $default_availability_zone_real = pick(
    $::nova::compute::default_availability_zone,
    $default_availability_zone)
  $default_schedule_zone_real = pick(
    $::nova::compute::default_schedule_zone,
    $default_schedule_zone)
  $internal_service_availability_zone_real = pick(
    $::nova::compute::internal_service_availability_zone,
    $internal_service_availability_zone)

  nova_config {
    'DEFAULT/default_availability_zone':          value => $default_availability_zone_real;
    'DEFAULT/default_schedule_zone':              value => $default_schedule_zone_real;
    'DEFAULT/internal_service_availability_zone': value => $internal_service_availability_zone_real;
  }

}
