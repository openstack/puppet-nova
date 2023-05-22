# == Class: nova::compute::image_cache
#
# Configures image caching in nova
#
# === Parameters:
#
# [*manager_interval*]
#  (optional) Number of seconds to wait between runs of the image cache manager.
#  Defaults to $::os_service_default
#
# [*subdirectory_name*]
#  (optional) Location of cached images.
#  Defaults to $::os_service_default
#
# [*remove_unused_base_images*]
#  (optional) Should unused base images be removed?
#  Defaults to $::os_service_default
#
# [*remove_unused_original_minimum_age_seconds*]
#  (optional) Unused unresized base images younger than this will not be removed.
#  Defaults to $::os_service_default
#
# [*remove_unused_resized_minimum_age_seconds*]
#  (optional) Unused resized base images younger than this will not be removed.
#  Defaults to $::os_service_default
#
# [*precache_concurrency*]
#  (optional) Maximum number of compute hosts to trigger image precaching
#  in parallel.
#  Defaults to $::os_service_default
#
class nova::compute::image_cache (
  $manager_interval                           = $::os_service_default,
  $subdirectory_name                          = $::os_service_default,
  $remove_unused_base_images                  = $::os_service_default,
  $remove_unused_original_minimum_age_seconds = $::os_service_default,
  $remove_unused_resized_minimum_age_seconds  = $::os_service_default,
  $precache_concurrency                       = $::os_service_default
) {

  include nova::deps

  nova_config {
    'image_cache/manager_interval':                           value => $manager_interval;
    'image_cache/subdirectory_name':                          value => $subdirectory_name;
    'image_cache/remove_unused_base_images':                  value => $remove_unused_base_images;
    'image_cache/remove_unused_original_minimum_age_seconds': value => $remove_unused_original_minimum_age_seconds;
    'image_cache/remove_unused_resized_minimum_age_seconds':  value => $remove_unused_resized_minimum_age_seconds;
    'image_cache/precache_concurrency':                       value => $precache_concurrency;
  }
}
