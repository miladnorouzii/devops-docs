# Enable-Disable Ethernet in Ubuntu

## Find Network Disable
## Remember Logical Network Name
### sudo lshw -c network

## Enable Ethernet
### sudo ip link set dev ens37 up

## Restart Network Service
### sudo systemctl restart systemd-networkd

## Go to this Path
### cd /etc/netplan

## Configure Ethernet File
### (First dhcp4: true then dhcp4: no)
#### Manual Config:
#### adresses:
####     - IP ADDRESS:
#### gateway4: IP GATEWAY
#### nameservers:
####     adresses: [DNS1, DNS2]  