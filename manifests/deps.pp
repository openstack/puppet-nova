# == Class: nova::deps
#
#  Nova anchors and dependency management
#
class nova::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'nova::install::begin': }
  -> Package<| tag == 'nova-package'|>
  ~> anchor { 'nova::install::end': }
  -> anchor { 'nova::config::begin': }
  -> Nova_config<||>
  ~> anchor { 'nova::config::end': }
  -> anchor { 'nova::db::begin': }
  -> anchor { 'nova::db::end': }
  ~> anchor { 'nova::service::begin': }
  ~> Service<| tag == 'nova-service' |>
  ~> anchor { 'nova::service::end': }

  # paste-api.ini config should occur in the config block also.
  Anchor['nova::config::begin']
  -> Nova_paste_api_ini<||>
  ~> Anchor['nova::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the nova-package tag and the nova-support-package
  # tag.  Note: the package resources here will have a 'before' relationship on
  # the nova::install::end anchor.  The line between nova-support-package and
  # nova-package should be whether or not Nova services would need to be
  # restarted if the package state was changed.
  Anchor['nova::install::begin']
  -> Package<| tag == 'nova-support-package'|>
  -> Anchor['nova::install::end']

  # TODO(aschultz): check if we can remove these as I think they are no longer
  # valid since nova_cells is replaced by cell_v2 and the others are part of
  # nova network
  # The following resources are managed by calling 'nova manage' and so the
  # database must be provisioned before they can be applied.
  Anchor['nova::dbsync_api::end']
  -> Nova_cells<||>
  Anchor['nova::dbsync::end']
  -> Nova_cells<||>
  Anchor['nova::dbsync_api::end']
  -> Nova_floating<||>
  Anchor['nova::dbsync::end']
  -> Nova_floating<||>
  Anchor['nova::dbsync_api::end']
  -> Nova_network<||>
  Anchor['nova::dbsync::end']
  -> Nova_network<||>

  # all cache settings should be applied and all packages should be installed
  # before service startup
  Oslo::Cache<||> -> Anchor['nova::service::begin']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['nova::dbsync::begin']

  # Installation or config changes will always restart services.
  Anchor['nova::install::end'] ~> Anchor['nova::service::begin']
  Anchor['nova::config::end']  ~> Anchor['nova::service::begin']

  #############################################################################
  # NOTE(aschultz): these are defined here because this syntax allows us
  # to override the subscribe/notify order using the spaceship operator.
  # The ->/~> does not seem to be able to be updated after the fact. Since
  # we have to flip cell v2 ordering for the N->O upgrade process, we need
  # to not use the chaining arrows. ugh.
  #############################################################################
  # Wedge this in after the db creation and before the services
  anchor { 'nova::dbsync_api::begin':
    subscribe => Anchor['nova::db::end']
  }
  -> anchor { 'nova::dbsync_api::end':
    notify => Anchor['nova::service::begin'],
  }

  # Wedge this after db creation and api sync but before the services
  anchor { 'nova::dbsync::begin':
    subscribe => [
      Anchor['nova::db::end'],
      Anchor['nova::dbsync_api::end']
    ]
  }
  -> anchor { 'nova::dbsync::end':
    notify => Anchor['nova::service::begin']
  }

  # Between api sync and db sync by default but can be overridden
  # using the spaceship operator to move it around when needed
  anchor { 'nova::cell_v2::begin':
    subscribe => Anchor['nova::dbsync_api::end']
  }
  ~> anchor { 'nova::cell_v2::end':
    notify => Anchor['nova::dbsync::begin']
  }

  # Wedge online data migrations after db/api_sync and before service
  anchor { 'nova::db_online_data_migrations::begin':
    subscribe => Anchor['nova::dbsync_api::end']
  }
  -> anchor { 'nova::db_online_data_migrations::end':
    notify => Anchor['nova::service::begin']
  }
}
