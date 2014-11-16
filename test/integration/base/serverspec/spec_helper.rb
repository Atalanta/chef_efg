require 'serverspec'

set :backend, :exec

def expect_network_security_to_match(pattern)
  expect(file('/etc/sysctl.d/10-network-security.conf').content).to match pattern
end

