# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# == Define: nova::compute::libvirt::secret_ceph
#
# Configure a libvirt secret with ceph type.
#
# === Parameters
#
# [*uuid*]
# (Required) The UUID of the libvirt secret.
#
# [*value*]
# (Required) The value to store in the secret. It should be base64-encoded.
#
# [*secret_name*]
# (Optional) The name of the libvirt secret.
# Defaults to $name
#
# [*secret_path*]
# (Optional) Directory to store files related to secrets.
# Defaults to /etc/nova
#
define nova::compute::libvirt::secret_ceph(
  Pattern[/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$/] $uuid,
  Stdlib::Base64 $value,
  String[1] $secret_name            = $name,
  Stdlib::Absolutepath $secret_path = '/etc/nova',
) {

  $xml_file = "${secret_path}/libvirt-secret-${uuid}.xml"
  file { $xml_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => epp('nova/libvirt-secret-ceph.xml.epp', {
      'secret_name' => $secret_name,
      'uuid'        => $uuid,
    }),
    require => Anchor['nova::config::begin'],
  }

  $secret_file = "${secret_path}/libvirt-secret-${uuid}.secret"
  file { $secret_file:
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    content   => $value,
    show_diff => false,
    require   => Anchor['nova::config::begin'],
  }

  exec { "get-or-set virsh secret ${uuid}":
    command => [
      '/usr/bin/virsh', 'secret-define', '--file', $xml_file,
    ],
    unless  => "/usr/bin/virsh secret-list | grep -i ${uuid}",
    require => File[$xml_file],
  }
  Service<| tag == 'libvirt-service' |> -> Exec["get-or-set virsh secret ${uuid}"]

  exec { "set-secret-value virsh secret ${uuid}":
    command   => [
      '/usr/bin/virsh', 'secret-set-value', '--secret', $uuid,
      '--file', $secret_file,
    ],
    unless    => "/usr/bin/virsh secret-get-value ${uuid} | grep -f ${secret_file}",
    logoutput => false,
    require   => [
      File[$secret_file],
      Exec["get-or-set virsh secret ${uuid}"],
    ],
  }
}
