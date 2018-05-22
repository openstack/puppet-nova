# == Class: nova::scheduler::filter
#
# This class is aim to configure nova.scheduler filter
#
# === Parameters:
#
# [*scheduler_max_attempts*]
#   (optional) Maximum number of attempts to schedule an instance
#   Defaults to '3'
#
# [*scheduler_host_subset_size*]
#   (optional) defines the subset size that a host is chosen from
#   Defaults to '1'
#
# [*max_io_ops_per_host*]
#   (optional) Ignore hosts that have too many builds/resizes/snaps/migrations
#   Defaults to '8'
#
# [*isolated_images*]
#   (optional) An array of images to run on isolated host
#   Defaults to $::os_service_default
#
# [*isolated_hosts*]
#   (optional) An array of hosts reserved for specific images
#   Defaults to $::os_service_default
#
# [*max_instances_per_host*]
#   (optional) Ignore hosts that have too many instances
#   Defaults to '50'
#
# [*scheduler_available_filters*]
#   (optional) An array with filter classes available to the scheduler.
#   Example: ['first.filter.class', 'second.filter.class']
#   Defaults to ['nova.scheduler.filters.all_filters']
#
# [*scheduler_default_filters*]
#   (optional) An array of filters to be used by default
#   Defaults to $::os_service_default
#
# [*scheduler_weight_classes*]
#   (optional) Which weight class names to use for weighing hosts
#   Defaults to 'nova.scheduler.weights.all_weighers'
#
# [*periodic_task_interval*]
#   (optional) This value controls how often (in seconds) to run periodic tasks
#   in the scheduler. The specific tasks that are run for each period are
#   determined by the particular scheduler being used.
#   Defaults to $::os_service_default
#
# [*track_instance_changes*]
#   (optional) Enable querying of individual hosts for instance information.
#   Defaults to $::os_service_default
#
# [*ram_weight_multiplier*]
#   (optional) Ram weight multiplier ratio. This option determines how hosts
#   with more or less available RAM are weighed.
#   Defaults to $::os_service_default
#
# [*cpu_weight_multiplier*]
#   (optional) CPU weight multilier ratio. This options determines how hosts
#   with more or less available CPU cores are weighed. Negative numbers mean
#   to stack vs spread.
#   Defaults to $::os_service_default
#
# [*disk_weight_multiplier*]
#   (optional) Disk weight multiplier ratio. Multiplier used for weighing free
#   disk space. Negative numbers mean to stack vs spread.
#   Defaults to $::os_service_default
#
# [*io_ops_weight_multiplier*]
#   (optional) IO operations weight multiplier ratio. This option determines
#   how hosts with differing workloads are weighed
#   Defaults to $::os_service_default
#
# [*soft_affinity_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts for group soft-affinity
#   Defaults to $::os_service_default
#
# [*soft_anti_affinity_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts for group soft-anti-affinity
#   Defaults to $::os_service_default
#
# [*restrict_isolated_hosts_to_isolated_images*]
#   (optional) Prevent non-isolated images from being built on isolated hosts.
#   Defaults to $::os_service_default
#
# [*aggregate_image_properties_isolation_namespace*]
#   (optional) Image property namespace for use in the host aggregate
#   Defaults to $::os_service_default
#
# [*aggregate_image_properties_isolation_separator*]
#   (optional) Separator character(s) for image property namespace and name
#   Defaults to $::os_service_default
#
# DEPRECATED
#
# [*baremetal_scheduler_default_filters*]
#   An array of filters to be used by default for baremetal hosts
#   No longer used. Defaults to undef
#
# [*scheduler_use_baremetal_filters*]
#   Use baremetal_scheduler_default_filters or not.
#   No longer used. Defaults to undef
#
# [*scheduler_host_manager*]
#   The scheduler host manager class to use.
#   No longer used. Defaults to undef
#

