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

sunjdk::instance { 'jdk.1.7.0_06-fcs':
  ensure => 'present',
  jdk_version => '1.7.0_06-fcs'
}

$tomcat_version = '7.0.47-1.cgk.el6'
$tomcat_instance_root_dir = '/data'

tomcat::server { "tomcat-${tomcat_version}":
  tomcat_version => $tomcat_version,
}

tomcat::instance { 'tomcat00':
  tomcat_instance_root_dir => $tomcat_instance_root_dir,
  tomcat_instance_number => '00',
  tomcat_instance_gid => '1005',
  tomcat_instance_uid => '1105',
  tomcat_instance_password => '$1$JOOZyS5c$JDJq9SdMWVZi8IRT/Lh2H1',
  tomcat_version => $tomcat_version,
  tomcat_options_start => [
    { 'SERVER_PORT' => '8050' },
    { 'HTTP_PORT' => '8080' },
    { 'AJP_PORT' => '8010' },
    { 'TOMCAT_INSTANCE_PROPS' => '"-Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=512m
        -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=true -Djava.rmi.server.hostname=web.example.com
        -Dcom.sun.management.jmxremote.password.file=/data/tomcat00/conf/jmxremote.password -Dcom.sun.management.jmxremote.access.file=/data/tomcat00/conf/jmxremote.access
        -Dtn.tomcat.server.port=$SERVER_PORT -Dtn.tomcat.connector.http.port=$HTTP_PORT
        -Dtn.tomcat.connector.ajp.port=$AJP_PORT
        -Dtn.tomcat.connector.ajp.maxThreads=200
        -Dtn.tomcat.engine.jvmRoute=${TOMCAT_NAME}${TOMCAT_NUMBER}"' }
  ],
  tomcat_listen_address             => '0.0.0.0',
  tomcat_connector_http_max_threads => '250',
  tomcat_jmx_enabled                => true,
  tomcat_jmx_port                   => '8686',
  tomcat_jmx_serverport             => '8687',
  tomcat_access_log_valve_pattern   => "%h %l %u %t %S %I &quot;%r&quot; %s %b &quot;%{Referer}i&quot; &quot;%{User-Agent}i&quot; %D",
  tomcat_remote_ip_valve_enabled    => true
}

tomcat::instance::user { 'adding tomcat user':
  tomcat_instance_root_dir => $tomcat_instance_root_dir,
  tomcat_instance_number => '00',
  username => 'test',
  password => 'test',
  roles => 'manager-gui,manager-script'
}

tomcat::instance::jmx_authentication { 'setting jmx security':
  tomcat_instance_root_dir => $tomcat_instance_root_dir,
  tomcat_instance_number => '00',
  tomcat_jmx_username => 'test',
  tomcat_jmx_password => 'test',
  tomcat_jmx_access => 'readwrite'
}

Sunjdk::Instance['jdk.1.7.0_06-fcs'] -> Tomcat::Server["tomcat-${tomcat_version}"] -> Tomcat::Instance['tomcat00']

class { 'packetbeat':
  version             => '0.2.0-1.el6',
  versionlock         => true,
  elasticsearch_host  => 'elasticsearch.example.com',
  protocols_monitored => {
    'http' => '8080'
  },
  processes_monitored => {
    'tomcat'  => 'tomcat00'
  }
}

