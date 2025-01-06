#!/bin/bash

read -p "Enter Master Server IP Address: " master
read -p "Enter Master Server Host Name: " masterhost
read -p "Enter Slave Server IP Address: " slave
read -p "Enter slave Server Host Name: " slavehost
ping -c 2 8.8.8.8
sleep 2
if [ `whoami` == "root" ]; then
    echo "you are login with Root User"
    echo ${master} ${masterhost} >> /etc/hosts
    echo ${slave} ${slavehost} >> /etc/hosts
    echo 10.202.10.202 >> /etc/hosts
    echo 10.202.10.102 >> /etc/hosts
    sleep 2
    echo "*** Recommended: ***"
    echo "____________________"
    echo "You have to create LVM in your Machine and after that try to install Posgresql"
    sleep 5
    sudo systemctl restart postgresql
    if [ `echo $?` == 0 ]; then
        echo "The Postgresql Server is already Installed in your System. "
        read -p "Would you like Configure Master/Slave HA in Postgres? (y/n)" answer1
        if [ $answer1 == n]; then
            echo "Good Lock!~."
        else
            systemctl stop postgresql
            sudo -u postgres cp -R /var/lib/postgresql/16/main/ /var/lib/postgresql/16/main_old/
            rm -rf /var/lib/postgresql/16/main/
            sudo -u postgres pg_basebackup -h ${masterhost} -D /var/lib/postgresql/16/main/ -U replica -P -v -R -X stream -C -S slaveslot1
            systemctl start postgresql
            echo "Done!~ ."
            sleep 2
            echo "You can try to Create Database in Master Server and Show Result in Slave Server. "
        fi 
    else
        read -p "Would you like Install Postgresql In your Server (y/n)? " answer
        if [ $answer == n ]; then
            echo "Good Lock!~ . "
        else
            echo "The Postgresql Install is Starting... "
            sleep 2
            apt update
            apt install postgresql postgresql-contrib -y
            systemctl stop postgresql
            sudo -u postgres cp -R /var/lib/postgresql/16/main/ /var/lib/postgresql/16/main_old/
            rm -rf /var/lib/postgresql/16/main/
            sudo -u postgres pg_basebackup -h ${masterhost} -D /var/lib/postgresql/16/main/ -U replica -P -v -R -X stream -C -S slaveslot1
            systemctl start postgresql
            echo "Done!~ ."
            sleep 2
            echo "You can try to Create Database in Master Server and Show Result in Slave Server. "    
        fi
    fi
else
    echo "Please Login "root" User and Run Script Agein."
fi