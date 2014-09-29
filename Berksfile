source "https://supermarket.getchef.com"

metadata

#cookbook 'passenger_nginx', git: 'https://github.com/Atalanta/chef_passenger_nginx'
cookbook 'passenger_nginx', path: '/home/kitchen/passenger_nginx'

group :integration do
  cookbook 'chef-solo-search', '~> 0.5.1'
end
