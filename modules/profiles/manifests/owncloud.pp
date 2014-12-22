class profiles::owncloud (
  $webserver,
  $ssl,
  $servername
){
  ## Hiera lookups

  ## Configure firewall access
  class{ '::owncloud':
    path => '/opt/owncloud'
  }

  # Configure nginx to serve owncloud
  class { 'owncloud::nginx':
    hostname => $servername,
    upload_max_filesize => '1000M',
    php_fpm => 'unix:/var/run/php5-fpm.sock',
    # ssl => true,
    # ssl_key => 'mydomain.tld.key',
    # ssl_cert => 'mydomain.tld.crt',
  }

  include ::php::extension::gd
  include ::php::extension::mysql
  include ::php::extension::gd
}