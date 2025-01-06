#!/bin/bash

Repository=https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb
ping -c 2 8.8.8.8
sleep 2
if [ `whoami` == "root" ]; then
        echo "you are login with Root User"
        sleep 2
        systemctl restart zabbix-server
        if [ `echo $?` == 0 ]; then
	        echo "The Zabbix Server is already Installed in your System. "
        else
	        read -p "would you like Install Zabbix In your Server (y/n)? " answer
	        if [ $answer == n ]; then
		        echo "Good Lock!~ . "
	        else
		        echo "the Zabbix Install is Starting... "
		        sleep 2
                        wget $Repository
                        sleep 30
		        dpkg -i zabbix-release_latest+ubuntu24.04_all.deb
		        apt update -y
		        apt install zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y
		        apt install postgresql postgresql-contrib -y
                        echo "Now Configure DataBase Zabbix for access it. "
                        sleep 2
                        sudo -u postgres createuser --pwprompt zabbix
                        sudo -u postgres createdb -O zabbix zabbix
                        zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
                        echo "Edit Zabbix Config File for DBPassword. "
                        sleep 2
                        read -s -p "Enter your DataBase Password: " password
                        sed -i "s/# DBPassword=/DBPassword=$password/g" /etc/zabbix/zabbix_server.conf
                        systemctl restart zabbix-server zabbix-agent apache2
                        systemctl enable zabbix-server zabbix-agent apache2
                        echo "The Zabbix Installation is Finish. "
                        sleep 2
                        read -p "would you like Access to WEB for Complete Configuration Zabbix (n/y)? " answer2
                        if [ $answer2 == y ]; then
                                ip -br a
                                echo "Open Browser and Enter IP_Address/zabbix and ... "
                        else
                                echo "Complete Configuratio in Next Time. "
                                echo "Good Lock!~ . "
                        fi
                fi
        fi	
else
        echo "You must Login Root User with "sudo su""
fi