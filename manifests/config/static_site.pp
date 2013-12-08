define nginx::config::static_site (
  $ensure         = present,
  $ip             = '0.0.0.0',
  $port           = 80,
  $default_server = false,
  $server_name    = false,
  $base_dir       = '/var/www',
  $root_dir       = $title,
  $index          = 'index.html',) {
  $document_root = "${base_dir}/${title}"

  file { "${title}-available":
    path    => "/etc/nginx/sites-available/${title}",
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template("nginx/sites/static_site.erb"),
    require => Class["nginx::install"],
    notify  => Class["nginx::service"],
  }

  case $ensure {
    absent  : {
      file { "${title}-enabled":
        path   => "/etc/nginx/sites-enabled/${title}",
        ensure => $ensure,
        notify => Class["nginx::service"],
      }
    }
    present : {
      file { "${title}-enabled":
        path    => "/etc/nginx/sites-enabled/${title}",
        ensure  => link,
        target  => "/etc/nginx/sites-available/${title}",
        require => File["/etc/nginx/sites-available/${title}"],
        notify  => Class["nginx::service"],
      }
    }
  }

  file { "/var/www/${title}":
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 775,
  }
}
