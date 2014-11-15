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

template '/home/bamboo/efg/shared/config/database.yml' do
  owner 'bamboo'
  source 'database.yml.erb'
end

