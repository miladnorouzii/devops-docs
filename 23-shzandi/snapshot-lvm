

# create lvm 

You must take these paths:

 1.hard disk
 2.partitions
 3.physical volumes (pv)
 4.volume group(vg)
 5.logical volumes(lv)
 6.file systems


**step1 (hard disk)**

- We need to add two new hard disks to the virtual machine.
You can add a hard disk this way:

$$
Setting > hard-disk > add > new-hard-disk 

$$


- With this command you can see the status of your hard drives.

```bash
lsblk
```


**step 2 (partitions)**

- Create a new partition for the disk with this command

```bash
fdisk /dev/sdb
```
You can use these letters to create partitions, delete partitions, or print partitions

`n = new partision
`

`d = delete partition
`

`p = pirint partition
`

- Do this for the disk Sdb and sdc

**step3(pv)**

- Create a physical volume for the disks

```bash
pvcreate /dev/sdb1 /dev/sdc1
```

- You can see the status of the PV with these commands

```bash
pvdisplay
pvs
```

- To remove PV, use this command:

```bash
pvremove /dev/sdb1
```

**step4 (vg)**

- You can see the status of the vg with these commands

```bash
vgdisplay
vgs
```
- Create a group volume for the disks:


```bash
vgcreate vg-name /dev/sdb1 /dev/sdc1
```

**step 5 (lv)**


- Create a Logical volume for the disks:


```bash
lvcreate --name lv-name --size 10G /your-vg
```


- You can see the status of the lv with these commands

```bash
lvs
lvdisplay
```


**step 6 (file system)**


- Create a file system on the logical volume

```bash
mkfs.ext4 /dev/your-vg/your-lv
```

- Now you can test by mounting a file 


**mount**

- at first create directory and mount it to lv

```bash
mkdir /mnt/testlv
mount /dev/myvg/mylv /mnt/testlv
```

- With this command you can see the mount status of a directory

```bash 
df -h
```

- create some file in this dir and test the mount

```bash
touch file{1..100}
```

**take snapshot**

```bash
lvcreate --size 1G --name snap-name --snapshot /dev/myvg/mylv
```

- Modify files in the mounted directory


```bash
rm file{..100}
```

- Now you need to remove the mount directory

```bash
umount /mnt/testlv
```

- Return the snapshot

```bash
lvconvert --merge /dev/myvg/snap-name
```

- After the snapshot is restored, if you remount the directory to the LV, you will see the data inside

