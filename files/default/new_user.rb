CfeAdmin.create! do |user|
  user.username = 'sns'
  user.password = user.password_confirmation = 'password'
  user.first_name = 'Stephen'
  user.last_name = 'Nelson-Smith'
  user.email = 'stephen@atalanta-systems.com'

end
