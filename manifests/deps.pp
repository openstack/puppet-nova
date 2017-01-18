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
  ~> anchor { 'nova::dbsync::begin': }
  -> anchor { 'nova::dbsync::end': }
  ~> anchor { 'nova::dbsync_api::begin': }
  -> anchor { 'nova::dbsync_api::end': }
  ~> anchor { 'nova::service::begin': }
  ~> Service<| tag == 'nova-service' |>
  ~> anchor { 'nova::service::end': }

  # paste-api.ini config shold occur in the config block also.
  Anchor['nova::config::begin']
  -> Nova_paste_api_ini<||>
  ~> Anchor['nova::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the nova-package tag and the nova-support-package
  # tag.  Note: the package resources here will have a 'before' relationshop on
  # the nova::install::end anchor.  The line between nova-support-package and
  # nova-package should be whether or not Nova services would need to be
  # restarted if the package state was changed.
  Anchor['nova::install::begin']
  -> Package<| tag == 'nova-support-package'|>
  -> Anchor['nova::install::end']

  # The following resourcs are managed by calling 'nova manage' and so the
  # database must be provisioned before they can be applied.
  Anchor['nova::dbsync::end']
  -> Anchor['nova::dbsync_api::end']
  -> Nova_cells<||>
  Anchor['nova::dbsync::end']
  -> Anchor['nova::dbsync_api::end']
  -> Nova_floating<||>
  Anchor['nova::dbsync::end']
  -> Anchor['nova::dbsync_api::end']
  -> Nova_network<||>

  # Installation or config changes will always restart services.
  Anchor['nova::install::end'] ~> Anchor['nova::service::begin']
  Anchor['nova::config::end']  ~> Anchor['nova::service::begin']

  # This is here for backwards compatability for any external users of the
  # nova-start anchor.  This should be considered deprecated and removed in the
  # N cycle
  anchor { 'nova-start':
    require => Anchor['nova::install::end'],
    before  => Anchor['nova::config::begin'],
  }
}
