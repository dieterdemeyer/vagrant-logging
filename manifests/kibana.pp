include role::base

class { 'ssl_certificates': stage => 'setup_repo' }

sudo::config::user { 'admin_group' :
  user          => '%admin',
  configuration => 'ALL=(ALL)       NOPASSWD: ALL'
}

Yum::Repo <| title == 'cegeka-unsigned' |>
Yum::Repo <| title == 'cegeka-unsigned-i386' |>
Yum::Repo <| title == 'cegeka-custom' |>
Yum::Repo <| title == 'cegeka-custom-noarch' |>
Yum::Repo <| title == 'puppet' |>
Yum::Repo <| title == 'puppet-dependencies' |>

File <| title == '/data/www' |>

class { 'kibana':
  version => 'present',
  elasticsearch_host => 'elasticsearch.example.com'
}

class { 'apache':
  apache_vhost_root => '/data/www/vhosts'
}

apache::vhost { 'kibana.example.com':
  ensure  => present,
  docroot => '/opt/kibana',
}

Class['kibana'] -> Class['apache'] -> Apache::Vhost['kibana.example.com']
