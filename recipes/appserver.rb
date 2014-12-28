include_recipe 'passenger_nginx'

application_data = data_bag_item('efg', node['efg']['efg_environment'])
efg_env = node['efg']['efg_environment']
rails_env = application_data['environment']

passenger_nginx_vhost 'default' do
  action :disable
  server_name 'localhost'
  root '/var/www/html'
  notifies :restart, 'service[nginx]'
end

passenger_nginx_vhost "#{efg_env}.efg.nbwd.co.uk" do
  action [:create, :enable]
  port 80
  server_name "#{efg_env}.efg.nbwd.co.uk"
  environment rails_env
  root '/home/bamboo/efg/current/public'
end


