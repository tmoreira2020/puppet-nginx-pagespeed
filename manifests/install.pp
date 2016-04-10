class nginx_pagespeed::install {

  Exec {
    path => '/sbin:/bin:/usr/sbin:/usr/bin',
  }

  package {['gcc-c++', 'pcre-devel', 'zlib-devel', 'make', 'openssl-devel']:
    ensure => 'installed',
    before  => Exec['configure-nginx']
  }

  wget::fetch { 'fetch-pagespeed':
    source      => "https://codeload.github.com/pagespeed/ngx_pagespeed/tar.gz/release-${nginx_pagespeed::params::pagespeed_version}",
    destination => "/tmp/release-${nginx_pagespeed::params::pagespeed_version}.tar.gz",
    cache_dir   => $cache_dir,
    before      => Exec['untar-pagespeed']
  }

  exec { 'untar-pagespeed':
    command => "tar -zxvf /tmp/release-${nginx_pagespeed::params::pagespeed_version}.tar.gz -C /tmp",
    before  => [Exec['configure-nginx'], Exec['untar-psol']]
  }

  wget::fetch { 'fetch-psol':
    source      => "https://dl.google.com/dl/page-speed/psol/${nginx_pagespeed::params::psol_version}.tar.gz",
    destination => "/tmp/psol-${nginx_pagespeed::params::psol_version}.tar.gz",
    cache_dir   => $cache_dir,
    before      => Exec['untar-psol']
  }

  exec { 'untar-psol':
    command => "tar -zxvf /tmp/psol-${nginx_pagespeed::params::psol_version}.tar.gz -C /tmp/ngx_pagespeed-release-${nginx_pagespeed::params::pagespeed_version}/",
    before  => Exec['configure-nginx']
  }

  wget::fetch { 'fetch-nginx':
    source      => "http://nginx.org/download/nginx-${nginx_pagespeed::params::nginx_version}.tar.gz",
    destination => "/tmp/nginx-${nginx_pagespeed::params::nginx_version}.tar.gz",
    cache_dir   => $cache_dir,
    before      => Exec['untar-nginx']
  }

  exec { 'untar-nginx':
    command => "tar -zxvf /tmp/nginx-${nginx_pagespeed::params::nginx_version}.tar.gz -C /tmp",
    before  => Exec['configure-nginx']
  }

  exec { 'configure-nginx':
    cwd     => "/tmp/nginx-${nginx_pagespeed::params::nginx_version}",
    command => "/tmp/nginx-${nginx_pagespeed::params::nginx_version}/configure --add-module=/tmp/ngx_pagespeed-release-${nginx_pagespeed::params::pagespeed_version} --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-mail --with-mail_ssl_module --with-file-aio --with-ipv6 --with-cc-opt='-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic'",
    before  => Exec['make-nginx']
  }

  exec { 'make-nginx':
    cwd     => "/tmp/nginx-${nginx_pagespeed::params::nginx_version}",
    command => 'make',
    before  => Exec['install-nginx']
  }

  exec { 'install-nginx':
    cwd     => "/tmp/nginx-${nginx_pagespeed::params::nginx_version}",
    command => 'make install',
    before  => [File['/etc/nginx/conf.d'], File['/etc/nginx/ssl']]
  }

  file { '/etc/nginx/conf.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => 0755
  }

  file { '/etc/nginx/ssl':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => 0600
  }

  file { '/var/cache/nginx':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file { '/var/cache/pagespeed':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }
}