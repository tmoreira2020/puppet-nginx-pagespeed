class nginx_pagespeed {
  include nginx_pagespeed::params, nginx_pagespeed::install, nginx_pagespeed::config, nginx_pagespeed::service
}