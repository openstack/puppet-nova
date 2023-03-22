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

  case $::osfamily {
    'RedHat': {
      # package names
      $api_package_name                  = 'openstack-nova-api'
      $common_package_name               = 'openstack-nova-common'
      $python_package_name               = 'python3-nova'
      $compute_package_name              = 'openstack-nova-compute'
      $conductor_package_name            = 'openstack-nova-conductor'
      $doc_package_name                  = 'openstack-nova-doc'
      $libvirt_package_name              = 'libvirt'
      $libvirt_guests_package_name       = 'libvirt-client'
      $libvirt_daemon_package_name       = 'libvirt-daemon'
      $libvirt_daemon_package_prefix     = 'libvirt-daemon-'
      $libvirt_nwfilter_package_name     = 'libvirt-daemon-config-nwfilter'
      $scheduler_package_name            = 'openstack-nova-scheduler'
      $tgt_package_name                  = 'scsi-target-utils'
      $vncproxy_package_name             = 'openstack-nova-novncproxy'
      $serialproxy_package_name          = 'openstack-nova-serialproxy'
      $spicehtml5proxy_package_name      = 'openstack-nova-console'
      $ceph_client_package_name          = 'ceph-common'
      # service names
      $api_service_name                  = 'openstack-nova-api'
      $api_metadata_service_name         = undef
      $compute_service_name              = 'openstack-nova-compute'
      $conductor_service_name            = 'openstack-nova-conductor'
      $libvirt_service_name              = 'libvirtd'
      $libvirt_guests_service_name       = 'libvirt-guests'
      $virtlock_service_name             = 'virtlockd'
      $virtlog_service_name              = 'virtlogd'
      $virtsecret_service_name           = 'virtsecretd.socket'
      $virtnodedev_service_name          = 'virtnodedevd.socket'
      $virtqemu_service_name             = 'virtqemud.socket'
      $virtproxy_service_name            = 'virtproxyd.socket'
      $virtstorage_service_name          = 'virtstoraged.socket'
      $scheduler_service_name            = 'openstack-nova-scheduler'
      $tgt_service_name                  = 'tgtd'
      $vncproxy_service_name             = 'openstack-nova-novncproxy'
      $serialproxy_service_name          = 'openstack-nova-serialproxy'
      $spicehtml5proxy_service_name      = 'openstack-nova-spicehtml5proxy'
      $modular_libvirt                   = false
      # redhat specific config defaults
      $root_helper                       = 'sudo nova-rootwrap'
      $lock_path                         = '/var/lib/nova/tmp'
      $nova_wsgi_script_path             = '/var/www/cgi-bin/nova'
      $nova_api_wsgi_script_source       = '/usr/bin/nova-api-wsgi'
      $nova_metadata_wsgi_script_source  = '/usr/bin/nova-metadata-wsgi'
      $messagebus_service_name           = 'dbus'
      if versioncmp($::operatingsystemmajrelease, '9') >= 0 {
        $mkisofs_package_name            = 'xorriso'
        $mkisofs_cmd                     = 'mkisofs'
      } else {
        $mkisofs_package_name            = 'genisoimage'
        $mkisofs_cmd                     = false
      }
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
      $scheduler_package_name            = 'nova-scheduler'
      $tgt_package_name                  = 'tgt'
      $ceph_client_package_name          = 'ceph-common'
      $mkisofs_package_name              = 'genisoimage'
      $mkisofs_cmd                       = false
      # service names
      $api_service_name                  = 'nova-api'
      $compute_service_name              = 'nova-compute'
      $conductor_service_name            = 'nova-conductor'
      $scheduler_service_name            = 'nova-scheduler'
      $vncproxy_service_name             = 'nova-novncproxy'
      $serialproxy_service_name          = 'nova-serialproxy'
      $tgt_service_name                  = 'tgt'
      $nova_wsgi_script_path             = '/usr/lib/cgi-bin/nova'
      $nova_api_wsgi_script_source       = '/usr/bin/nova-api-wsgi'
      $nova_metadata_wsgi_script_source  = '/usr/bin/nova-metadata-wsgi'
      # debian specific nova config
      $root_helper                       = 'sudo nova-rootwrap'
      $lock_path                         = '/var/lock/nova'
      case $::operatingsystem {
        'Debian': {
          $api_metadata_service_name    = 'nova-api-metadata'
          $spicehtml5proxy_package_name = 'nova-consoleproxy'
          $spicehtml5proxy_service_name = 'nova-spicehtml5proxy'
          $vncproxy_package_name        = 'nova-consoleproxy'
          $serialproxy_package_name     = 'nova-consoleproxy'
          # Use default provider on Debian
          $virtlock_service_name        = 'virtlockd'
          $virtlog_service_name         = 'virtlogd'
          $virtsecret_service_name      = 'virtsecretd.socket'
          $virtnodedev_service_name     = 'virtnodedevd.socket'
          $virtqemu_service_name        = 'virtqemud.socket'
          $virtproxy_service_name       = 'virtproxyd.socket'
          $virtstorage_service_name     = 'virtstoraged.socket'
          $modular_libvirt              = false
        }
        default: {
          $api_metadata_service_name    = undef
          $spicehtml5proxy_package_name = 'nova-spiceproxy'
          $spicehtml5proxy_service_name = 'nova-spiceproxy'
          $vncproxy_package_name        = 'nova-novncproxy'
          $serialproxy_package_name     = 'nova-serialproxy'
          # Use default provider on Debian
          $virtlock_service_name        = 'virtlockd'
          $virtlog_service_name         = 'virtlogd'
          $virtsecret_service_name      = 'virtsecretd'
          $virtnodedev_service_name     = 'virtnodedevd'
          $virtqemu_service_name        = 'virtqemud'
          $virtproxy_service_name       = 'virtproxyd'
          $virtstorage_service_name     = 'virtstoraged'
          $modular_libvirt              = false
        }
      }
      $libvirt_service_name            = 'libvirtd'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
