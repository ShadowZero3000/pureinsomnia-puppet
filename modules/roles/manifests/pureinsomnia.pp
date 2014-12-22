class roles::pureinsomnia () {
  User<| |> -> Ssh_authorized_key <| |>
  include profiles::etherpad
  include profiles::mysql
  include profiles::nginx
  include profiles::owncloud
  include profiles::pureinsomnia_webserver
  include profiles::ssh
  include profiles::sshd
  include profiles::ts3server
  include profiles::users
}