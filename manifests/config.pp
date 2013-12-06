class nginx::config (
  $nginx                  = 'nginx',
  $worker_processes       = 2,
  $worker_connections     = 1024,
  $worker_rlimit_nofile   = '',
  $multi_accept           = '',
  $underscores_in_headers = '',
  $client_max_body_size   = '1m',
  $ensure                 = 'present',) {
  class { "nginx::install": nginx => $nginx }

  include nginx::service

  if $worker_rlimit_nofile != '' {
    file { '/etc/default/nginx':
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
      content => template("nginx/default/nginx.erb"),
      require => Class["nginx::install"],
      notify  => Class["nginx::service"],
    }
  }

  #  remove default site
  file { "default-site":
    path    => "/etc/nginx/sites-enabled/default",
    ensure  => absent,
    notify  => Class["nginx::service"],
    require => Class["nginx::install"],
  }

  #  nginx conf
  file { "nginx.conf":
    path    => "/etc/nginx/nginx.conf",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template("nginx/nginx.conf.erb"),
    require => Class["nginx::install"],
    notify  => Class["nginx::service"],
  }

  #  log formats
  file { "log.formats":
    path    => "/etc/nginx/log.formats",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source  => "puppet:///modules/nginx/log.formats",
    require => Class["nginx::install"],
    notify  => Class["nginx::service"],
  }
}
