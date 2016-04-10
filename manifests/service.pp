class nginx_pagespeed::service {

  service { 'nginx':
    enable => 'true',
    ensure  => 'running',
    require => Class['nginx_pagespeed::config']
  }

}