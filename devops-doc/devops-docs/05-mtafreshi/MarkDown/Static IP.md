## Static IP Address in Rocky 9.4 Minimal
### ip -br a
## Command IP
### ip addr add 192.168.1.152/24 dev Eth_Name
### sudo systemctl restart NetworkManager

# ifcfg Config
## Go to etc > sysconfig > network-script
### cd /etc/sysconfig/network-script
### sudo vi / vim ifcfg-"Network Name"
### DEVICE="Network Name"
### ONBOOT=yes
### BOOTPROTO=none
### IPADDR="IP Address"
### NETMASK="Subnet Mask"
### GATEWAY="IP Gateway"
### DNS1="IP DNS"
## Restart Network Service
### systemctl restart NetworkManager