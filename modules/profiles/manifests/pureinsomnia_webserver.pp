class profiles::pureinsomnia_webserver () {
  $puppet_home = '/opt/puppet_repo'
  file { '/var/www':
    ensure => 'directory',
  }
  file { '/var/www/hosts':
    ensure => 'link',
    target => '/opt/webhosts',
    require => File['/var/www']
  }
  cron { 'puppet-run':
    command => "/usr/bin/puppet apply ${puppet_home}/manifests/default.pp --modulepath=\"${puppet_home}/modules:/etc/puppet/modules\" --hiera_config \"${puppet_home}/hiera.yaml\"",
    user => 'root',
    minute => '*/15',
  }
  cron { 'puppet-update':
    command => 'cd /opt/puppet_repo && /usr/bin/git pull',
    user => 'root',
    minute => '*/10',
  }
  cron { 'puppet-bootstrap':
    command => "cd ${puppet_home} && ./bootstrap.sh",
    user => 'root',
    minute => '*/10',
  }
}