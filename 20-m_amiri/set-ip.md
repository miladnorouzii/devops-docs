# how can we set ip?


```bash 
cd /etc/netplan/
```

```bash
ls 
```
### we see 50-cloud-init.yaml
```bash
vim 50-cloud-init.yaml
```
```bash 
network:
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            dhcp4: no
            addresses:
                - 192.168.178.10/24
            gateway4: 192.168.178.1
            nameservers:
                addresses: [8.8.8.8, 1.1.1.1]
    version: 2
```
```bash
cat 50-cloud-init.yaml
```
