class profiles::ts3server (
  $version,
  $licensepath
){
  ## Hiera lookups
  #$version      = hiera('profiles::ts3server::version')
  #$licensepath  = hiera('profiles::ts3server::licensepath')

  ## Configure firewall access
  include ufw
  ufw::allow { "allow-global-udp":
    port => "53",
    proto => "udp",
    ip => 'any',
  }
  ufw::allow { "teamspeak-tcp":
    port => "9987,9988",
    proto => "tcp",
    ip => 'any',
  }
  ufw::allow { "teamspeak-udp":
    port => "9987,9988",
    proto => "udp",
    ip => 'any',
  }

  ## Include class
  class { '::ts3server':
    dbsqlcreatepath => 'create_sqlite',
    version => $version,
    licensepath => $licensepath,
  }
}