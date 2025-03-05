install and configure network bond in Ubuntu 24.04
1. you shuld have 2 network addapter or add second network addapter in your VM
2. To configure a permanent Network Bonding on Ubuntu, edit the Netplan YAML file under /etc/netplan/ as below
```bash
vim /etc/netplan/50-cloud-init.yaml
```
3. Edite the file
```bash
network:
    ethernets:
        ens33:
            dhcp4: no
        ens37:
            dhcp4: no
    bonds:
      bond0:
        interfaces: [ens33, ens37]
        addresses: [192.168.10.100/24]
        routes:
            - to: default
              via: 192.168.10.1
        parameters:
          mode: active-backup
          transmit-hash-policy: layer3+4
          mii-monitor-interval: 1
        nameservers:
          addresses:
            - "8.8.8.8"
            - "1.1.1.1"
    version: 2
```

4. You also use other bond types apart from active-backup(bond=1).
the other type of bonding are below:

    . mode=0: the default bonding type based on the Round-Robin policy(from the first interface to the last). It provides fault tolerance and load balancing features.

    . mode=1: it is based on the Active-Backup policy(only a single interface is active, when it fails, the other one is activated). It cas as well provide fault tolerance.

    . mode=2: This mode sets an XOR mode performing an XOR operation of the source MAC address with the destination MAC address.

    . mode=3: it is based on the broadcast policy where all packets are transmitted to all the interfaces.

    . mode=4: also known as Dynamic Link Aggregation mode. It creates aggregation groups with the same speed.

    . mode=5: also known as adaptive transmission load balancing. Here, the current load on each interface determines the distribution of the outgoing packets. The current interface receives the incoming packets, If not, it is replaced by the MAC address of another interface.

    . mode=6: also known as adaptive load balancing. The network bonding driver intercepts the ARP replies from the local device and overwrites the source address with a unique address of one of the interfaces in the bond.

5.  Save the file and stop the two interfaces.
```bash
ifconfig ens33 down
ifconfig ens37 down
```
6. Restart the network.
```bash
netplan apply
```
7. Now start the Network bond.
```bash
ifconfig bond0 up
```
8. Verify if the bond is running.
```bash
ifconfig bond0
```
9. You can also view the detailed Network bond status.
```bash
cat /proc/net/bonding/bond0
```

