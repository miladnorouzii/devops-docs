
# Glusterfs - gluster Protocol
## 1. Create LVM (for 2 Servers)
### 1-1. Create LVM (Partition)
##### Mount Phisycal Hard Drives (3 HDD)
##### lsblk
##### fdisk /dev/sd* (3 HDD)
##### Create New Partition (n)
##### Select Primary Partition (p)
##### Select Sector / Size / ... (Enter)
##### Select Type Partition (t)
##### Select Linux_LVM (8E)
##### Save Modify (W)
### 1-2. Create Physical Volume
##### pvcreate /dev/sd*1 (for 3 Partitions)
##### vgcreate "myvg_Name" /dev/sd*1 (for each Partition) - (3 Partition)
##### lvcreate --name "mylv_Name" --size "size(M,G,T)" "myvg_Name"
##### lvextend -l +100%FREE /dev/"gv_Name"/"lv_Name" (used 100% LVM Space)
##### resize2fs /dev/"gv_Name"/"lv_Name"
##### mkfs.xfs /dev/"myvg_Name"/"mylv_Name"
##### blkid (Copy "uuid" for LVM)
### 1-3. Create Directory Point for mount LVM_Volume (permanent)
##### mkdir /glusterfs/distributed
##### vim /etc/fstab
##### /dev/disk/by-uuid/"uuid" /glusterfs/distributed xfs defaults 0 1 (Write modify)
##### mount -a
## 2. Install Glusterfs Server and Configure (for 2 Servers)
##### apt update && apt upgrade -y
##### apt install glusterfs-server -y
##### systemctl enable --now glusterd
##### gluster --version
##### mkdir /glusterfs/distributed/store
##### gluster peer probe "IP_Server-2" (in Primary Server "Server-1")
###### (Auto Configure in Server-2)
##### gluster peer status
##### gluster volume create vol_distributed transport tcp \ "IP_Server-1":/glusterfs/distributed/store \ "IP_Server-2":/glusterfs/distributed/store
##### gluster volume start vol_distributed
##### gluster volume info
## 3. Install Gluster Client and Configure
##### apt install glusterfs-client -y
##### mount -t glusterfs "IP_Server-1":/vol_distributed /mnt
##### df -hT ((Server-1 >> 60G LVM Space Show and Server-2 >> 60G LVM Space Show >> in Client 120G Space Show after mounting Share Path))
##### vim /etc/fstab
##### "IP_Server-1":/vol_distributed /mnt glusterfs defaults 0 1
##### mount -a
##### touch testfile.txt
##### vim testfile.txt
##### insert Custom Text and save
###### (in Server-1 file Replicate and you can Show it)
## Done.