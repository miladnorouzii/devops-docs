#    L V M  Snapshot

```bash
sudo su -
```
```bash
lvscan
```
```bash
lvdisplay /dev/myvg/my-lv1
lvdisplay /dev/myvg/lv3
lvdisplay /dev/ubuntu-vg/ubuntu-lv
```
```bash
lvs
```
# L V M
### creating a snapshot

```bash
mkdir -p /mnt/guest
```
```bash
mount /dev/myvg/my-lv1/mnt/guest
```
# I HAD ERROR - 
```bash
sudo lvchange -ay /dev/myvg/lv3
```
```bash 
sudo file -s /dev/myvg/lv3
```
```bash
fsck /dev/myvg/lv3
```
```bash
mount /dev/myvg/lv3/mnt/guest
```
```bash
df -h
```
```bash
ls /dev/myvg/
```
```bash
mount -a
```
### Output 
total 4.0K
drwx------ 3 root root 4.0K Nov  5 15:38 snap

# ERROR IS GONE.

```bash
cd /mnt/guest
```
```bash
cp -a /etc/vim .
```
```bash
ls -lhR
```
### Output 
  .:
  total 4.0K
  drwxr-xr-x 2 root root 4.0K Nov  5 15:35 vim

  ./vim:
  total 8.0K
  -rw-r--r-- 1 root root 2.6K Aug 27 14:26 vimrc
  -rw-r--r-- 1 root root  662 Aug 27 14:26 vimrc.tiny
  root@meisam:/mnt/guest# vgs

```bash
vgs
```
```bash
lvcreate --size 6g --name sanpdemo --snapshot myvg/my-lv1
```
### Output 

Logical volume "sanpdemo" created.

```bash
lvscan
```
### Output 
ACTIVE   Snapshot '/dev/myvg/sanpdemo' [6.00 GiB] inherit

```bash
lvs
```
### Output 


  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv3       myvg      -wi-a-----   3.00g                        
  my-lv1    myvg      owi-a-s---  30.00g                        
  sanpdemo  myvg      swi-a-s---   6.00g      my-lv1 0.00       
  ubuntu-lv ubuntu-vg -wi-ao---- <19.00g  

```bash
lvdisplay myvg/my-lv1
```
### Output

  --- Logical volume ---
  LV Path                /dev/myvg/my-lv1
  LV Name                my-lv1
  VG Name                myvg
  LV UUID                zeeBHZ-s2nm-JwO0-AB0l-RbcZ-e2Tb-49ELf9
  LV Write Access        read/write
  LV Creation host, time meisam, 2024-11-14 16:57:49 +0000
  LV snapshot status     source of
                         sanpdemo [active]
  LV Status              available
  # open                 0
  LV Size                30.00 GiB
  Current LE             7680
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0

```bash
lsblk
```
### Output

NAME              MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0               7:0    0   132M  1 loop /snap/docker/2932
loop1               7:1    0  73.9M  1 loop /snap/core22/1663
loop2               7:2    0  63.7M  1 loop /snap/core20/2434
loop3               7:3    0 139.6M  1 loop /snap/docker/2963
loop4               7:4    0  70.2M  1 loop /snap/powershell/275
loop5               7:5    0  70.8M  1 loop /snap/powershell/277
loop6               7:6    0  38.8M  1 loop /snap/snapd/21759
sda                 8:0    0    40G  0 disk
├─sda1              8:1    0     1M  0 part
├─sda2              8:2    0     2G  0 part /boot
└─sda3              8:3    0    38G  0 part
  └─ubuntu--vg-ubuntu--lv
                  252:2    0    19G  0 lvm  /
sdb                 8:16   0    30G  0 disk
└─sdb1              8:17   0    10G  0 part
  └─myvg-my--lv1-real
                  252:3    0    30G  0 lvm
    ├─myvg-my--lv1
    │             252:0    0    30G  0 lvm
    └─myvg-sanpdemo
                  252:5    0    30G  0 lvm
sdc                 8:32   0    50G  0 disk
└─sdc1              8:33   0    50G  0 part
  ├─myvg-lv3      252:1    0     3G  0 lvm
  ├─myvg-my--lv1-real
  │               252:3    0    30G  0 lvm
  │ ├─myvg-my--lv1
  │ │             252:0    0    30G  0 lvm
  │ └─myvg-sanpdemo
  │               252:5    0    30G  0 lvm
  └─myvg-sanpdemo-cow
                  252:4    0     6G  0 lvm
    └─myvg-sanpdemo
                  252:5    0    30G  0 lvm
sr0                11:0    1  1024M  0 rom

```bash
mkdir /mnt/snapshot
```
```bash
mount /dev/myvg-guest/sanpdemo/mnt/snapshot
```

~meisam~~
