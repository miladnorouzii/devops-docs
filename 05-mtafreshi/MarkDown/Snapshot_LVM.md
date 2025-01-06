# Create and Snapshot LVM and Restore
## 1. Create LVM
### 1-1. Create LVM (Partition)
##### Mount Phisycal Hard Drives
##### lsblk
##### fdisk /dev/sd* (for each HDD)
##### Create New Partition (n)
##### Select Primary Partition (p)
##### Select Sector / Size / ... (Enter)
##### Select Type Partition (t)
##### Select Linux_LVM (8E)
##### Save Modify (W)
### 1-2. Create Physical Volume
##### pvcreate /dev/sd*1 (for each Partition)
##### vgcreate "myvg_Name" /dev/sd*1
##### lvcreate --name "mylv_Name" --size "size(M,G,T)" "myvg_Name"
##### mkfs."Format" /dev/"myvg_Name"/"mylv_Name"
### 1-3. Create Directory Point for mount LVM_Volume
##### mkdir /"Path"/"Directory_Name"
##### mount /dev/"myvg_Name"/"mylv_Name" /"Path"/"Directory_Name"
### 1-4. Create or Copy File in Logical Volume
## 2. Create Snapshot
### 2-1. Create LVM Snapshot
##### lvcreate -s -n "Snapshot_Name" -L "size(M,G,T)" /dev/"myvg_Name"/"mylv_Name"
##### or
##### lvcreate --size "size(M,G,T)" --snapshot --name "Sanapshot_Name" /dev/"myvg_Name"/"mylv_Name"
###### Important: Snapshot size must be enough Space to back up file.
######            if Lower than Logical Volume Space or increase
######            Directory size, The Snapshot Unavable for Restore.
###### Note: You can Auto Extend by Edit /etc/lvm/lvm.conf by VIM
######       Editor and Search autoextend in File and Change
######       "snapshot_autoextend_threshold = 100 to 70" and
######       "snapshot_autoextend_percent = 20" (uncomment) or
######       manually Extend size File for Logical Volume Snapshot.
## 3. Restore Snapshot
### 3-1. unmount Directory
##### umount /"Path"/"Directory_Name"
### 3-2. Restore
##### lvconvert --merge /dev/"myvg_Name"/"Snapshot_Name"
###### Note: if do not unmount Directory in 3-1 you must use:
###### lvchange -a n /dev/"myvg_Name"/"mylv_Name"
###### lvchange -a y /dev/"myvg_Name"/"mylv_Name"
# Done.