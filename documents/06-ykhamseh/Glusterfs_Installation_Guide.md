# Configuring a Network File System with GlusterFS on Ubuntu

## Prerequisites
- Two or more Ubuntu 24.04 servers
- A user with sudo privileges
- Stable network connectivity between the servers

**Step 1: Installation of GlusterFS**

To start, you'll need to install GlusterFS on each of your Ubuntu servers. Open a terminal and run the following commands:

```
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:gluster/glusterfs-10
sudo apt update
sudo apt install glusterfs-server -y
```
Once installed, enable and start the GlusterFS service:

```
sudo systemctl start glusterd
sudo systemctl enable glusterd
```

**Step 2: Configuring the Trusted Storage Pool**

To form a trusted pool, you need to probe the other servers from one of the nodes.

```
sudo gluster peer probe 192.168.91.128 #[server1]
sudo gluster peer probe 192.168.91.133 #[server2]
```
Confirm that the peers are connected by listing them:

```
sudo gluster peer status
```

**Step 3: Creating a GlusterFS Volume**

The commands below demonstrates how to create a replicated volume, which provides data redundancy:

> [!NOTE] Ensure that the directories specified in the volume create command are present on both servers.

```
sudo gluster volume create gv0 replica 2 transport tcp 192.168.91.128:/data/brick1/gv0 192.168.91.133:/data/brick1/gv0 force
sudo gluster volume start gv0
```

**Step 4: Mounting the GlusterFS Volume**

On the client server, you'll need to install the GlusterFS client:

```
sudo apt install glusterfs-client -y
```
Create a mount point and mount the GlusterFS volume:

```
sudo mkdir -p /mnt/gv0
sudo mount -t glusterfs 192.168.91.128:/gv0 /mnt/gv0
```
Add the mount to the /etc/fstab to ensure it persists across reboots:

`192.168.91.128:/gv0 /mnt/gv0 glusterfs defaults,_netdev 0 0`

You have successfully configured a GlusterFS network filesystem on Ubuntu :)

## FIN ##