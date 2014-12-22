class profiles::mysql (
  $root_password
){

  ## Include class
  class{'::mysql::server':
    root_password => $root_password
  }
}
