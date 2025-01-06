#!/bin/bash
#
echo "###################### Install Repository #############################"
 sleep 1
 wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb
 dpkg -i zabbix-release_latest+ubuntu24.04_all.deb
 apt update
 sleep 5
 echo "#################### Install MariaDB #################################"
 sleep 2
 apt install mariadb-server
 sleep 2
 echo "#################### install Zabbix server and client ################"
 sleep 1
 apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
 sleep 2
 echo "#################### Create Database ################################# "
 sleep 5
 mysql -uroot -p  -Bse "create database zabbix character set utf8mb4 collate utf8mb4_bin; create user zabbix@localhost identified by'1234'; grant all privileges on zabbix.* to zabbix@localhost; set global log_bin_trust_function_creators = 1; quit;"
sleep 5
echo "#################### Import Initial Schema and Data##################"
sleep 5
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
sleep 5
echo "#################### Some thing ##################################### "
sleep 5
mysql -uroot -p -Bse "set global log_bin_trust_function_creators = 0; quit;"
sleep 5
echo "################### Start Zabbix server and agent ###################"
sleep 5
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
sleep 5
ip -br a
echo "##### The default URL for Zabbix UI when using Apache web server is http://your-ip-address/zabbix #####"
echo "##### user:Admin and Password:zabbix #####"
echo "#################### please edit /etc/zabbix/zabbix_srver.conf   and change DBPassword=1234 ############ "
