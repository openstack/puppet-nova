# == Class: nova::rabbitmq
#
# Installs and manages rabbitmq server for nova
#
# == Parameters:
#
# [*userid*]
#   (optional) The username to use when connecting to Rabbit
#   Defaults to 'guest'
#
# [*password*]
#   (optional) The password to use when connecting to Rabbit
#   Defaults to 'guest'
#
# [*port*]
#   (optional) Deprecated. The port to use when connecting to Rabbit
#   This parameter keeps backward compatibility when we used to manage
#   RabbitMQ service.
#   Defaults to '5672'
#
# [*virtual_host*]
#   (optional) The virtual host to use when connecting to Rabbit
#   Defaults to '/'
#
# [*cluster_disk_nodes*]
#   (optional) Enables/disables RabbitMQ clustering.  Specify an array of Rabbit Broker
#   IP addresses to configure clustering.
#   Defaults to false
#
# [*enabled*]
#   (optional) Deprecated. Whether to enable the Rabbit resources
#   This parameter keeps backward compatibility when we used to manage
#   RabbitMQ service.
#   Defaults to true
#
class nova::rabbitmq(
  $userid             ='guest',
  $password           ='guest',
  $virtual_host       ='/',
  # DEPRECATED PARAMETER
  $cluster_disk_nodes = false,
  $enabled            = true,
  $port               ='5672',
) {

  warning('nova::rabbitmq class is deprecated and will be removed in next release. Make other plans to configure rabbitmq resources.')

  include ::nova::deps

  if ($enabled) {
    if $userid == 'guest' {
      $delete_guest_user = false
    } else {
      $delete_guest_user = true
      rabbitmq_user { $userid:
        admin    => true,
        password => $password,
        provider => 'rabbitmqctl',
      }
      # I need to figure out the appropriate permissions
      rabbitmq_user_permissions { "${userid}@${virtual_host}":
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
      }
    }
    rabbitmq_vhost { $virtual_host:
      provider => 'rabbitmqctl',
    }
  }

  # Only start Nova after the queue is up
  Class['nova::rabbitmq'] -> Anchor['nova::service::end']
}
