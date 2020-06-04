# == Class: nova::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
class nova::params {
  include openstacklib::defaults
  $pyvers = $::openstacklib::defaults::pyvers
  $client_package = "python${pyvers}-novaclient"
  $group          = 'nova'

  case $::osfamily {
    'RedHat': {
      # package names
      $api_package_name                  = 'openstack-nova-api'
      $common_package_name               = 'openstack-nova-common'
      $python_package_name               = "python${pyvers}-nova"
      $compute_package_name              = 'openstack-nova-compute'
      $conductor_package_name            = 'openstack-nova-conductor'
      $novajoin_package_name             = "python${pyvers}-novajoin"
      $doc_package_name                  = 'openstack-nova-doc'
      $libvirt_package_name              = 'libvirt'
      $libvirt_guests_package_name       = 'libvirt-client'
      $libvirt_daemon_package_prefix     = 'libvirt-daemon-'
      $libvirt_nwfilter_package_name     = 'libvirt-daemon-config-nwfilter'
      $scheduler_package_name            = 'openstack-nova-scheduler'
      $tgt_package_name                  = 'scsi-target-utils'
      $vncproxy_package_name             = 'openstack-nova-novncproxy'
      $serialproxy_package_name          = 'openstack-nova-serialproxy'
      $spicehtml5proxy_package_name      = 'openstack-nova-console'
      $ceph_client_package_name          = 'ceph-common'
      $genisoimage_package_name          = 'genisoimage'
      # service names
      $api_service_name                  = 'openstack-nova-api'
      $api_metadata_service_name         = undef
      $compute_service_name              = 'openstack-nova-compute'
      $conductor_service_name            = 'openstack-nova-conductor'
      $libvirt_service_name              = 'libvirtd'
      $libvirt_guests_service_name       = 'libvirt-guests'
      $virtlock_service_name             = 'virtlockd'
      $virtlog_service_name              = undef
      $scheduler_service_name            = 'openstack-nova-scheduler'
      $tgt_service_name                  = 'tgtd'
      $novajoin_service_name             = 'novajoin-server'
      $notify_service_name               = 'novajoin-notify'
      $vncproxy_service_name             = 'openstack-nova-novncproxy'
      $serialproxy_service_name          = 'openstack-nova-serialproxy'
      $spicehtml5proxy_service_name      = 'openstack-nova-spicehtml5proxy'
      # redhat specific config defaults
      $root_helper                       = 'sudo nova-rootwrap'
      $lock_path                         = '/var/lib/nova/tmp'
      $nova_wsgi_script_path             = '/var/www/cgi-bin/nova'
      $nova_api_wsgi_script_source       = '/usr/bin/nova-api-wsgi'
      $nova_metadata_wsgi_script_source  = '/usr/bin/nova-metadata-wsgi'
      case $::operatingsystem {
        'Fedora': {
          $messagebus_service_name  = undef
        }
        default: {
          $messagebus_service_name  = 'dbus'
        }
      }
      $nova_user                    = 'nova'
      $nova_group                   = 'nova'
    }
    'Debian': {
      # package names
      $api_package_name                  = 'nova-api'
      $common_package_name               = 'nova-common'
      $python_package_name               = "python${pyvers}-nova"
      $compute_package_name              = 'nova-compute'
      $conductor_package_name            = 'nova-conductor'
      $novajoin_package_name             = undef
      $doc_package_name                  = 'nova-doc'
      if ($::operatingsystem == 'Debian') and (versioncmp($::operatingsystemmajrelease, '9') >= 0 ) {
        $libvirt_package_name            = 'libvirt-daemon-system'
      } else {
        $libvirt_package_name            = 'libvirt-bin'
      }
      $scheduler_package_name            = 'nova-scheduler'
      $tgt_package_name                  = 'tgt'
      $ceph_client_package_name          = 'ceph'
      $genisoimage_package_name          = 'genisoimage'
      # service names
      $api_service_name                  = 'nova-api'
      $compute_service_name              = 'nova-compute'
      $conductor_service_name            = 'nova-conductor'
      $scheduler_service_name            = 'nova-scheduler'
      $vncproxy_service_name             = 'nova-novncproxy'
      $serialproxy_service_name          = 'nova-serialproxy'
      $tgt_service_name                  = 'tgt'
      $novajoin_service_name             = undef
      $notify_service_name               = undef
      $nova_wsgi_script_path             = '/usr/lib/cgi-bin/nova'
      $nova_api_wsgi_script_source       = '/usr/bin/nova-api-wsgi'
      $nova_metadata_wsgi_script_source  = '/usr/bin/nova-metadata-wsgi'
      # debian specific nova config
      $root_helper                       = 'sudo nova-rootwrap'
      $lock_path                         = '/var/lock/nova'
      case $::os_package_type {
        'debian': {
          $api_metadata_service_name       = 'nova-api-metadata'
          $spicehtml5proxy_package_name    = 'nova-consoleproxy'
          $spicehtml5proxy_service_name    = 'nova-spicehtml5proxy'
          $vncproxy_package_name           = 'nova-consoleproxy'
          $serialproxy_package_name        = 'nova-consoleproxy'
          # Use default provider on Debian
          $virtlock_service_name           = 'virtlockd'
          $virtlog_service_name            = 'virtlogd'
        }
        default: {
          $api_metadata_service_name       = undef
          $spicehtml5proxy_package_name    = 'nova-spiceproxy'
          $spicehtml5proxy_service_name    = 'nova-spiceproxy'
          $vncproxy_package_name           = 'nova-novncproxy'
          $serialproxy_package_name        = 'nova-serialproxy'
          # Use default provider on Debian
          $virtlock_service_name           = 'virtlockd'
          $virtlog_service_name            = 'virtlogd'
        }
      }
      $libvirt_service_name            = 'libvirtd'
      $nova_user                       = 'nova'
      $nova_group                      = 'nova'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
