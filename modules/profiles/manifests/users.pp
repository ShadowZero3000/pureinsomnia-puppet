class profiles::users (
  $users,
  $groups
){
  create_resources(group, $groups)
  create_resources(user, $users)
}