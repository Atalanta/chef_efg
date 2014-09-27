include_recipe 'efg::appserver'

package 'libsqlite3-dev'
package 'git'
package 'libsqlite3-dev'
gem_package 'bundler'

user 'deploy' do
  shell '/bin/bash'
  supports :manage_home => true
end

directory '/home/deploy' do
  owner 'deploy'
  mode '0755'
end

directory '/home/deploy/efg' do
  owner 'deploy'
  mode '0755'
end

directory '/home/deploy/efg/shared' do
  owner 'deploy'
  mode '0755'
end
  
directory '/home/deploy/efg/shared/config' do
  owner 'deploy'
  mode '0755'
end

directory '/home/deploy/.ssh' do
  owner 'deploy'
  mode '0700'
end

template '/home/deploy/.ssh/authorized_keys' do
  source 'authorized_keys.erb'
  owner 'deploy'
  mode '0600'
end

template '/home/deploy/efg/shared/config/database.yml' do
  owner 'deploy'
  source 'database.yml.erb'
end

