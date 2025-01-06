## Partitioning and  implementing mariadb on server3
- **add new disk and view Lists all disks and their partitions**
    ```bash
    fdisk -l
    ```
- **Here’s the workflow for creating sdb1 and sdb2 with fdisk and using them together with LVM**

- **Initialize Physical Volumes (PV)**
    ```bash
     pvcreate /dev/sdb1 /dev/sdb2
    ```
- **Create a Volume Group (VG)**
    ```bash
    vgcreate my_vg /dev/sdb1 /dev/sdb2
    ```
- **Create a Logical Volume (LV)**
    ```bash
    lvcreate -L 20G -n my_lv my_vg
     ```
- **lvcreate -L 20G -n my_lv my_vg**
   ```bash
    lvcreate -L 20G -n my_lv my_vg
   ```
 - **Format and Mount the Logical Volume**
    ```bash
    mkfs.ext4 /dev/my_vg/my_lv
    ```  
- **Mount the Logical Volume**
    ```bash
    mkdir /mnt/my_data
    mount /dev/my_vg/my_lv /mnt/my_data
    ```
- **Add to fstab for Automatic Mounting: Edit `/etc/etc/fstab and add the following line**    
    ```bash
    /dev/my_vg/my_lv /mnt/my_data ext4 defaults 0 0
    ```
- **Check LVM Status**    
    ```bash
    lvs
    ```
- **Install MariaDB**    
    ```bash
    sudo apt update
    sudo apt install mariadb-server
    ```    

- **Edit the MariaDB configuration file to allow external connections**    
    ```bash
    sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
    ```     
- **Change the bind-address to 0.0.0.0 to allow connections from any IP**    
    ```bash
    bind-address = 0.0.0.0
    ```
- **Restart MariaDB to apply the changes**    
    ```bash
    sudo systemctl restart mariadb
- **Create a database and user for WordPress**    
    ```bash
    sudo mysql -u root -p
    ```
- **Create a WordPress database and create a user and grant it permissions**    
    ```bash
    CREATE USER 'pmke'@'%' IDENTIFIED BY '1qaz!QAZ';
    GRANT ALL PRIVILEGES ON wordpress_db.* TO 'pmke'@'%';
    FLUSH PRIVILEGES;
    EXIT;
    ```           
- **Ensure the MariaDB server is accessible from the WordPress server: From the WordPress server, try to connect to MariaDB**    
    ```bash
    mysql -h 192.168.112.156 -u pmke -p
    ``` 