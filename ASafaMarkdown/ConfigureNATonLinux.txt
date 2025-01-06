sudo iptables --version

sudo apt install iptables

sudo yum install iptables

sudo sysctl -w net.ipv4.ip_forward=1

net.ipv4.ip_forward=1

sudo sysctl -p

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

sudo iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT

sudo iptables-save > /etc/iptables/rules.v4

sudo service iptables save

sudo apt install iptables-persistent

sudo iptables -t nat -L -v

sudo nft add table ip nat
sudo nft add chain ip nat POSTROUTING { type nat hook postrouting priority 100 \; }
sudo nft add rule ip nat POSTROUTING oif "eth0" masquerade
