execute 'Save iptables' do
  command 'iptables-save'
  action :nothing
end

bash 'Basic Firewall' do
  code ruleset(node)
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

data_bag('users').each do |u|

  directory "/home/#{u}" do
    mode 0711
  end
  
end

include_recipe 'sudo'
include_recipe 'openssh'
include_recipe 'fail2ban'
include_recipe 'chef-client::delete_validation'

execute 'Update kernel config' do
  command 'service procps start'
  action :nothing
end

cookbook_file '/etc/issue' do
  source 'etc-issue'
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

cookbook_file '/etc/pam.d/common-password' do
  source 'common-password'
end

file '/sbin/mount.nfs' do
  mode '0755'
end

file '/usr/bin/pkexec' do
  mode '0755'
end

file '/usr/sbin/postdrop' do
  mode '0555'
end

file '/usr/sbin/postqueue' do
  mode '0555'
end

file '/usr/lib/dbus-1.0/dbus-daemon-launch-helper' do
  mode '0754'
end

file '/usr/lib/policykit-1/polkit-agent-helper-1' do
  mode '0755'
end

file '/usr/lib/emacs/24.3/x86_64-linux-gnu/movemail' do
  mode '0755'
end

file '/var/log/wtmp' do
  mode '0660'
end

file '/var/log/dpkg.log.1' do
  mode '0640'
end

file '/var/log/dpkg.log' do
  mode '0640'
end

file '/var/log/unattended-upgrades/unattended-upgrades-shutdown.log' do
  mode '0640'
end

file '/var/log/apt/history.log' do
  mode '0640'
end

file '/var/log/apt/history.log.1.gz' do
  mode '0640'
end

file '/var/log/lastlog' do
  mode '0660'
end

file '/var/log/boot.log' do
  mode '0640'
end

file '/var/log/wtmp.1' do
  mode '0660'
end

file '/var/log/bootstrap.log' do
  mode '0640'
end

file '/var/log/faillog' do
  mode '0640'
end

file '/var/log/alternatives.log' do
  mode '0640'
end

file '/var/log/installer/initial-status.gz' do
  mode '0640'
end

file '/var/log/installer/lsb-release' do
  mode '0640'
end

file '/var/log/installer/status' do
  mode '0640'
end

file '/var/log/installer/hardware-summary' do
  mode '0640'
end

file '/var/log/installer/media-info' do
  mode '0640'
end

file '/var/log/nginx/error.log' do
  mode '0640'
end

file '/var/log/alternatives.log.1' do
  mode '0640'
end

file '/var/log/landscape/sysinfo.log' do
  mode '0640'
end


