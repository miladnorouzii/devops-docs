#!/bin/bash

dev=/dev/
mount=/dev/myvg/mylv
path=/var/lib/mysql
file=./host_config
hosts=/etc/hosts

check_root ()
{
    if [ `whoami` == "root" ]; then
        echo "you are login with Root User"
    else
        echo "Please Login "root" User and Run Script Agein." 
        exit 1
    fi
}

read_m_s ()
{
    read -p "Enter DataBase Server IP Address: " db
    read -p "Enter DataBase Server Host Name: " dbhost
    read -p "Enter Wordpress Server IP Address: " web
    read -p "Enter Wordpress Server Host Name: " webhost
    read -p "Enter Nginx Server IP Address: " nginx
    read -p "Enter Nginx Server Host Name: " nginxhost
}

input ()
{
    echo ${db} ${dbhost} >> ${hosts}
    echo ${web} ${webhost} >> ${hosts}
    echo ${nginx} ${nginxhost} >> ${hosts}
    echo ${web} ${webhost} > ${file}
    echo ${nginx} ${nginxhost} >> ${file}
    echo ${db} ${dbhost} >> ${file}
}

ssh_keygen ()
{
    ssh-keygen
    ssh-copy-id ${webname}@${webhost}
    ssh-copy-id ${nginxname}@${nginx}
}

LVM ()
{
    dev=/dev/
    mount=/dev/myvg/mylv
    echo "Recomended You Have to 3 Disk for Create LVM. :) !~ "
    sudo lsblk
    read -p "How many Disk to Create Partition? " num
    for (( i=1; i<=${num}; i++ ));
        do
            read -p "Select HDD Name: (Example: sdb)" blk
            (echo n; echo p; echo ""; echo ""; echo ""; echo t; echo 8E; echo w) | fdisk /dev/${blk}
            echo ''${blk}''1'' > file"${i}"
            echo ''${dev}''${blk}''1'' >> file
            lsblk
        done
    paste -s -d " " file > row
    pvcreate `cat row`
    vgcreate myvg `cat row`
    vgdisplay myvg | grep -i "vg size" | awk '{print $3}' > size
    sed -i 's/<//g' size
    sed -i 's/.99//g' size
    vgdisplay myvg | grep -i "vg size" | awk '{print $4}' > size1
    sed -i 's/iB//g' size1
    lvcreate --name mylv --size `cat size``cat size1` myvg
    mkfs.ext4 ${mount}
    lsblk
    sleep 5
    rm size size1 row file file{1..3}
}

install_mariadb ()
{
    path=/var/lib/mysql
    maria=/etc/mysql/mariadb.conf.d/50-server.cnf
    mkdir -p ${path}
    blkid ${mount} | awk '{print $2}' > uuid
    sed -i 's/UUID="//g' uuid
    sed -i 's/"//g' uuid
    echo "/dev/disk/by-uuid/`cat uuid`  ${path}  ext4    defaults 0 1" >> /etc/fstab
    mount -a
    if [ `echo $?` == 0 ]; then
        sudo apt update
        sudo apt install mariadb-server iptables-persistent -y
        sudo -u root sed -i 's/127.0.0.1/'${db}'/g' ${maria}
        systemctl restart mariadb
        sudo mysql -u root <<MYSQL
        CREATE DATABASE wordpress;
        CREATE USER wordpress@'%' IDENTIFIED BY '123456';
        GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO 'wordpress'@'%';
        FLUSH PRIVILEGES;
        quit
MYSQL
    else
        echo "Check your Mount Point. "
        exit 1
    fi
    df -h
    sleep 5
    rm uuid
}

SSH_wordpress ()
{
    rsync ${file} ${webname}@${webhost}:/home/${webname}
    rsync ./wordpress.sh ${webname}@${webhost}:/home/${webname}
    ssh -T -t ${webname}@${webhost}
}

SSH_nginx ()
{
    rsync ${file} ${nginxname}@${nginx}:/home/${nginxname}
    rsync ./nginx.sh ${nginxname}@${nginx}:/home/${nginxname}
    ssh -T -t ${nginxname}@${nginx}
}

iptable ()
{
    file=./host_config
    tail -n 1 ${file} | awk '{print $1}' > db
    head -n 1 ${file} | awk '{print $1}' > web
    iptables -A INPUT -d `cat db` -p TCP --dport 22 -j ACCEPT
    iptables -A INPUT -d `cat db` -p TCP --sport 22 -j ACCEPT
    iptables -A INPUT -s `cat web` -d `cat db` -p TCP --dport 3306 -j ACCEPT
    iptables -A OUTPUT -s `cat db` -p TCP --sport 22 -j ACCEPT
    iptables -A OUTPUT -s `cat db` -p TCP --dport 22 -j ACCEPT
    iptables -A OUTPUT -s `cat db` -d `cat web` -p TCP --sport 3306 -j ACCEPT
    iptables -nvL
    sleep 5
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -nvL
    sleep 5
    iptables-save > /etc/iptables/rules.v4
}

main ()
{
    check_root
    read_m_s
    input
    LVM
    install_mariadb
    iptable
    read -p "Enter Wordpress Server Username: " webname
    read -p "Enter Nginx Server Username: " nginxname
    ssh_keygen
    SSH_wordpress
    SSH_nginx
    echo ""
    echo ""
    echo ""
    echo "                             *"
    echo "                            ***"
    echo "                         *********"
    echo "                      ***************"
    echo "                   *********************"
    echo "                ***************************"
    echo "             *********************************"
    echo "          ***************************************"
    echo "          Now Open Browser and Login to Wordpress"
    echo "          ======================================="
    echo "                     ================="
    echo "                        ==========="
    echo "                           ====="
    echo "                            ==="
    echo "                             ="
    echo ""
    echo "                      IP Address is: "
    echo "                      ______________"
    echo ""
    echo "                     http://${nginxhost}/proxy"

}
main
# Reference:
# https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview