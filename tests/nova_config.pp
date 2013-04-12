resources { 'nova_config':
  purge => true
}
nova_config { ['DEFAULT/verbose', 'DEFAULT/nodaemomize']:
  value => 'true',
}
nova_config { 'DEFAULT/xenapi_connection_username':
  value => 'rootty',
}
