# This manifest documents different use cases when running WSGI in Nova API

# Use Case #1: running Nova API with osapi_compute in WSGI, and metadata
class { '::nova': }
class { '::nova::api':
  admin_password => 'a_big_secret',
  service_name   => 'httpd',
}
include ::apache
class { '::nova::wsgi::apache':
  ssl => false,
}

# Use Case #2: running Nova API with osapi_compute in WSGI, and metadata disabled
class { '::nova': }
class { '::nova::api':
  admin_password => 'a_big_secret',
  enabled_apis   => ['osapi_compute'],
  service_name   => 'httpd',
}
include ::apache
class { '::nova::wsgi::apache':
  ssl => false,
}

# Use Case #3: not running osapi_compute, just enabling metadata
class { '::nova': }
class { '::nova::api':
  admin_password => 'a_big_secret',
  enabled_apis   => ['metadata'],
}
