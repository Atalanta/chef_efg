users_manage 'wheel' do
  group_id 1919
  action [:remove, :create]
end

users_manage 'bastion' do
  group_id 2121
  action [:remove, :create]
end

include_recipe 'sudo'
include_recipe 'openssh'

execute 'Update kernel config' do
  command 'service procps start'
  action :nothing
end

cookbook_file '/etc/sysctl.d/10-network-security.conf' do
  source 'network-security.conf'
  notifies :run, 'execute[Update kernel config]'
end

%w{ chkrootkit rkhunter acct logwatch }.each { |pkg| package pkg }

%w{ 00logwatch acct chkrootkit rkhunter }.each do |job|

  file "/etc/cron.daily/#{job}" do
    action :delete
  end
  
  cookbook_file "/etc/cron.weekly/#{job}" do
    source "#{job}-cron"
    mode '0755'
  end
end

cookbook_file "/etc/cron.weekly/pacct-report" do
  source "pacct-report-cron"
  mode '0755'
end
