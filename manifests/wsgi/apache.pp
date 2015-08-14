#
# Copyright (C) 2015 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
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
#
# Class to serve Nova API and EC2 with apache mod_wsgi in place of nova-api and nova-api-ec2 services.
#
# Serving Nova API and Nova API EC2 from apache is the recommended way to go for production
# because of limited performance for concurrent accesses.
#
# When using this class you should disable your nova-api and nova-api-ec2 service.
#
# == Parameters
#
#   [*servername*]
#     The servername for the virtualhost.
#     Optional. Defaults to $::fqdn
#
#   [*api_port*]
#     The port for Nova API service.
#     Optional. Defaults to 8774
#
#   [*bind_host*]
#     The host/ip address Apache will listen on.
#     Optional. Defaults to undef (listen on all ip addresses).
#
#   [*path*]
#     The prefix for the endpoint.
#     Optional. Defaults to '/'
#
#   [*ssl*]
#     Use ssl ? (boolean)
#     Optional. Defaults to true
#
#   [*workers*]
#     Number of WSGI workers to spawn.
#     Optional. Defaults to 1
#
#   [*priority*]
#     (optional) The priority for the vhost.
#     Defaults to '10'
#
#   [*threads*]
#     (optional) The number of threads for the vhost.
#     Defaults to $::processorcount
#
#   [*ssl_cert*]
#   [*ssl_key*]
#   [*ssl_chain*]
#   [*ssl_ca*]
#   [*ssl_crl_path*]
#   [*ssl_crl*]
#   [*ssl_certs_dir*]
#     apache::vhost ssl parameters.
#     Optional. Default to apache::vhost 'ssl_*' defaults.
#
# == Dependencies
#
#   requires Class['apache'] & Class['nova'] & Class['nova::api']
#
# == Examples
#
#   include apache
#
#   class { 'nova::wsgi::apache': }
#
class nova::wsgi::apache (
  $servername    = $::fqdn,
  $api_port      = 8774,
  $bind_host     = undef,
  $path          = '/',
  $ssl           = true,
  $workers       = 1,
  $ssl_cert      = undef,
  $ssl_key       = undef,
  $ssl_chain     = undef,
  $ssl_ca        = undef,
  $ssl_crl_path  = undef,
  $ssl_crl       = undef,
  $ssl_certs_dir = undef,
  $threads       = $::processorcount,
  $priority      = '10',
) {

  include ::nova::params
  include ::apache
  include ::apache::mod::wsgi
  if $ssl {
    include ::apache::mod::ssl
  }

  if ! defined(Class[::nova::api]) {
    fail('::nova::api class must be declared in composition layer.')
  }

  ::openstacklib::wsgi::apache { 'nova_api_wsgi':
    bind_host           => $bind_host,
    bind_port           => $api_port,
    group               => 'nova',
    path                => $path,
    priority            => $priority,
    servername          => $servername,
    ssl                 => $ssl,
    ssl_ca              => $ssl_ca,
    ssl_cert            => $ssl_cert,
    ssl_certs_dir       => $ssl_certs_dir,
    ssl_chain           => $ssl_chain,
    ssl_crl             => $ssl_crl,
    ssl_crl_path        => $ssl_crl_path,
    ssl_key             => $ssl_key,
    threads             => $threads,
    user                => 'nova',
    workers             => $workers,
    wsgi_daemon_process => 'nova-api',
    wsgi_process_group  => 'nova-api',
    wsgi_script_dir     => $::nova::params::nova_wsgi_script_path,
    wsgi_script_file    => 'nova-api',
    wsgi_script_source  => $::nova::params::nova_api_wsgi_script_source,
  }

}
