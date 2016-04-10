class nginx_pagespeed::config {

  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    source  => 'puppet:///modules/nginx_pagespeed/nginx.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['nginx_pagespeed::install']
  }

  file { '/lib/systemd/system/nginx.service':
    ensure  => present,
    source  => 'puppet:///modules/nginx_pagespeed/nginx.service',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Class['nginx_pagespeed::install']
  }

}