#
# Copyright 2021 Thomas Goirand <zigo@debian.org>
#
# Author: Thomas Goirand <zigo@debian.org>
#
# == Class: nova::wsgi::uwsgi_api_metadata
#
# Configure the UWSGI service for Nova API Metadata.
#
# == Parameters
#
# [*processes*]
#   (Optional) Number of processes.
#   Defaults to $facts['os_workers'].
#
# [*threads*]
#   (Optional) Number of threads.
#   Defaults to 32.
#
# [*listen_queue_size*]
#   (Optional) Socket listen queue size.
#   Defaults to 100
#
class nova::wsgi::uwsgi_api_metadata (
  $processes         = $facts['os_workers'],
  $threads           = 1,
  $listen_queue_size = 100,
) {
  include nova::deps

  if $facts['os']['name'] != 'Debian' {
    warning('This class is only valid for Debian, as other operating systems are not using uwsgi by default.')
  }

  if $threads != 1 {
    warning('The nova API currently does not support anything else than threads=1.')
  }

  nova_api_metadata_uwsgi_config {
    'uwsgi/processes': value => $processes;
    'uwsgi/threads':   value => $threads;
    'uwsgi/listen':    value => $listen_queue_size;
  }
}
