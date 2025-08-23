# == Class: nova::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
class nova::params {
  include openstacklib::defaults

  $client_package = 'python3-novaclient'
  $user           = 'nova'
  $group          = 'nova'

  # NOTE(tkajinam) These are kept for backward compatibility
  $nova_user      = $user
  $nova_group     = $group

  case $facts['os']['family'] {
    'RedHat': {
      # package names
      $api_package_name                  = 'openstack-nova-api'
      $common_package_name               = 'openstack-nova-common'
      $python_package_name               = 'python3-nova'
      $compute_package_name              = 'openstack-nova-compute'
      $conductor_package_name            = 'openstack-nova-conductor'
      $doc_package_name                  = 'openstack-nova-doc'
      $libvirt_package_name              = 'libvirt'
      $libvirt_client_package_name       = 'libvirt-client'
      $libvirt_daemon_package_name       = 'libvirt-daemon'
      $libvirt_daemon_package_prefix     = 'libvirt-daemon-'
      $scheduler_package_name            = 'openstack-nova-scheduler'
      $vncproxy_package_name             = 'openstack-nova-novncproxy'
      $serialproxy_package_name          = 'openstack-nova-serialproxy'
      $spicehtml5proxy_package_name      = 'openstack-nova-console'
      $ceph_common_package_name          = 'ceph-common'
      $ovmf_package_name                 = 'edk2-ovmf'
      $swtpm_package_name                = 'swtpm'
      # service names
      $api_service_name                  = 'openstack-nova-api'
      $api_metadata_service_name         = undef
      $compute_service_name              = 'openstack-nova-compute'
      $conductor_service_name            = 'openstack-nova-conductor'
      $libvirt_service_name              = 'libvirtd'
      $libvirt_guests_service_name       = 'libvirt-guests'
      $virtlock_service_name             = 'virtlockd'
      $virtlock_package_name             = undef
      $virtlog_service_name              = 'virtlogd'
      $virtsecret_service_name           = 'virtsecretd'
      $virtnodedev_service_name          = 'virtnodedevd'
      $virtqemu_service_name             = 'virtqemud'
      $virtproxy_service_name            = 'virtproxyd'
      $virtstorage_service_name          = 'virtstoraged'
      $virtsecret_socket_name            = 'virtsecretd.socket'
      $virtnodedev_socket_name           = 'virtnodedevd.socket'
      $virtqemu_socket_name              = 'virtqemud.socket'
      $virtproxy_socket_name             = 'virtproxyd.socket'
      $virtstorage_socket_name           = 'virtstoraged.socket'
      $scheduler_service_name            = 'openstack-nova-scheduler'
      $vncproxy_service_name             = 'openstack-nova-novncproxy'
      $serialproxy_service_name          = 'openstack-nova-serialproxy'
      $spicehtml5proxy_service_name      = 'openstack-nova-spicehtml5proxy'
      $modular_libvirt                   = true
      $modular_libvirt_support           = true
      $libvirt_guests_environment_file   = '/etc/sysconfig/libvirt-guests'
      # redhat specific config defaults
      $lock_path                         = '/var/lib/nova/tmp'
      $nova_wsgi_script_path             = '/var/www/cgi-bin/nova'
      $nova_api_wsgi_script_source       = '/usr/bin/nova-api-wsgi'
      $nova_metadata_wsgi_script_source  = '/usr/bin/nova-metadata-wsgi'
    }
    'Debian': {
      # package names
      $api_package_name                  = 'nova-api'
      $common_package_name               = 'nova-common'
      $python_package_name               = 'python3-nova'
      $compute_package_name              = 'nova-compute'
      $conductor_package_name            = 'nova-conductor'
      $doc_package_name                  = 'nova-doc'
      $libvirt_package_name              = 'libvirt-daemon-system'
      $libvirt_client_package_name       = 'libvirt-clients'
      $scheduler_package_name            = 'nova-scheduler'
      $ceph_common_package_name          = 'ceph-common'
      $ovmf_package_name                 = 'ovmf'
      $swtpm_package_name                = 'swtpm'
      # service names
      $api_service_name                  = 'nova-api'
      $compute_service_name              = 'nova-compute'
      $conductor_service_name            = 'nova-conductor'
      $libvirt_service_name              = 'libvirtd'
      $libvirt_guests_service_name       = 'libvirt-guests'
      $virtlock_service_name             = 'virtlockd'
      $virtlog_service_name              = 'virtlogd'
      $virtsecret_service_name           = undef
      $virtnodedev_service_name          = undef
      $virtqemu_service_name             = undef
      $virtproxy_service_name            = undef
      $virtstorage_service_name          = undef
      $virtsecret_socket_name            = undef
      $virtnodedev_socket_name           = undef
      $virtqemu_socket_name              = undef
      $virtproxy_socket_name             = undef
      $virtstorage_socket_name           = undef
      $modular_libvirt                   = false
      $modular_libvirt_support           = false
      $libvirt_guests_environment_file   = '/etc/default/libvirt-guests'
      $scheduler_service_name            = 'nova-scheduler'
      $vncproxy_service_name             = 'nova-novncproxy'
      $serialproxy_service_name          = 'nova-serialproxy'
      $nova_wsgi_script_path             = '/usr/lib/cgi-bin/nova'
      $nova_api_wsgi_script_source       = '/usr/bin/nova-api-wsgi'
      $nova_metadata_wsgi_script_source  = '/usr/bin/nova-metadata-wsgi'
      # debian specific nova config
      $lock_path                         = '/var/lock/nova'
      case $facts['os']['name'] {
        'Debian': {
          $api_metadata_service_name    = 'nova-api-metadata'
          $spicehtml5proxy_package_name = 'nova-consoleproxy'
          $spicehtml5proxy_service_name = 'nova-spicehtml5proxy'
          $vncproxy_package_name        = 'nova-consoleproxy'
          $serialproxy_package_name     = 'nova-consoleproxy'
          # Starting with Debian 13, virtlockd lives in a separate plugin package.
          if Integer.new($facts['os']['release']['major']) >= 13 {
            $virtlock_package_name      = 'libvirt-daemon-plugin-lockd'
          } else {
            $virtlock_package_name      = undef
          }
          # Use default provider on Debian
        }
        default: {
          $api_metadata_service_name    = undef
          $spicehtml5proxy_package_name = 'nova-spiceproxy'
          $spicehtml5proxy_service_name = 'nova-spiceproxy'
          $vncproxy_package_name        = 'nova-novncproxy'
          $serialproxy_package_name     = 'nova-serialproxy'
          # Starting with Ubuntu 25.10, virtlockd lives in a separate plugin package.
          # We will need to fix this for Ubuntu 26.04 LTS.
          $virtlock_package_name        = undef
        }
      }
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }
  }
}
