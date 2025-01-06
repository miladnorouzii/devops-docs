# LVM Create, Snapshots Backup and Restore on Linux

**Creating Physical Volumes**

To create physical volumes on top of `/dev/sdb`, `/dev/sdc`, and `/dev/sdd`, do:

```
sudo pvcreate /dev/sdb /dev/sdc /dev/sdd
```
You can list the newly created PVs with:

```
sudo pvdisplay
```
OR
```
sudo pvs
```


**Creating Volume Groups**

```
sudo vgcreate myVG /dev/sdb /dev/sdc
```
As it was the case with physical volumes, you can also view information about this volume group by issuing:

```
sudo vgdisplay
```
OR
```
sudo vgs
```


**Creating Logical Volumes**

Let’s create LV named `myLV`

```
sudo lvcreate -n myLV -L 2G myVG
```
As before, you can view the list of LVs and basic information with:

```
sudo lvdisplay
```
OR
```
sudo lvs
```
Also you can make your favorite file system on it by:

```
sudo mkfs.ext4 /dev/myVG/myLV
```

**LVM snapshots**

###### Prerequisites

In order to create LVM snapshots, you obviously need to have at least a logical volume created on your system.

Run the command below in order to display existing logical volumes.

```
sudo lvmdiskscan
```
To check the actual size of your logical volume, you can check your used disk space using the “df” command.


```
df -h
```

**Creating LVM Snapshot**

In order to create a LVM snapshot of a logical volume, you have to execute the “lvcreate” command with the “-s” option for “snapshot”, the “-L” option with the size and the name of the logical volume.

Optionally, you can specify a name for your snapshot with the “-n” option.

```
sudo lvcreate -L 1GB -s -n snap /dev/myVG/myLV
```

Now that your snapshot is created, you can inspect it by running the command:

```
sudo lvdisplay
```

**Mounting LVM Snapshot Using Mount**

In order to mount a LVM snapshot, you have to use the “mount” command, specify the full path to the logical volume and specify the mount point to be used.

```
sudo mount /dev/myVG/myLV /mnt/snapshop/
```
You can immediately verify that the mounting operating is effective by running the command:

```
lsblk
```


**Restoring Snapshot or Merging**

In order to restore a LVM logical volume, you have to use the “lvconvert” command with the “–mergesnapshot” option and specify the name of the logical volume snapshot.

> [!NOTE] First You have to Unmount the Directory.

```
sudo umount /mnt/snapshop/
```
```
sudo lvconvert --mergesnapshot /dev/myVG/snap
```
Alternatively, you can refresh the logical volume for it to reactivate using the latest metadata using:

```
sudo lvchange --refresh /dev/myVG/myLV
```
After the merging operation has succeeded, you can verify that your logical volume was successfully removed from the list of logical volumes available.

```
sudo lvdisplay
```

**Done!**






