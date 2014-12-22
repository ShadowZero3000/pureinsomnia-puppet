class profiles::etherpad (
  $etherpad_title,
  $etherpad_root,
  $etherpad_session_key,
  $etherpad_database_user,
  $etherpad_database_password,
  $etherpad_users
){
  ## Hiera lookups
  #$run_script_path = hiera('profiles::etherpad::run_script_path')
  $dir = hiera('nodejs::target_dir')
  file{$dir:
    ensure => directory
  }
  file{'/opt/node/bin':
    ensure => link,
    target => '/usr/local/node/node-default/bin'
  }
  ## Include class
  class{'::etherpad':
    etherpad_title => $etherpad_title,
    etherpad_root => $etherpad_root,
    etherpad_database_user => $etherpad_database_user,
    etherpad_database_password => $etherpad_database_password,
    etherpad_session_key => $etherpad_session_key,
    etherpad_users => $etherpad_users
  }
}
