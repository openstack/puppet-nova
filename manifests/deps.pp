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
  ~> anchor { 'nova::service::begin': }
  ~> Service<| tag == 'nova-service' |>
  ~> anchor { 'nova::service::end': }

  # paste-api.ini config should occur in the config block also.
  Anchor['nova::config::begin']
  -> Nova_api_paste_ini<||>
  ~> Anchor['nova::config::end']

  # rootwrap config should occur in the config block also.
  Anchor['nova::config::begin']
  -> Nova_rootwrap_config<||>
  ~> Anchor['nova::config::end']

  # policy config should occur in the config block also.
  Anchor['nova::config::begin']
  -> Openstacklib::Policy<| tag == 'nova' |>
  -> Anchor['nova::config::end']

  # On any uwsgi config change, we must restart Nova APIs.
  Anchor['nova::config::begin']
  -> Nova_api_uwsgi_config<||>
  ~> Anchor['nova::config::end']

  Anchor['nova::config::begin']
  -> Nova_api_metadata_uwsgi_config<||>
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

  # Start libvirt services during the service phase
  Anchor['nova::service::begin']
  -> Exec<| tag == 'libvirt-service'|>
  -> Service<| tag == 'libvirt-service'|>
  -> Anchor['nova::service::end']

  # We need openstackclient before marking service end so that nova
  # will have clients available to create resources. This tag handles the
  # openstackclient but indirectly since the client is not available in
  # all catalogs that don't need the client class (like many spec tests)
  Package<| tag == 'openstackclient'|>
  -> Anchor['nova::service::end']

  # Manage libvirt configurations during the config phase
  Anchor['nova::config::begin'] -> Libvirtd_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Virtlogd_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Virtlockd_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Virtnodedevd_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Virtproxyd_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Virtqemud_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Virtsecretd_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Virtstoraged_config<||> -> Anchor['nova::config::end']
  Anchor['nova::config::begin'] -> Qemu_config<||> -> Anchor['nova::config::end']

  # all cache settings should be applied and all packages should be installed
  # before service startup
  Oslo::Cache<||> -> Anchor['nova::service::begin']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['nova::dbsync::begin']
  Oslo::Db<||> -> Anchor['nova::dbsync_api::begin']

  # Installation or config changes will always restart services.
  Anchor['nova::install::end'] ~> Anchor['nova::service::begin']
  Anchor['nova::config::end']  ~> Anchor['nova::service::begin']

  # Nova requres separate sync operation for API db, and it should be executed
  # before non-API db sync.
  Anchor['nova::db::end']
  ~> anchor { 'nova::dbsync_api::begin': }
  -> anchor { 'nova::dbsync_api::end': }
  ~> Anchor['nova::dbsync::begin']

  Anchor['nova::dbsync_api::end'] ~> Anchor['nova::service::begin']

  Anchor['nova::dbsync_api::end']
  ~> anchor { 'nova::cell_v2::begin': }
  ~> anchor { 'nova::cell_v2::end': }
  ~> Anchor['nova::dbsync::begin']

  Anchor['nova::dbsync_api::end']
  ~> anchor { 'nova::db_online_data_migrations::begin': }
  -> anchor { 'nova::db_online_data_migrations::end': }
  ~> Anchor['nova::service::begin']
}
