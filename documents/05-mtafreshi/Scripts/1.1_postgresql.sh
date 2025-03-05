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
    echo "You have to create LVM in youe Machine and after that try to install Posgresql"
    sleep 5
        systemctl restart postgresql
    if [ `echo $?` == 0 ]; then
	    echo "The Postgresql Server is already Installed in your System. "
        read -p "Would you like Configure Master/Slave HA in Postgres? (y/n) " answer1
        if [ $answer1 == n ]; then
            read -p "Enter Username on Slave Server: " name
            ssh-keygen
            ssh-copy-id ${name}@${slavehost}
            sleep 2
            rsync ./rpostgresql.sh ${name}@${slavehost}:/home/${name}
            echo "So, Connect to Slave Server."
            echo "Good Lock!~."
            sleep 2
            ssh ${name}@${slavehost}
        else
            sed -i "s/#listen_addresses = 'localhost'/listen_addresses = "${masterhost}"/g" /etc/postgresql/16/main/postgresql.conf
            echo "Please Enter Password for Complete Create User."
            sudo -u postgres createuser --replication -P replica
            echo "host    replication     replica         "${slavehost}"                md5" >> /etc/postgresql/16/main/pg_hba.conf
            sudo systemctl restart postgresql
            read -p "Enter Username on Slave Server: " name
            ssh-keygen
            ssh-copy-id ${name}@${slavehost}
            sleep 2
            rsync ./rpostgresql.sh ${name}@${slavehost}:/home/${name}
            echo "So, Connect to Slave Server."
            echo "Good Lock!~."
            sleep 2
            ssh ${name}@${slavehost}
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
            sed -i "s/#listen_addresses = 'localhost'/listen_addresses = "${masterhost}"/g" /etc/postgresql/16/main/postgresql.conf
            echo "Please Enter Password for Complete Create User."
            sudo -u postgres createuser --replication -P replica
            echo "host    replication     replica         "${slavehost}"                md5" >> /etc/postgresql/16/main/pg_hba.conf
            sudo systemctl restart postgresql
            read -p "Enter Username on Slave Server: " name
            sleep 2
            ssh-keygen
            ssh-copy-id ${name}@${slavehost}
            sleep 2
            rsync ./rpostgresql.sh ${name}@${slavehost}:/home/${name}
            echo "So, Connect to Slave Server."
            echo "Good Lock!~."
            sleep 2
            ssh ${name}@${slavehost}
        fi
    fi
fi