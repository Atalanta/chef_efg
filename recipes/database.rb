include_recipe 'mysql::server'
include_recipe 'database::mysql'

#databases = data_bag_item('efg', 'databases')

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

mysql_database 'efg' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'efg' do
  connection mysql_connection_info
  password 'efg'
  action :grant
end

execute 'restore-db' do
  command 'mysql -uroot -pilikerandompasswords efg < /root/anon_dump.sql'
  action :nothing
end

remote_file '/root/anon_dump.sql' do
  source 'http://178.62.227.6/efg_development_2014-07-21.sql'
  notifies :run, 'execute[restore-db]', :immediately
end

cookbook_file '/home/deploy/new_user.rb' do
  source 'new_user.rb'
end
