name             'efg'
maintainer       'The Authors'
maintainer_email 'you@example.com'
license          'all_rights'
description      'Installs/Configures efg'
long_description 'Installs/Configures efg'
version          '0.8.0'
%w{ database dyn-iptables fail2ban jenkins mysql
    passenger_nginx sudo users }.each do |cb|
  depends cb
end
