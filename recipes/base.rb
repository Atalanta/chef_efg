execute 'Save iptables' do
  command 'iptables-save'
  action :nothing
end

bash 'Basic Firewall' do
  code <<-EOH
  iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A INPUT -p tcp --dport 21322 -j ACCEPT
  iptables -A INPUT -p tcp --dport 80 -j ACCEPT
  iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
  iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
  iptables -A INPUT -p tcp --dport 443 -j ACCEPT
  iptables -P INPUT DROP
  EOH
  notifies :run, 'execute[Save iptables]'
end

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
include_recipe 'fail2ban'

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