class nova::scheduler::filter (
  $scheduler_max_attempts                         = '3',
  $scheduler_host_subset_size                     = '1',
  $max_io_ops_per_host                            = '8',
  $max_instances_per_host                         = '50',
  $isolated_images                                = $::os_service_default,
  $isolated_hosts                                 = $::os_service_default,
  $scheduler_available_filters                    = ['nova.scheduler.filters.all_filters'],
  $scheduler_default_filters                      = $::os_service_default,
  $scheduler_weight_classes                       = 'nova.scheduler.weights.all_weighers',
  $periodic_task_interval                         = $::os_service_default,
  $track_instance_changes                         = $::os_service_default,
  $ram_weight_multiplier                          = $::os_service_default,
  $cpu_weight_multiplier                          = $::os_service_default,
  $disk_weight_multiplier                         = $::os_service_default,
  $io_ops_weight_multiplier                       = $::os_service_default,
  $soft_affinity_weight_multiplier                = $::os_service_default,
  $soft_anti_affinity_weight_multiplier           = $::os_service_default,
  $restrict_isolated_hosts_to_isolated_images     = $::os_service_default,
  $aggregate_image_properties_isolation_namespace = $::os_service_default,
  $aggregate_image_properties_isolation_separator = $::os_service_default,
  # DEPRECATED
  $baremetal_scheduler_default_filters            = undef,
  $scheduler_use_baremetal_filters                = undef,
  $scheduler_host_manager                         = undef,
) {

  include ::nova::deps

  # The following values are following this rule:
  # - default is $::os_service_default so Puppet won't try to configure it.
  # - if set, we'll validate it's an array that is not empty and configure the parameter.
  # - Otherwise, fallback to default.
  if !is_service_default($scheduler_default_filters) and !empty($scheduler_default_filters){
    validate_array($scheduler_default_filters)
    $scheduler_default_filters_real = join($scheduler_default_filters, ',')
  } else {
    $scheduler_default_filters_real = $::os_service_default
  }

  if is_array($scheduler_available_filters) {
    if empty($scheduler_available_filters) {
      $scheduler_available_filters_real = $::os_service_default
    } else {
      $scheduler_available_filters_real = $scheduler_available_filters
    }
  } else {
    warning('scheduler_available_filters must be an array and will fail in the future')
    $scheduler_available_filters_real = any2array($scheduler_available_filters)
  }

  if $baremetal_scheduler_default_filters or $scheduler_use_baremetal_filters or $scheduler_host_manager {
    warning('The scheduler_host_manager, baremetal_scheduler_default_filters and \
scheduler_use_baremetal_filters parameters are deprecated and will have \
no effect. Baremetal scheduling now uses custom resource classes.')
  }

  if !is_service_default($isolated_images) and !empty($isolated_images){
    validate_array($isolated_images)
    $isolated_images_real = join($isolated_images, ',')
  } else {
    $isolated_images_real = $::os_service_default
  }
  if !is_service_default($isolated_hosts) and !empty($isolated_hosts){
    validate_array($isolated_hosts)
    $isolated_hosts_real = join($isolated_hosts, ',')
  } else {
    $isolated_hosts_real = $::os_service_default
  }

  # TODO(aschultz): these should probably be in nova::scheduler ...
  nova_config {
    'scheduler/max_attempts':           value => $scheduler_max_attempts;
    'scheduler/periodic_task_interval': value => $periodic_task_interval;
  }

  nova_config {
    'filter_scheduler/host_subset_size':
      value => $scheduler_host_subset_size;
    'filter_scheduler/max_io_ops_per_host':
      value => $max_io_ops_per_host;
    'filter_scheduler/max_instances_per_host':
      value => $max_instances_per_host;
    'filter_scheduler/track_instance_changes':
      value => $track_instance_changes;
    'filter_scheduler/available_filters':
      value => $scheduler_available_filters_real;
    'filter_scheduler/weight_classes':
      value => $scheduler_weight_classes;
    'filter_scheduler/enabled_filters':
      value => $scheduler_default_filters_real;
    'filter_scheduler/isolated_images':
      value => $isolated_images_real;
    'filter_scheduler/isolated_hosts':
      value => $isolated_hosts_real;
    'filter_scheduler/ram_weight_multiplier':
      value => $ram_weight_multiplier;
    'filter_scheduler/cpu_weight_multiplier':
      value => $cpu_weight_multiplier;
    'filter_scheduler/disk_weight_multiplier':
      value => $disk_weight_multiplier;
    'filter_scheduler/io_ops_weight_multiplier':
      value => $io_ops_weight_multiplier;
    'filter_scheduler/soft_affinity_weight_multiplier':
      value => $soft_affinity_weight_multiplier;
    'filter_scheduler/soft_anti_affinity_weight_multiplier':
      value => $soft_anti_affinity_weight_multiplier;
    'filter_scheduler/restrict_isolated_hosts_to_isolated_images':
      value => $restrict_isolated_hosts_to_isolated_images;
    'filter_scheduler/aggregate_image_properties_isolation_namespace':
      value => $aggregate_image_properties_isolation_namespace;
    'filter_scheduler/aggregate_image_properties_isolation_separator':
      value => $aggregate_image_properties_isolation_separator;
  }

}
