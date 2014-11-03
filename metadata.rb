name             'efg'
maintainer       'The Authors'
maintainer_email 'you@example.com'
license          'all_rights'
description      'Installs/Configures efg'
long_description 'Installs/Configures efg'
version          '0.6.1'

%w{ database fail2ban jenkins_mysql nginx passenger sudo users }.each do |cb|
  depends cb
end
