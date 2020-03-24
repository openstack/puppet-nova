# == Class: nova::scheduler
#
# Install and manage nova scheduler
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to run the scheduler service
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (optional) The state of the scheduler package
#   Defaults to 'present'
#
# [*workers*]
#   (optional) The amount of scheduler workers.
#   Defaults to $::os_workers
#
# [*scheduler_driver*]
#   (optional) Default driver to use for the scheduler
#   Defaults to 'filter_scheduler'
#
# [*discover_hosts_in_cells_interval*]
#   (optional) This value controls how often (in seconds) the scheduler should
#   attempt to discover new hosts that have been added to cells.
#   Defaults to $::os_service_default
#
# [*query_placement_for_image_type_support*]
#   (optional) This setting causes the scheduler to ask placement only for
#   compute hosts that support the ``disk_format`` of the image used in the
#   request.
#   Defaults to $::os_service_default
#
# [*limit_tenants_to_placement_aggregate*]
#   (optional) This setting allows to have tenant isolation with placement.
#   It ensures hosts in tenant-isolated host aggregate and availability
#   zones will only be available to specific set of tenants.
#   Defaults to $::os_service_default
#
# [*placement_aggregate_required_for_tenants*]
#   (Optional) This setting controls if a tenant with no aggregate affinity
#   will be allowed to schedule to any availalbe node when
#   ``limit_tenants_to_placement_aggregate`` is set to True.
#   If aggregates are used to limit some tenants but not all, then this should
#   be False.
#   If all tenants should be confined via aggregate, then this should be True.
#   Defaults to $::os_service_default
#
class nova::scheduler(
  $enabled                                  = true,
  $manage_service                           = true,
  $ensure_package                           = 'present',
  $workers                                  = $::os_workers,
  $scheduler_driver                         = 'filter_scheduler',
  $discover_hosts_in_cells_interval         = $::os_service_default,
  $query_placement_for_image_type_support   = $::os_service_default,
  $limit_tenants_to_placement_aggregate     = $::os_service_default,
  $placement_aggregate_required_for_tenants = $::os_service_default,
) {

  include ::nova::deps
  include ::nova::db
  include ::nova::params
  include ::nova::availability_zone

  nova::generic_service { 'scheduler':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::scheduler_package_name,
    service_name   => $::nova::params::scheduler_service_name,
    ensure_package => $ensure_package,
  }

  nova_config {
    'scheduler/workers':                                  value => $workers;
    'scheduler/driver':                                   value => $scheduler_driver;
    'scheduler/discover_hosts_in_cells_interval':         value => $discover_hosts_in_cells_interval;
    'scheduler/query_placement_for_image_type_support':   value => $query_placement_for_image_type_support;
    'scheduler/limit_tenants_to_placement_aggregate':     value => $limit_tenants_to_placement_aggregate;
    'scheduler/placement_aggregate_required_for_tenants': value => $placement_aggregate_required_for_tenants;
  }

}
