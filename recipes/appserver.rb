include_recipe 'passenger_nginx'

passenger_nginx_vhost 'efg' do
  action :create
  port 80
  server_name 'efg.net'
  environment 'production'
  root '/home/bamboo/efg/current/public'
end

passenger_nginx_vhost 'default' do
  action :delete
  server_name 'localhost'
  root '/var/www/html'
  notifies :restart, 'service[nginx]'
end
