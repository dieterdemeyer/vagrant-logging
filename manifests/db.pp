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
Yum::Repo <| title == 'packetbeat' |>

class { 'mysql::server':
  data_dir                => '/data/mysql',
  default_storage_engine  => 'InnoDB',
  innodb_buffer_pool_size => '256M',
  instance_type           => 'large'
}

mysql::database { 's4t_mrt':
  ensure => present,
}

mysql::rights { 's4t_mrt':
  ensure   => present,
  database => 's4t_mrt',
  user     => 's4t_mrt',
  password => 's4t_mrt',
  host     => '%',
}

mysql::database { 's4t_mrt_security':
  ensure => present,
}

mysql::rights { 's4t_mrt_security':
  ensure   => present,
  database => 's4t_mrt_security',
  user     => 's4t_mrt_security',
  password => 's4t_mrt_security',
  host     => '%',
}

class { 'packetbeat':
  elasticsearch_host => 'elasticsearch.example.com'
}
