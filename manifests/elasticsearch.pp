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
Yum::Repo <| title == 'elasticsearch-1_1' |>

sunjdk::instance { 'jdk.1.7.0_06-fcs':
  ensure => 'present',
  jdk_version => '1.7.0_06-fcs'
}

class { 'elasticsearch': }

Sunjdk::Instance['jdk.1.7.0_06-fcs'] -> Class['elasticsearch']
