include_recipe 'passenger_nginx'

env = node['efg']['efg_environment']

passenger_nginx_vhost 'default' do
  action :disable
  server_name 'localhost'
  root '/var/www/html'
  notifies :restart, 'service[nginx]'
end

passenger_nginx_vhost "#{env}.efg.nbwd.co.uk" do
  action [:create, :enable]
  port 80
  server_name '#{env}.efg.nbwd.co.uk'
  environment env
  root '/home/bamboo/efg/current/public'
end


