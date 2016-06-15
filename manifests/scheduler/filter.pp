# == Class: nova:scheduler::filter
#
# This class is aim to configure nova.scheduler filter
#
# === Parameters:
#
# [*scheduler_host_manager*]
#   (optional) The scheduler host manager class to use
#   Defaults to 'host_manager'
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
# [*baremetal_scheduler_default_filters*]
#   (optional) An array of filters to be used by default for baremetal hosts
#   Defaults to $::os_service_default
#
# [*scheduler_use_baremetal_filters*]
#   (optional) Use baremetal_scheduler_default_filters or not.
#   Defaults to false
#
# DEPRECATED PARAMETERS
#
# [*cpu_allocation_ratio*]
#   (optional) Virtual CPU to Physical CPU allocation ratio
#   Defaults to undef
#
# [*ram_allocation_ratio*]
#   (optional) Virtual ram to physical ram allocation ratio
#   Defaults to undef
#
# [*disk_allocation_ratio*]
#   (optional) Virtual disk to physical disk allocation ratio
#   Defaults to undef
#
class nova::scheduler::filter (
  $scheduler_host_manager              = 'host_manager',
  $scheduler_max_attempts              = '3',
  $scheduler_host_subset_size          = '1',
  $max_io_ops_per_host                 = '8',
  $max_instances_per_host              = '50',
  $isolated_images                     = $::os_service_default,
  $isolated_hosts                      = $::os_service_default,
  $scheduler_available_filters         = ['nova.scheduler.filters.all_filters'],
  $scheduler_default_filters           = $::os_service_default,
  $scheduler_weight_classes            = 'nova.scheduler.weights.all_weighers',
  $baremetal_scheduler_default_filters = $::os_service_default,
  $scheduler_use_baremetal_filters     = false,
  # DEPRECATED PARAMETERS
  $cpu_allocation_ratio                = undef,
  $ram_allocation_ratio                = undef,
  $disk_allocation_ratio               = undef,
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
    $scheduler_available_filters_real = $scheduler_available_filters
  } else {
    warning('scheduler_available_filters must be an array and will fail in the future')
    $scheduler_available_filters_real = any2array($scheduler_available_filters)
  }

  if !is_service_default($baremetal_scheduler_default_filters) and !empty($baremetal_scheduler_default_filters){
    validate_array($baremetal_scheduler_default_filters)
    $baremetal_scheduler_default_filters_real = join($baremetal_scheduler_default_filters, ',')
  } else {
    $baremetal_scheduler_default_filters_real = $::os_service_default
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

  if $cpu_allocation_ratio {
    warning('cpu_allocation_ratio is deprecated in nova::scheduler::filter, please add to nova::init instead')
  }

  if $ram_allocation_ratio {
    warning('ram_allocation_ratio is deprecated in nova::scheduler::filter, please add to nova::init instead')
  }

  if $disk_allocation_ratio {
    warning('disk_allocation_ratio is deprecated in nova::scheduler::filter, please add to nova::init instead')
  }

  nova_config {
    'DEFAULT/scheduler_host_manager':              value => $scheduler_host_manager;
    'DEFAULT/scheduler_max_attempts':              value => $scheduler_max_attempts;
    'DEFAULT/scheduler_host_subset_size':          value => $scheduler_host_subset_size;
    'DEFAULT/max_io_ops_per_host':                 value => $max_io_ops_per_host;
    'DEFAULT/max_instances_per_host':              value => $max_instances_per_host;
    'DEFAULT/scheduler_available_filters':         value => $scheduler_available_filters_real;
    'DEFAULT/scheduler_weight_classes':            value => $scheduler_weight_classes;
    'DEFAULT/scheduler_use_baremetal_filters':     value => $scheduler_use_baremetal_filters;
    'DEFAULT/scheduler_default_filters':           value => $scheduler_default_filters_real;
    'DEFAULT/baremetal_scheduler_default_filters': value => $baremetal_scheduler_default_filters_real;
    'DEFAULT/isolated_images':                     value => $isolated_images_real;
    'DEFAULT/isolated_hosts':                      value => $isolated_hosts_real;
  }

}
