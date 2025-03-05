#  creating snapshot lvm
to do this you can use the following commadn
```bash
sudo lvcreate --snapshot -L 10G -n "my_snapshot" /#your lvm path
```
and here are the explanation of the switches

 --snapshot: Flag indicating you want to create a snapshot. 

-L <size>: Specifies the size of the snapshot in desired units (e.g., "10G"). 

-n <snapshot_name>: Names your snapshot. 

<source_volume>: The path to the logical volume you want to create a snapshot
