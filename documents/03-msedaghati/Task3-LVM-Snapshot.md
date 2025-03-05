1. Add extra 2G HDD to the server
2. use 'fdisk' for make primary and extended partitions on it
```bash
fdisk /dev/sdb
```
3. Make physical partition
```bash
pvcreate /dev/sdb1
```
4. Make Voloum Group
```bash
vgcreate aminvg1 /dev/adb1
```
5. Make Logical Grpoup
```bash
lvcreate --name aminlv1 --size 500M amingv1
```
6. Make file system 
```bash 
mkfs.ex4 /dev/aminvg/aminlv
```
7. Mount to Directory
```bash
mkdir /mnt/lvmdir1
mount /dev/aminvg/aminlv /mnt/lvmdir1/
```
8. Make Snapshot
```bash
lvcreate -s -n aminsnap -L 2M aminvg1/aminlv1
```
9. Mount Snaoshot
```bash
mkdir /mnt/snapshot
mount /dev/aminvg1/aminsnap /mnt/snapshot
```
10. See the Result
```bash
lvs
lsblk
```
11. Backing Up Snapshot
```bash
tar -cvzf backup.tar.gz /mnt/snapshot
```
12. Restoring Snapshot
```bash
lvconvert --mergesnapshot aminvg1/aminlv1
lvchange --refresh aminvg1/aminlv1
```