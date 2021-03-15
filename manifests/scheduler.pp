# == Class: nova::scheduler
#
# Install and manage nova scheduler
#
# === Parameters:
#
# [*enabled*]
#   (Optional) Whether to run the scheduler service
#   Defaults to true
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service
#   Defaults to true
#
# [*ensure_package*]
#   (Optional) The state of the scheduler package
#   Defaults to 'present'
#
# [*workers*]
#   (Optional) The amount of scheduler workers.
#   Defaults to $::os_workers
#
# [*max_attempts*]
#   (optional) Maximum number of attempts to schedule an instance
#   Defaults to $::os_service_default
#
# [*periodic_task_interval*]
#   (Optional) This value controls how often (in seconds) to run periodic tasks
#   in the scheduler. The specific tasks that are run for each period are
#   determined by the particular scheduler being used.
#   Defaults to $::os_service_default
#
# [*discover_hosts_in_cells_interval*]
#   (Optional) This value controls how often (in seconds) the scheduler should
#   attempt to discover new hosts that have been added to cells.
#   Defaults to $::os_service_default
#
# [*query_placement_for_image_type_support*]
#   (Optional) This setting causes the scheduler to ask placement only for
#   compute hosts that support the ``disk_format`` of the image used in the
#   request.
#   Defaults to $::os_service_default
#
# [*limit_tenants_to_placement_aggregate*]
#   (Optional) This setting allows to have tenant isolation with placement.
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
# [*max_placement_results*]
#   (Optional) This setting determines the maximum limit on results received
#   from the placement service during a scheduling operation.
#   Defaults to $::os_service_default
#
# [*enable_isolated_aggregate_filtering*]
#   (Optional) This setting allows the scheduler to restrict hosts in aggregates
#   based on matching required traits in the aggregate metadata and the instance
#   flavor/image.
#   Defaults to $::os_service_default
#
# [*query_placement_for_availability_zone*]
#   (Optional) This setting allows the scheduler to look up a host aggregate
#   with metadata key of availability zone set to the value provided by
#   incoming request, and request result from placement be limited to that
#   aggregate.
#   Defaults to $::os_service_default
#
# [*query_placement_for_routed_network_aggregates*]
#   (Optional) This setting allows to enable the scheduler to filter
#   compute hosts affined to routed network segment aggregates.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*scheduler_driver*]
#   (Optional) Default driver to use for the scheduler
#   Defaults to undef
#
class nova::scheduler(
  $enabled                                       = true,
  $manage_service                                = true,
  $ensure_package                                = 'present',
  $workers                                       = $::os_workers,
  $max_attempts                                  = $::os_service_default,
  $periodic_task_interval                        = $::os_service_default,
  $discover_hosts_in_cells_interval              = $::os_service_default,
  $query_placement_for_image_type_support        = $::os_service_default,
  $limit_tenants_to_placement_aggregate          = $::os_service_default,
  $placement_aggregate_required_for_tenants      = $::os_service_default,
  $max_placement_results                         = $::os_service_default,
  $enable_isolated_aggregate_filtering           = $::os_service_default,
  $query_placement_for_availability_zone         = $::os_service_default,
  $query_placement_for_routed_network_aggregates = $::os_service_default,
  # DEPRECATED PARAMETERS
  $scheduler_driver                              = undef,
) {

  include nova::deps
  include nova::db
  include nova::params
  include nova::availability_zone

  nova::generic_service { 'scheduler':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_name   => $::nova::params::scheduler_package_name,
    service_name   => $::nova::params::scheduler_service_name,
    ensure_package => $ensure_package,
  }

  # TODO(tkajinam): Remove this when we remove the deprecated parameters
  #                 from the nova::scheduler::filter class
  $max_attempts_real = pick($::nova::scheduler::filter::scheduler_max_attempts, $max_attempts)
  $periodic_task_interval_real = pick($::nova::scheduler::filter::periodic_task_interval, $periodic_task_interval)

  nova_config {
    'scheduler/workers':                                       value => $workers;
    'scheduler/max_attempts':                                  value => $max_attempts_real;
    'scheduler/periodic_task_interval':                        value => $periodic_task_interval_real;
    'scheduler/discover_hosts_in_cells_interval':              value => $discover_hosts_in_cells_interval;
    'scheduler/query_placement_for_image_type_support':        value => $query_placement_for_image_type_support;
    'scheduler/limit_tenants_to_placement_aggregate':          value => $limit_tenants_to_placement_aggregate;
    'scheduler/placement_aggregate_required_for_tenants':      value => $placement_aggregate_required_for_tenants;
    'scheduler/max_placement_results':                         value => $max_placement_results;
    'scheduler/enable_isolated_aggregate_filtering':           value => $enable_isolated_aggregate_filtering;
    'scheduler/query_placement_for_availability_zone':         value => $query_placement_for_availability_zone;
    'scheduler/query_placement_for_routed_network_aggregates': value => $query_placement_for_routed_network_aggregates;
  }

  if $scheduler_driver != undef {
    warning('The scheduler_driver parameter is deprecated and will be removed \
in a future release')
    nova_config {
      'scheduler/driver': value => $scheduler_driver;
    }
  } else {
    nova_config {
      'scheduler/driver': ensure => absent;
    }
  }
}
