 Requirement:

. 3 Ubuntu Server (Ubuntu 22.04)

 Server1(192.168.1.140)

 Server2(192.168.1.141)

 Server3(192.168.1.142)

 . 1G extra HDD for each server (/sdb)

. Cummunicate all serve with eachother 

1. Prepar the Servers

  For all 3 servers

. Make primary partition with 'fdisk', for extar HDD (dev/sdb1) and after that :

```bash
mkfs.xfs -i size=512 /dev/sdb1
mkdir -p /data/brick1
echo '/dev/sdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
mount -a && mount
```

 For all 3 servers

```bash
apt update
apt install -y glusterfs-server glusterfs-client
```

For all 3 servers

Change the IP address as above and edit the /etc/hosts with new informatios

```bash
127.0.0.1 localhost
127.0.1.1 server1
192.168.1.141 server2
192.168.1.142 server3
```
make sur all server can ping eachoter

2. Start the Glusterfs and check the status
 ```bash
 service glusterd start
 service glusterd status
 ```
3. link the servers (For all 3 servers)

on server1
```bash
gluster peer probe 192.168.1.141
gluster peer probe 192.168.1.142
```
on server2,3
```bash
gluster peer probe 192.168.1.140
```
4. Cheack the peer status on server1
```bash
gluster peer status
```
You should see the host name and UUID

5. Make GlusterFS volume
   
   For all 3 Servers

```bash
mkdir -p /data/brick1/gv0
gluster volume create gv0 replica 3 192.168.1.140:/data/brick1/gv0 192.168.1.141:/data/brick1/gv0 192.168.1.142:/data/brick1/gv0
```
6. Start the net volume

```bash
gluster volume start gv0
```
You should see 'volume start: gv0: success'

7. Cheack the GlusterFS
   
```bash
gluster volume info
```


