users_manage 'wheel' do
  group_id 1919
  action [:remove, :create]
end

users_manage 'bastion' do
  group_id 2121
  action [:remove, :create]
end

include_recipe 'sudo'
