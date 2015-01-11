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
  host '192.168.1.0/255.255.255.0'
  action :grant
end

cookbook_file '/home/bamboo/new_user.rb' do
  source 'new_user.rb'
end

skyscape = data_bag_item('secrets','skyscape')

backup_model :efg do
  description 'EFG Backup'

  definition <<-DEF
    split_into_chunks_of 4000

    database MySQL do |db|
      db.name = '#{application_data['database']}'
      db.username = '#{application_data['username']}'
      db.password = '#{application_data['password']}'
    end

    compress_with Gzip

    store_with S3 do |s3|
      s3.access_key_id = '#{skyscape['skyscape_access_key_id']}'
      s3.secret_access_key = '#{skyscape['skyscape_secret_access_key']}'
      s3.bucket = '#{node['fqdn']}_backup'
      s3.path              = '/'
      s3.keep = 14 
      s3.max_retries = 1
      s3.fog_options = {
        :endpoint => 'https://cas00001.skyscapecloud.com:8443',
        :path_style => true
      }
    end
  DEF

  schedule({
    :minute => 0,
    :hour   => 0
  })
end 
