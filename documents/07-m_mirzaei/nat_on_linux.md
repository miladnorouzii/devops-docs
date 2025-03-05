# Configure eth0 for Internet with a Public 

cat /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
BOOTPROTO=none
BROADCAST=xx.xx.xx.255    
HWADDR=00:50:BA:88:72:D4    
IPADDR=xx.xx.xx.xx
NETMASK=255.255.255.0   
NETWORK=xx.xx.xx.0       
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
IPV6INIT=no
PEERDNS=yes
GATEWAY=xx.xx.xx.1    

# Configure eth1 for LAN with a Private IP 

cat /etc/sysconfig/network-scripts/ifcfg-eth1
BOOTPROTO=none
PEERDNS=yes
HWADDR=00:50:8B:CF:9C:05    
TYPE=Ethernet
IPV6INIT=no
DEVICE=eth1
NETMASK=255.255.0.0       
BROADCAST=""
IPADDR=192.168.249.80        
NETWORK=192.168.249.0       
USERCTL=no
ONBOOT=yes


# Gateway Configuration

cat /etc/sysconfig/network
    NETWORKING=yes
    HOSTNAME=nat
    GATEWAY=xx.xx.xx.xx    

# DNS Configuration

cat /etc/resolv.conf
    nameserver 178.22.122.100     
          

# NAT configuration with IP Tables
```bash
iptables --flush           
iptables --table nat --flush
iptables --delete-chain
```
# Delete all that are not in default filter and nat table
```bash
iptables --table nat --delete-chain
```
# Set up IP FORWARDing and Masquerading
```bash
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface eth1 -j ACCEPT
```
# Enables packet forwarding by kernel 

echo 1 > /proc/sys/net/ipv4/ip_forward
 #Apply the configuration

```bash
service iptables restart
```