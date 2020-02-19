Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-nova.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

nova
====

#### Table of Contents

1. [Overview - What is the nova module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with nova](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Release Notes - Release notes for the project](#release-notes)
8. [Beaker-Rspec - Beaker-rspec tests for the project](#beaker-rspec)
9. [Contributors - Those with commits](#contributors)
10. [Repository - The project source code repository](#repository)

Overview
--------

The nova module is a part of [OpenStack](https://opendev.org/openstack), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects as part of the core software.  The module its self is used to flexibly configure and manage the compute service for OpenStack.

Module Description
------------------

The nova module is a thorough attempt to make Puppet capable of managing the entirety of nova.  This includes manifests to provision such things as keystone endpoints, RPC configurations specific to nova, and database connections.  Types are shipped as part of the nova module to assist in manipulation of configuration files.

This module is tested in combination with other modules needed to build and leverage an entire OpenStack software stack.

Setup
-----

**What the nova module affects:**

* [Nova](https://docs.openstack.org/nova/latest/), the compute service for OpenStack.

### Installing nova

    puppet module install openstack/nova

### Beginning with nova

To utilize the nova module's functionality you will need to declare multiple resources. This is not an exhaustive list of all the components needed, we recommend you consult and understand the [core openstack](https://docs.openstack.org) documentation.

```puppet
class { 'nova':
  database_connection     => 'mysql://nova:a_big_secret@127.0.0.1/nova?charset=utf8',
  api_database_connection => 'mysql://nova:a_big_secret@127.0.0.1/nova_api?charset=utf8',
  default_transport_url   => 'rabbit://nova:an_even_bigger_secret@127.0.0.1:5672/nova',
}

class { 'nova::compute':
  enabled                       => true,
  vnc_enabled                   => true,
}

class { 'nova::compute::libvirt':
  migration_support => true,
}
```

Implementation
--------------

### nova

nova is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

### Types

#### nova_config

The `nova_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/nova/nova.conf` file.

```puppet
nova_config { 'DEFAULT/my_ip' :
  value => '192.0.2.1',
}
```

This will write 'my_ip=192.0.2.1' in the `[DEFAULT]` section.

##### name

Section/setting name to manage from `nova.conf`

##### value

The value of the setting to be defined.

##### secret

Whether to hide the value from Puppet logs. Defaults to `false`.

##### ensure_absent_val

If value is equal to ensure_absent_val then the resource will behave as if `ensure => absent` was specified. Defaults to `<SERVICE DEFAULT>`

Limitations
-----------

* Supports libvirt, xenserver and vmware compute drivers.
* Tested on EL and Debian derivatives.

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-nova

Beaker-Rspec
------------

This module has beaker-rspec tests

To run the tests on the default vagrant node:

```shell
bundle install
bundle exec rspec spec/acceptance
```

For more information on writing and running beaker-rspec tests visit the documentation:

* https://github.com/puppetlabs/beaker-rspec/blob/master/README.md

Contributors
------------

* https://github.com/openstack/puppet-nova/graphs/contributors

Repository
----------

* https://opendev.org/openstack/puppet-nova
