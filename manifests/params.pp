# == Class: nova::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
class nova::params {
  include ::openstacklib::defaults
  $group = 'nova'
  if ($::os_package_type == 'debian') {
    $pyvers = '3'
  } else {
    $pyvers = ''
  }
  case $::osfamily {
    'RedHat': {
      # package names
      $client_package                = 'python-novaclient'
      $api_package_name              = 'openstack-nova-api'
      $placement_package_name        = 'openstack-nova-placement-api'
      $cells_package_name            = 'openstack-nova-cells'
      $common_package_name           = 'openstack-nova-common'
      $python_package_name           = 'python-nova'
      $compute_package_name          = 'openstack-nova-compute'
      $conductor_package_name        = 'openstack-nova-conductor'
      $consoleauth_package_name      = 'openstack-nova-console'
      $doc_package_name              = 'openstack-nova-doc'
      $libvirt_package_name          = 'libvirt'
      $libvirt_daemon_package_prefix = 'libvirt-daemon-'
      $libvirt_nwfilter_package_name = 'libvirt-daemon-config-nwfilter'
      $network_package_name          = 'openstack-nova-network'
      $scheduler_package_name        = 'openstack-nova-scheduler'
      $tgt_package_name              = 'scsi-target-utils'
      $vncproxy_package_name         = 'openstack-nova-novncproxy'
      $serialproxy_package_name      = 'openstack-nova-serialproxy'
      $spicehtml5proxy_package_name  = 'openstack-nova-console'
      $ceph_client_package_name      = 'ceph-common'
      $genisoimage_package_name      = 'genisoimage'
      # service names
      $api_service_name              = 'openstack-nova-api'
      $cells_service_name            = 'openstack-nova-cells'
      $compute_service_name          = 'openstack-nova-compute'
      $conductor_service_name        = 'openstack-nova-conductor'
      $consoleauth_service_name      = 'openstack-nova-consoleauth'
      $placement_service_name        = 'httpd'
      $libvirt_service_name          = 'libvirtd'
      $virtlock_service_name         = 'virtlockd'
      $virtlog_service_name          = undef
      $network_service_name          = 'openstack-nova-network'
      $scheduler_service_name        = 'openstack-nova-scheduler'
      $tgt_service_name              = 'tgtd'
      $vncproxy_service_name         = 'openstack-nova-novncproxy'
      $serialproxy_service_name      = 'openstack-nova-serialproxy'
      $spicehtml5proxy_service_name  = 'openstack-nova-spicehtml5proxy'
      # redhat specific config defaults
      $root_helper                   = 'sudo nova-rootwrap'
      $lock_path                     = '/var/lib/nova/tmp'
      $nova_log_group                = 'root'
      $nova_wsgi_script_path         = '/var/www/cgi-bin/nova'
      $nova_api_wsgi_script_source   = '/usr/bin/nova-api-wsgi'
      $placement_public_url          = 'http://127.0.0.1/placement'
      $placement_internal_url        = 'http://127.0.0.1/placement'
      $placement_admin_url           = 'http://127.0.0.1/placement'
      $placement_wsgi_script_source  = '/usr/bin/nova-placement-api'
      $placement_httpd_config_file   = '/etc/httpd/conf.d/00-nova-placement-api.conf'
      case $::operatingsystem {
        'RedHat', 'CentOS', 'Scientific', 'OracleLinux': {
          if (versioncmp($::operatingsystemmajrelease, '7') < 0) {
            $messagebus_service_name  = 'messagebus'
            $special_service_provider = undef
          } else {
            if (versioncmp($::puppetversion, '4.5') < 0) {
              $special_service_provider = 'redhat'
            } else {
              $special_service_provider = undef
            }
            $messagebus_service_name = 'dbus'
          }
        }
        default: {
          # not required on Fedora
          $special_service_provider = undef
          $messagebus_service_name  = undef
        }
      }
      $nova_user                    = 'nova'
      $nova_group                   = 'nova'
    }
    'Debian': {
      # package names
      $client_package               = "python${pyvers}-novaclient"
      $api_package_name             = 'nova-api'
      $placement_package_name       = 'nova-placement-api'
      $cells_package_name           = 'nova-cells'
      $common_package_name          = 'nova-common'
      $python_package_name          = "python${pyvers}-nova"
      $compute_package_name         = 'nova-compute'
      $conductor_package_name       = 'nova-conductor'
      $consoleauth_package_name     = 'nova-consoleauth'
      $doc_package_name             = 'nova-doc'
      if ($::operatingsystem == 'Debian') and (versioncmp($::operatingsystemmajrelease, '9') >= 0 ) {
        $libvirt_package_name         = 'libvirt-daemon-system'
      } else {
        $libvirt_package_name         = 'libvirt-bin'
      }
      $network_package_name         = 'nova-network'
      $scheduler_package_name       = 'nova-scheduler'
      $tgt_package_name             = 'tgt'
      $serialproxy_package_name     = 'nova-serialproxy'
      $ceph_client_package_name     = 'ceph'
      $genisoimage_package_name     = 'genisoimage'
      # service names
      $api_service_name             = 'nova-api'
      $cells_service_name           = 'nova-cells'
      $compute_service_name         = 'nova-compute'
      $conductor_service_name       = 'nova-conductor'
      $consoleauth_service_name     = 'nova-consoleauth'
      $network_service_name         = 'nova-network'
      $scheduler_service_name       = 'nova-scheduler'
      $vncproxy_service_name        = 'nova-novncproxy'
      $serialproxy_service_name     = 'nova-serialproxy'
      $tgt_service_name             = 'tgt'
      $nova_log_group               = 'adm'
      $nova_wsgi_script_path        = '/usr/lib/cgi-bin/nova'
      $nova_api_wsgi_script_source  = '/usr/bin/nova-api-wsgi'
      $placement_wsgi_script_source = '/usr/bin/nova-placement-api'
      $placement_httpd_config_file  = '/etc/apache2/sites-available/nova-placement-api.conf'
      # debian specific nova config
      $root_helper                  = 'sudo nova-rootwrap'
      $lock_path                    = '/var/lock/nova'
      case $::os_package_type {
        'debian': {
          $spicehtml5proxy_package_name    = 'nova-consoleproxy'
          $spicehtml5proxy_service_name    = 'nova-spicehtml5proxy'
          $vncproxy_package_name           = 'nova-consoleproxy'
          # Use default provider on Debian
          $special_service_provider        = undef
          $virtlock_service_name           = undef
          $virtlog_service_name            = undef
          $placement_service_name          = 'nova-placement-api'
          $placement_public_url            = 'http://127.0.0.1'
          $placement_internal_url          = 'http://127.0.0.1'
          $placement_admin_url             = 'http://127.0.0.1'
        }
        default: {
          $spicehtml5proxy_package_name    = 'nova-spiceproxy'
          $spicehtml5proxy_service_name    = 'nova-spiceproxy'
          $vncproxy_package_name           = 'nova-novncproxy'
          # Use default provider on Debian
          $special_service_provider        = undef
          $virtlock_service_name           = 'virtlockd'
          $virtlog_service_name            = 'virtlogd'
          $placement_service_name          = 'httpd'
          $placement_public_url            = 'http://127.0.0.1/placement'
          $placement_internal_url          = 'http://127.0.0.1/placement'
          $placement_admin_url             = 'http://127.0.0.1/placement'
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
