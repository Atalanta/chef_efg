include_recipe 'efg::appserver'

package 'libsqlite3-dev'
package 'git'
gem_package 'bundler'

directory '/home/bamboo/efg' do
  owner 'bamboo'
  mode '0755'
end

directory '/home/bamboo/efg/shared' do
  owner 'bamboo'
  mode '0755'
end
  
directory '/home/bamboo/efg/shared/config' do
  owner 'bamboo'
  mode '0755'
end

application_data = data_bag_item('efg', node['efg']['efg_environment'])
db_server = search(:node, "recipe:efg\\:\\:database AND recipe:efg\\:\\:#{node['efg']['efg_environment']}")

template '/home/bamboo/efg/shared/config/database.yml' do
  owner 'bamboo'
  source 'database.yml.erb'
  variables({:application_data => application_data, :db_server => db_server.first.ipaddress} )
end

