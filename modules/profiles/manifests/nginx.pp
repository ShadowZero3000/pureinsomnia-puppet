class profiles::nginx (
  $vhosts,
  $locations
){
  ## Hiera lookups

  ## Configure firewall access
  include ufw
  ufw::allow { "nginx-http(s)":
    port => "80,443",
    ip => 'any',
  }

  ## Include class
  include ::nginx
  include ::php::fpm
  ## Instantiate vhosts
  create_resources('::nginx::resource::vhost',$vhosts)
  create_resources('::nginx::resource::location',$locations)
}