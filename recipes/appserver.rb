include_recipe 'passenger_nginx'

passenger_nginx_vhost 'default' do
  action :disable
  server_name 'localhost'
  root '/var/www/html'
  notifies :restart, 'service[nginx]'
end

passenger_nginx_vhost 'production.efg.nbwd.co.uk' do
  action [:create, :enable]
  port 80
  server_name 'production.efg.nbwd.co.uk'
  environment 'production'
  root '/home/bamboo/efg/current/public'
end


