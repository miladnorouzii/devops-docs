# GlusterFS #

#GlusterFS is an open-source, distributed file system that allows you to pool storage across multiple servers and access it as a single, unified file system. It was designed to handle large amounts of unstructured data, and is often used for scaling storage horizontally, providing high availability, and enabling performance improvements.

#prerequisites:
#- two or more servers.
#- root or sudo access on the servers.
#- glusterFS must be installed on all servers.

## step 1 ##

#we need lvm for 2 server and mount point.

#Complete the steps to create LVM and mount the folder on Server 1 and 2.

## step 2 ##

#use these commands to update the system and install gluster on both servers:


apt update
apt install glusterfs-server -y


## step 3 ##

#start and enable gluster:


sudo systemctl start glusterd
sudo systemctl enable glusterd


## step 4 ##

#Create a directory in the mounted directory:


mkdir /mnt/mounted-dir/brick

#To make mount permanent, write this text in this path:

`/dev/your-vg/your-lv  /mnt/gluster/ xfs default 0 0`


vim /etc/fstab

or

echo '/dev/your-vg/your-lv /mnt/gluster xfs defaults 0 0' | sudo tee -a /etc/fstab


## step 5 ##

#use this command to connect Gluster to the second server:


gluster peer probe <ip server2> 


From "server2"


gluster peer probe <ip server1> 


## step 6 ##

#Now create a new volume that points to your LVM.
#This command will create a new volume called (glusterv) :


#gluster volume create glusterv replica 2 transport tcp ip server1:/mnt/gluster/brick IP server2:/mnt/gluster/brick


## step 7 ##

#start or stop gluster :


gluster volume start glusterv



gluster volume stop glusterv


with these commands you can get status and more information about gluster:


gluster volume info



gluster volume status


