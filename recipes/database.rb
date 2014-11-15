include_recipe 'mysql::server'
include_recipe 'database::mysql'

application_data = data_bag_item('efg', node['efg']['efg_environment'])

service 'mysql-init' do
  service_name 'mysql'
  provider Chef::Provider::Service::Init
  action [:stop, :disable]
  only_if { File.exists?('/etc/init.d/mysql') }
end

service 'mysql-upstart' do
  service_name 'mysql'
  provider Chef::Provider::Service::Upstart
  action :nothing
end

file '/etc/init.d/mysql' do
  action :delete
  notifies :restart, 'service[mysql-upstart]', :immediately
end

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

mysql_database application_data['database'] do
  connection mysql_connection_info
  action :create
end

mysql_database_user application_data['username'] do
  connection mysql_connection_info
  password application_data['password']
  action :grant
end

cookbook_file '/home/bamboo/new_user.rb' do
  source 'new_user.rb'
end
