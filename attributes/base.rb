default['authorization']['sudo']['groups'] = ['wheel']
default['authorization']['sudo']['passwordless'] = true
default['openssh']['server']['permit_root_login'] = 'no'
default['openssh']['server']['port'] = '22'
default['openssh']['server']['banner'] = '/etc/issue'


default['fail2ban']['ignoreip'] = '127.0.0.1/8 192.168.1.0/24'
default['fail2ban']['bantime'] = 1200
default['fail2ban']['email'] = 'stephen@atalanta-systems.com'
default['fail2ban']['action'] = 'action_mwl'

default['fail2ban']['services'] = {
  'ssh' => {
        'enabled' => 'true',
        'port' => 'ssh',
        'filter' => 'sshd',
        'logpath' => node['fail2ban']['auth_log'],
        'maxretry' => '6'
     }
}
default['set_fqdn'] = '*.efg.nbwd.co.uk'
