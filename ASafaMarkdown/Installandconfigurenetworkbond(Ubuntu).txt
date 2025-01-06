sudo apt update
sudo apt install ifenslave

cd /etc/netplan

sudo nano <your-config>.yaml

network:
  version: 2
  renderer: networkd
  bonds:
    bond0:
      interfaces:
        - eth0
        - eth1
      parameters:
        mode: balance-rr
        primary: eth0
        mii-monitor-interval: 100
      dhcp4: true

sudo netplan apply

cat /proc/net/bonding/bond0

dmesg | grep bonding

ip a

ip link show

