include role::base

class { 'ssl_certificates': stage => 'setup_repo' }

Yum::Repo <| title == 'cegeka-unsigned' |>
Yum::Repo <| title == 'cegeka-unsigned-i386' |>
Yum::Repo <| title == 'cegeka-custom' |>
Yum::Repo <| title == 'cegeka-custom-noarch' |>
Yum::Repo <| title == 'puppet' |>
Yum::Repo <| title == 'puppet-dependencies' |>
Yum::Repo <| title == 'elasticsearch-1_1' |>

sudo::config::user { 'admin_group' :
  user          => '%admin',
  configuration => 'ALL=(ALL)       NOPASSWD: ALL'
}

File <| title == '/data/logs' |>

sunjdk::instance { 'jdk.1.7.0_06-fcs':
  ensure => 'present',
  jdk_version => '1.7.0_06-fcs'
}

class { 'elasticsearch':
  version      => '1.1.1-1',
  versionlock  => true,
  cluster_name => 'renta'
}

Sunjdk::Instance['jdk.1.7.0_06-fcs'] -> Class['elasticsearch']
