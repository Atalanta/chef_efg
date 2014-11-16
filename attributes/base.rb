default['authorization']['sudo']['groups'] = ['wheel']
default['authorization']['sudo']['passwordless'] = true
default['openssh']['server']['permit_root_login'] = 'no'
#default['openssh']['server']['port'] = '21322'
default['openssh']['server']['port'] = '22'

default['fail2ban']['ignoreip'] = '127.0.0.1/8 192.168.1.0/24'
default['fail2ban']['bantime'] = 1200
default['fail2ban']['email'] = 'stephen@atalanta-systems.com'
default['fail2ban']['action'] = 'action_mwl'

default['fail2ban']['filters'] = {
  'nginx-req-limit' => {
        "failregex" => ['limiting requests, excess:.* by zone.*client: <HOST>'],
        "ignoreregex" => []
     },
}

default['fail2ban']['services'] = {
  'ssh' => {
        "enabled" => "true",
        "port" => "ssh",
        "filter" => "sshd",
        "logpath" => node['fail2ban']['auth_log'],
        "maxretry" => "6"
     },
  'nginx-req-limit' => {
        "enabled" => "false",
        "port" => "http,https",
        "filter" => "nginx-req-limit",
        "logpath" => "/var/log/nginx/*error.log",
        "action" => 'iptables-multiport[name=ReqLimit, port="http,https", protocol=tcp]',
        "maxretry" => "6"
     }
}
