class profiles::sshd (
){
  sshd::config{
    "PermitRootLogin": value => "no";
    "PasswordAuthentication": value => "no";
  }
}