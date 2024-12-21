bonding in ubuntu

## step 1

install tools 

```bash 
apt install ethtool
```

## step 2
 
Go to the path to the network changes file:

`vim /etc/netplan/configure_file`

And write these changes:

```bash 


network:
  version: 2
  renderer: networkd

  ethernets:
    ens37:
      dhcp4: no
    ens38:
      dhcp4: no
    ens33:
      dhcp4: no


  bonds:
    bond0:
      interfaces: [ens33, ens37, ens38]
      addresses: [192.168.234.100/24]
      routes:
        - to: default
          via: 192.168.234.2
            #      parameters:
          #        mode: balance-rr
          #        transmit-hash-policy: layer3+4
          #        mii-monitor-interval: 100
      nameservers:
        addresses:
          - "8.8.8.8"
          - "4.2.2.4"

```
And test the changes you made with this command:

```bash

netplan try 
```

#After all these changes, remember that your network card's IP has changed and you must use SSH with IP bonding.#
