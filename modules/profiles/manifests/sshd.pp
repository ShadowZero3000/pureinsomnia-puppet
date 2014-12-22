class profiles::sshd (
){
  class { 'ssh::server':
    permit_root_login => 'no',
    password_authentication => 'no',
  }
}