require 'spec_helper'

describe 'EFG Base Recipe' do
  
  it 'creates the atalanta and bamboo users' do
    expect(user 'atalanta').to exist
    expect(user 'bamboo').to exist
  end

  it 'creates the bastion and wheel groups' do
    expect(group 'bastion').to exist
    expect(group 'wheel').to exist
  end

  it 'places atalanta in both wheel and bastion groups' do
    expect(user 'atalanta').to belong_to_group 'bastion'
    expect(user 'atalanta').to belong_to_group 'wheel'
  end

  it 'places bamboo in the only the bastion group' do
    expect(user 'bamboo').to belong_to_group 'bastion'
    expect(user 'bamboo').not_to belong_to_group 'wheel'
  end

  it 'permits sudo for users in the wheel group' do
    expect(file('/etc/sudoers').content).to match /%wheel ALL=\(ALL\) NOPASSWD:ALL/
  end

  it 'disables root logins' do
    expect(file('/etc/ssh/sshd_config').content).to match /^PermitRootLogin no/
  end

  it 'runs ssh on a high port' do
    expect(file('/etc/ssh/sshd_config').content).to match /^Port \d{4,5}/
  end

  it 'ignores ICMP broadcast requests' do
    expect_network_security_to_match /icmp_echo_ignore_broadcasts = 1/ 
  end

  it 'disables source packet routing' do
    expect_network_security_to_match /accept_source_route = 0/ 
  end

  it 'ignores send redirects' do
    expect_network_security_to_match /send_redirects = 0/ 
  end

  it 'blocks SYN attacks' do
    [ /tcp_max_syn_backlog = 2048/, /tcp_synack_retries = 2/, /tcp_syn_retries = 5/ ].each do |pattern|
      expect_network_security_to_match pattern
    end
  end

  it 'logs Martians' do
    [ /log_martians = 1/, /icmp_ignore_bogus_error_responses = 1/  ].each do |pattern|
      expect_network_security_to_match pattern
    end
  end

  it 'ignores ICMP redirects' do
    expect_network_security_to_match /accept_redirects = 0/ 
  end

  it 'ignores directed pings' do
    expect_network_security_to_match /icmp_echo_ignore_\w+ = 1/ 
  end

  it 'installs a root kit checker' do
    expect(package 'chkrootkit').to be_installed
    expect(package 'rkhunter').to be_installed
  end

  it 'runs the root kit check weekly' do
    expect(file '/etc/cron.weekly/rkhunter').to be_file
    expect(file '/etc/cron.weekly/chkrootkit').to be_file
    expect(file '/etc/cron.daily/rkhunter_update').not_to be_file
    expect(file '/etc/cron.daily/chkrootkit').not_to be_file
  end

  it 'enables process accounting' do
    expect(package 'acct').to be_installed
  end

  it 'sends a process accounting summary once a week' do
    expect(file '/etc/cron.weekly/pacct-report').to be_file
  end

  it 'installs logwatch' do
    expect(package 'logwatch').to be_installed
  end

  it 'sends logwatch data weekly' do
    expect(file '/etc/cron.weekly/00logwatch').to be_file
    expect(file '/etc/cron.daily/00logwatch').not_to be_file
  end
 
  it 'installs fail2ban' do
    expect(package 'fail2ban').to be_installed
  end

  it 'protects against SSH attacks' do
    expect(file('/etc/fail2ban/jail.local').content).to match /filter = ssh/
  end

  it 'protects against HTTP DDOS' do
    expect(file('/etc/fail2ban/filter.d/nginx-req-limit.conf').content).to match /failregex = limiting requests, excess:/
    expect(file('/etc/fail2ban/jail.local').content).to match /filter = nginx-req-limit/
  end
end


