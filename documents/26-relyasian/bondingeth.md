## 	Configure Network Bonding on ubuntu.

first of all you need to know your interface name and to do that you can run this command
``` bash
ip -br a
```
then youu need to go to /etc/netplan/*.yaml and edit this file with
``` bash
vim /etc/netplan/#the config file
```













 change all like follows
 replace the interface name, IP address, DNS, Gateway to your environment value
for [mode] section, set a mode you'd like to use


```yaml
network:
  ethernets:
    enp1s0:
      dhcp4: false
      dhcp6: false
    enp7s0:
      dhcp4: false
      dhcp6: false
  bonds:
    bond0:
      addresses: [10.0.0.30/24]
      routes:
        - to: default
          via: 10.0.0.1
          metric: 100
      nameservers:
        addresses: [10.0.0.10]
        search: [srv.world]
      interfaces:
        - enp1s0
        - enp7s0
      parameters:
        mode: balance-rr
        mii-monitor-interval: 100
  version: 2
```
to apply that do
``` bash
netplan apply
```
 after setting bonding, [bonding] is loaded automatically
``` bash 
lsmod | grep bond
bonding               196608  0
tls  
```
done.