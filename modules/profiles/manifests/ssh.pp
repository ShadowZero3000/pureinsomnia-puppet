class profiles::ssh (
  $authorized_keys
){
  ## Hiera lookups

  ## Configure firewall access
  include ufw
  ufw::allow { "ssh-in":
    port => "22",
    ip => 'any',
  }
  create_resources(ssh_authorized_key, $authorized_keys)

}