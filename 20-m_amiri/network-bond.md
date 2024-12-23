# How create-network-bond-bridge-in-ubuntu.

```bash
lsmod | grep bond
```
```bash
sudo modprobe bonding
```
```bash
lsmod | grep bond
```
```bash
sudo apt install ifenslave -y
```
```bash
ip a
```
```bash
sudo apt install net-tools
```
```bash
sudo ifconfig enp0s3 down
sudo ifconfig enp0s8 down
```
sudo ip link add bond0 type bond mode 802.3ad
```
sudo ip link set enp0s3 master bond0
sudo ip link set enp0s8 master bond0
```
```bash
sudo ifconfig bond0 up
```
```bnash
sudo ip link
```
```bash
sudo vim /etc/netplan/01-network-manager-all.yaml
```
# Output

network:
  version: 2
  renderer: NetworkManager

  ethernets:
    enp0s3:
      dhcp4: no
    enp0s8:
      dhcp4: no

  bonds:
      bond0:
       interfaces: [enp0s3, enp0s8]
       addresses: [192.168.2.150/24]
       routes:
            - to: default
              via: 192.168.2.1
       parameters:
            mode: active-backup
            transmit-hash-policy: layer3+4
            mii-monitor-interval: 1

       nameservers:
           addresses:
                - "8.8.8.8"
                - "192.168.2.1"

```bash
sudo ifconfig enp0s3 down
sudo ifconfig enp0s8 down
```
```bash
sudo netplan apply
```
```bash
sudo ifconfig bond0 up
ifconfig bond0 
```
```bash
sudo cat /proc/net/bonding/bond0
```
```bash
sudo ifconfig enps0s3 down
```
```bash
sudo cat /proc/net/bonding/bond0
```
```bash
sudo apt install bridge-utils
```
```bash
ip a
```
```bash
sudo vim /etc/netplan/01-network-manager-all.yaml
```
# Output
ethernets:
    enp0s3:
      dhcp4: no

  bridges:
    br0:
      dhcp4: yes
      interfaces:
        - enp0s3

```bash
sudo netplan apply
```
```bash
ip a
```
```bash
sudo nmcli con show --active
```
```bash
sudo vim /etc/netplan/01-network-manager-all.yaml
```
# Output
ethernets:
    enp0s3:
      dhcp4: true

  bridges:
    br0:
      addresses: [ 192.168.2.200/24 ]
      routes:
        - to: default
          via: 192.168.2.1
      mtu: 1500
      nameservers:
          addresses: [8.8.8.8]
      interfaces:
        - enp0s3

```bash
sudo netplan apply
```
```bash
ip a
```
```bash
ping google.com -c 4
```
