include_recipe 'passenger_nginx'

passenger_nginx_vhost 'efg' do
  action :create
  port 80
  server_name 'efg.net'
  environment 'production'
  root '/home/deploy/efg/current/public'
end
