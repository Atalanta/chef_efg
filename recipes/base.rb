users_manage 'wheel' do
  group_id 1919
  action [:remove, :create]
end

users_manage 'bastion' do
  group_id 2121
  action [:remove, :create]
end

include_recipe 'sudo'
include_recipe 'openssh'

execute 'Update kernel config' do
  command 'service procps start'
  action :nothing
end

cookbook_file '/etc/sysctl.d/10-network-security.conf' do
  source 'network-security.conf'

end
