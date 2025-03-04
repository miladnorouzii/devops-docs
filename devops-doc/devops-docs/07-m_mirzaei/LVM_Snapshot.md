we have 3 physical volume like /dev/sdb1 /dev/sdb2 /dev/sdc 
and 2 volume group such vg1 and vg2
and logical volume named d1 and d2
now we create disk space of storage with command lvcreate 
bash ```
sudo lvcreate --name d1 --size 5g vg2
```
and after assigning filesystem mount the volume that we want to take snapshot of
make sure have free space 
bash ```
sudo lvcreate --size 5g --name snapdemo --snapshot /dev/vg2/d2
sudo mkdir /mnt/snapshot
sudo mount /dev/vg2/snapdemo /mnt/snapshot

sudo umount /mnt/snapshot
we modify original volume 
