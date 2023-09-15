# == Class: nova::scheduler::filter
#
# This class is aim to configure nova.scheduler filter
#
# === Parameters:
#
# [*host_subset_size*]
#   (optional) defines the subset size that a host is chosen from
#   Defaults to $facts['os_service_default']
#
# [*max_io_ops_per_host*]
#   (optional) Ignore hosts that have too many builds/resizes/snaps/migrations
#   Defaults to $facts['os_service_default']
#
# [*max_instances_per_host*]
#   (optional) Ignore hosts that have too many instances
#   Defaults to $facts['os_service_default']
#
# [*isolated_images*]
#   (optional) An array of images to run on isolated host
#   Defaults to $facts['os_service_default']
#
# [*isolated_hosts*]
#   (optional) An array of hosts reserved for specific images
#   Defaults to $facts['os_service_default']
#
# [*available_filters*]
#   (optional) An array with filter classes available to the scheduler.
#   Example: ['first.filter.class', 'second.filter.class']
#   Defaults to ['nova.scheduler.filters.all_filters']
#
# [*enabled_filters*]
#   (optional) An array of filters to be used by default
#   Defaults to $facts['os_service_default']
#
# [*weight_classes*]
#   (optional) Which weight class names to use for weighing hosts
#   Defaults to 'nova.scheduler.weights.all_weighers'
#
# [*track_instance_changes*]
#   (optional) Enable querying of individual hosts for instance information.
#   Defaults to $facts['os_service_default']
#
# [*ram_weight_multiplier*]
#   (optional) Ram weight multiplier ratio. This option determines how hosts
#   with more or less available RAM are weighed.
#   Defaults to $facts['os_service_default']
#
# [*cpu_weight_multiplier*]
#   (optional) CPU weight multiplier ratio. This options determines how hosts
#   with more or less available CPU cores are weighed. Negative numbers mean
#   to stack vs spread.
#   Defaults to $facts['os_service_default']
#
# [*disk_weight_multiplier*]
#   (optional) Disk weight multiplier ratio. Multiplier used for weighing free
#   disk space. Negative numbers mean to stack vs spread.
#   Defaults to $facts['os_service_default']
#
# [*io_ops_weight_multiplier*]
#   (optional) IO operations weight multiplier ratio. This option determines
#   how hosts with differing workloads are weighed
#   Defaults to $facts['os_service_default']
#
# [*soft_affinity_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts for group soft-affinity
#   Defaults to $facts['os_service_default']
#
# [*soft_anti_affinity_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts for group soft-anti-affinity
#   Defaults to $facts['os_service_default']
#
# [*build_failure_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts that have had recent build
#   failures
#   Defaults to $facts['os_service_default']
#
# [*cross_cell_move_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts during a cross-cell move
#   Defaults to $facts['os_service_default']
#
# [*num_instances_weight_multiplier*]
#   (optional) Number of instances weight multiplier ratio.
#   Defaults to $facts['os_service_default']
#
# [*hypervisor_version_weight_multiplier*]
#   (optional) Hypervisor Version weight multiplier ratio.
#   Defaults to $facts['os_service_default']
#
# [*shuffle_best_same_weighed_hosts*]
#   (optional) Enabled spreading the instances between hosts with the same
#   best weight
#   Defaults to $facts['os_service_default']
#
# [*restrict_isolated_hosts_to_isolated_images*]
#   (optional) Prevent non-isolated images from being built on isolated hosts.
#   Defaults to $facts['os_service_default']
#
# [*aggregate_image_properties_isolation_namespace*]
#   (optional) Image property namespace for use in the host aggregate
#   Defaults to $facts['os_service_default']
#
# [*aggregate_image_properties_isolation_separator*]
#   (optional) Separator character(s) for image property namespace and name
#   Defaults to $facts['os_service_default']
#
# == DEPRECATED PARAMETERS ==
#
# [*scheduler_host_subset_size*]
#   (optional) defines the subset size that a host is chosen from
#   Defaults to undef
#
# [*scheduler_available_filters*]
#   (optional) An array with filter classes available to the scheduler.
#   Example: ['first.filter.class', 'second.filter.class']
#   Defaults to undef
#
# [*scheduler_enabled_filters*]
#   (optional) An array of filters to be used by default
#   Defaults to undef
#
# [*scheduler_weight_classes*]
#   (optional) Which weight class names to use for weighing hosts
#   Defaults to undef
#
class nova::scheduler::filter (
  $host_subset_size                               = $facts['os_service_default'],
  $max_io_ops_per_host                            = $facts['os_service_default'],
  $max_instances_per_host                         = $facts['os_service_default'],
  $isolated_images                                = $facts['os_service_default'],
  $isolated_hosts                                 = $facts['os_service_default'],
  $available_filters                              = $facts['os_service_default'],
  $enabled_filters                                = $facts['os_service_default'],
  $weight_classes                                 = $facts['os_service_default'],
  $track_instance_changes                         = $facts['os_service_default'],
  $ram_weight_multiplier                          = $facts['os_service_default'],
  $cpu_weight_multiplier                          = $facts['os_service_default'],
  $disk_weight_multiplier                         = $facts['os_service_default'],
  $io_ops_weight_multiplier                       = $facts['os_service_default'],
  $soft_affinity_weight_multiplier                = $facts['os_service_default'],
  $soft_anti_affinity_weight_multiplier           = $facts['os_service_default'],
  $build_failure_weight_multiplier                = $facts['os_service_default'],
  $cross_cell_move_weight_multiplier              = $facts['os_service_default'],
  $num_instances_weight_multiplier                = $facts['os_service_default'],
  $hypervisor_version_weight_multiplier           = $facts['os_service_default'],
  $shuffle_best_same_weighed_hosts                = $facts['os_service_default'],
  $restrict_isolated_hosts_to_isolated_images     = $facts['os_service_default'],
  $aggregate_image_properties_isolation_namespace = $facts['os_service_default'],
  $aggregate_image_properties_isolation_separator = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $scheduler_host_subset_size                     = undef,
  $scheduler_available_filters                    = undef,
  $scheduler_enabled_filters                      = undef,
  $scheduler_weight_classes                       = undef,
) {

  include nova::deps

  $host_subset_size_real = pick($scheduler_host_subset_size, $host_subset_size)
  $weight_classes_real = pick($scheduler_weight_classes, $weight_classes)

  $enabled_filters_pick = pick($scheduler_enabled_filters, $enabled_filters)

  if is_service_default($enabled_filters_pick) {
    $enabled_filters_real = $facts['os_service_default']
  } elsif empty($enabled_filters_pick){
    $enabled_filters_real = $facts['os_service_default']
  } else {
    $enabled_filters_real = join(any2array($enabled_filters_pick), ',')
  }

  $available_filters_pick = pick($scheduler_available_filters, $available_filters)

  if empty($available_filters_pick) {
    $available_filters_real = $facts['os_service_default']
  } else {
    $available_filters_real = $available_filters_pick
  }

  nova_config {
    'filter_scheduler/host_subset_size':
      value => $host_subset_size_real;
    'filter_scheduler/max_io_ops_per_host':
      value => $max_io_ops_per_host;
    'filter_scheduler/max_instances_per_host':
      value => $max_instances_per_host;
    'filter_scheduler/track_instance_changes':
      value => $track_instance_changes;
    'filter_scheduler/available_filters':
      value => $available_filters_real;
    'filter_scheduler/weight_classes':
      value => $weight_classes_real;
    'filter_scheduler/enabled_filters':
      value => $enabled_filters_real;
    'filter_scheduler/isolated_images':
      value => join(any2array($isolated_images), ',');
    'filter_scheduler/isolated_hosts':
      value => join(any2array($isolated_hosts), ',');
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
    'filter_scheduler/build_failure_weight_multiplier':
      value => $build_failure_weight_multiplier;
    'filter_scheduler/cross_cell_move_weight_multiplier':
      value => $cross_cell_move_weight_multiplier;
    'filter_scheduler/num_instances_weight_multiplier':
      value => $num_instances_weight_multiplier;
    'filter_scheduler/hypervisor_version_weight_multiplier':
      value => $hypervisor_version_weight_multiplier;
    'filter_scheduler/shuffle_best_same_weighed_hosts':
      value => $shuffle_best_same_weighed_hosts;
    'filter_scheduler/restrict_isolated_hosts_to_isolated_images':
      value => $restrict_isolated_hosts_to_isolated_images;
    'filter_scheduler/aggregate_image_properties_isolation_namespace':
      value => $aggregate_image_properties_isolation_namespace;
    'filter_scheduler/aggregate_image_properties_isolation_separator':
      value => $aggregate_image_properties_isolation_separator;
  }

}
