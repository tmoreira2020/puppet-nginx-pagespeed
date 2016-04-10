define nginx_pagespeed::vhost (
  $listen_port                  = 80,
  $proxy                        = undef,
  $server_name                  = $name,
) {

  file { '/etc/nginx/conf.d/default.conf':
    ensure => present,
    content => template('nginx_pagespeed/vhost.conf.erb'),
    owner  => 'root',
    group  => 'root',
    mode   => 0644,
    notify  => Class['nginx_pagespeed::service'],
  }

}