# Class: ts3server
#
#   The ts3server.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class ts3server (
  $architecture          = $ts3server::params::architecture,
  $clear_database        = $ts3server::params::clear_database,
  $daemon                = true,
  $dbplugin              = $ts3server::params::dbplugin,
  $dbsqlcreatepath       = $ts3server::params::dbsqlcreatepath,
  $default_virtualserver = $ts3server::params::default_virtualserver,
  $filetransfer_ip       = $ts3server::params::filetransfer_ip,
  $filetransfer_port     = $ts3server::params::filetransfer_port,
  $group                 = $ts3server::params::group,
  $inifile               = $ts3server::params::inifile,
  $installroot           = $ts3server::params::installroot,
  $licensepath           = $ts3server::params::licensepath,
  $logpath               = $ts3server::params::logpath,
  $machine_id            = $ts3server::params::machine_id,
  $package_download_url  = $ts3server::params::package_download_url,
  $package_name          = $ts3server::params::package_name,
  $port                  = $ts3server::params::port,
  $query_ip              = $ts3server::params::query_ip,
  $query_port            = $ts3server::params::query_port,
  $repo_url              = $ts3server::params::repo_url,
  $user                  = $ts3server::params::user,
  $version               = $ts3server::params::version,
  $voice_ip              = $ts3server::params::voice_ip,
)  inherits ts3server::params {
  include ts3server::params
  $ts3server_folder_name = "teamspeak3-server_linux-${::architecture}"
  $ts3server_package = $package_name ? {
    undef => "teamspeak3-server_linux-${architecture}-${version}.tar.gz",
    default => $package_name,
  }
  $ts3server_package_url = $package_download_url ? {
    undef => "${repo_url}/${version}/${ts3server_package}",
    default => $package_download_url,
  }
  $server_root="${installroot}/${ts3server_folder_name}"
  class { 'staging':
    path  => '/tmp/staging',
  }
  staging::file { $ts3server_package:
    source => $ts3server_package_url,
  }

  if ! defined(Package['screen']) {
    package { 'screen':
      ensure => installed,
    }
  }

  file { "${installroot}":
    ensure  => directory,
    recurse => true,
  }
  file { "${installroot}/versions":
    ensure => directory,
    recurse => true,
    owner   => $user,
    group   => $group,
    require => File["${installroot}"],
  }
  file { "${installroot}/data":
    ensure => directory,
    require => File["${installroot}"],
    owner => $user,
    group => $group,
    recurse => true,
  }
  $dbfile="${installroot}/data/ts3server.sqlitedb"
  file { "${dbfile}":
    ensure => file,
    owner   => $user,
    group   => $group,
  }
  file { "${server_root}/ts3server.sqlitedb":
    ensure => link,
    target => $dbfile,
    require => File["${dbfile}"],
  }

  file { "${installroot}/versions/${version}":
    ensure  => directory,
    recurse => true,
    owner   => $user,
    group   => $group,
    require => File["${installroot}/versions"],
  }

  staging::extract { $ts3server_package:
    target  => "${installroot}/versions/${version}",
#    creates => $server_root,
    creates => "${installroot}/versions/${version}/${ts3server_folder_name}",
    require => [File["${installroot}/versions/${version}"],Staging::File[$ts3server_package]],
    user   => $user,
    group   => $group,
  }

  file { $server_root:
    ensure  => link,
    target  => "${installroot}/versions/${version}/${ts3server_folder_name}",
    require => Staging::Extract[$ts3server_package],
  }

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure  => present,
    home    => $installroot,
    gid     => $group,
    require => [Group[$group],File[$installroot]],
  }

  file { "$server_root/ts3server.ini":
    ensure  => file,
    content => template('ts3server/ts3server.ini.erb'),
    owner   => $user,
    group   => $group,
    require => File[$server_root],
    notify  => Service['teamspeak'],
  }

  if $keyfile != undef {
    file { $server_root:
      ensure => file,
      source => $keyfile,
    }
  }

  file { '/etc/init.d/teamspeak':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content  => template('ts3server/teamspeak.erb'),
  }

  service { 'teamspeak':
    enable  => true,
    ensure  => running,
    require => File['/etc/init.d/teamspeak'],
  }
}
