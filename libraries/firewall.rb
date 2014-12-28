module FirewallHelper

  def bastion
<<-EOF
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -P INPUT DROP
EOF
  end

  def application
<<-EOF
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -s 192.168.1.2 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -P INPUT DROP
EOF
  end

  def database
<<-EOF
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -s 192.168.1.2 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 192.168.1.108 -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -s 192.168.1.110 -p tcp --dport 3306 -j ACCEPT
iptables -P INPUT DROP
EOF
  end
  
  def ci
<<-EOF
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -s 192.168.1.2 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -P INPUT DROP
EOF
  end

  def ruleset(node)
    if node.recipes.include? 'efg::ci'
      ruleset = ci
    elsif node.recipes.include? 'efg::deployable'
      ruleset = application
    elsif node.recipes.include? 'efg::database'
      ruleset = database
    else
      ruleset = bastion
    end
  end
  
end

Chef::Resource.send(:include, FirewallHelper)
