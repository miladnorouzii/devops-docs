ip -br a

enp0s3           UP             192.168.0.172/24 fe80::a00:27ff:fe7d:c962/64






cd /etc/sysconfig/network-scripts/
vi ifcfg-enp0s3


copy this letters


TYPE=Ethernet

PROXY_METHOD=none

BROWSER_ONLY=no

BOOTPROTO=static

#HWADDR=

DEFROUTE=yes

IPV4_FAILURE_FATAL=no
sy
NAME=enp0s3

DEVICE=enp0s3

ONBOOT=yes

IPADDR=192.168.0.30

PREFIX=24

GATEWAY=192.168.0.254

DNS1=8.8.8.8
i
DNS2=1.1.1.1


reboot os