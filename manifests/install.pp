class nginx::install ($nginx = "nginx-light", $ensure = 'installed') {
  include nginx::service
  include apt
  apt::ppa { "ppa:nginx/stable": } ->
  package { $nginx:
    ensure => $ensure,
    notify => Class["nginx::service"],
  }
}
