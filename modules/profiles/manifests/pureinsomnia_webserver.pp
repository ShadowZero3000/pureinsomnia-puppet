class profiles::pureinsomnia_webserver () {
  file { '/var/www':
    ensure => 'directory',
  }
  file { '/var/www/hosts':
    ensure => 'link',
    target => '/opt/webhosts',
    require => File['/var/www']
  }
  cron { 'puppet-run':
    command => '/usr/bin/puppet apply /opt/puppet_repo/manifests/default.pp --modulepath="/opt/puppet_repo/modules:/etc/puppet/modules" --hiera_config "/opt/puppet_repo/hiera.yaml"',
    user => 'root',
    minute => '*/15',
  }
  cron { 'puppet-update':
    command => 'cd /opt/puppet_repo && /usr/bin/git pull',
    user => 'root',
    minute => '*/10',
  }
}