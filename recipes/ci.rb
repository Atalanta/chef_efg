include_recipe 'efg::base'
include_recipe 'jenkins::master'
include_recipe 'efg::database'
include_recipe 'apt-repo'

ppa 'ppa:brightbox/ruby-ng'  

package 'ruby2.1'
package 'ruby2.1-dev'
package 'git'
package 'libsqlite3-dev'

gem_package 'bundler'
gem_package 'rake'
gem_package 'capistrano'

jenkins_plugin 'git' do
  notifies :restart, 'service[jenkins]', :immediately
end

link '/home/jenkins' do
  to '/var/lib/jenkins'
end

efg_test = File.join(Chef::Config[:file_cache_path], 'efg-test-jenkins-job.xml')

cookbook_file efg_test do
  source 'efg-test-jenkins-job.xml'
end

jenkins_job 'efg_test' do
  config efg_test
end
