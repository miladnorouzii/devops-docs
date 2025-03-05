# GlusterFS

## step1 : add hosts to all machines
```bash
sudo nano /etc/hosts

192.168.1.37  server0.com    gluster1
192.168.1.34  server1.com    gluster2
192.168.1.38  client0.com    gluster0

## Setting Up Software Sources on Each Machine
sudo add-apt-repository ppa:gluster/glusterfs-7
sudo apt update


#  Installing Server Components and Creating a Trusted Storage Pool
sudo apt install glusterfs-server
sudo systemctl start glusterd.service
sudo systemctl enable glusterd.service
sudo systemctl status glusterd.service


# access to each server for firewall
# run on server1
sudo ufw allow from 192.168.1.37 to any port 24007
# run on server0
sudo ufw allow from 192.168.1.34 to any port 24007
sudo ufw deny 24007
run on server0 and server1
sudo ufw allow from 192.168.1.38 to any port 49152
sudo ufw deny 49152

# check each gluster status
sudo gluster peer probe gluster1
sudo gluster peer status

sudo gluster volume create volume1 replica 2  server0.com:/etc/storage  sever1.com:/etc/gluster-storage force
sudo gluster volume start volume1

# client
sudo apt install glusterfs-client
sudo mkdir /storage-pool
sudo mount -t glusterfs server0.com:/volume1 /storage-pool
```
