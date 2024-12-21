
#bash script of install and configure zabbix server

#!/bin/bash

echo "update your apt.."

apt update


echo "get repository ..."

wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb



echo "install pkg zabbix ..."

dpkg -i zabbix-release_latest+ubuntu24.04_all.deb
apt update



echo "get zabbix server and all dependencies..."

apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts mariadb-server -y



echo "now create database.."

mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
mysql -e "create user zabbix@localhost identified by 'zabbix';"
mysql -e "grant all privileges on zabbix.* to zabbix@localhost;"
mysql -e "set global log_bin_trust_function_creators = 1;"



echo "Loading initial schema and data into the database..."
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql--default-character-set=utf8mb4 -uzabbix -p zabbix



echo "Configuring Zabbix server..."

sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf



echo "restart zabbix server .."

systemctl restart zabbix-server  apache2

systemctl enable zabbix-server  apache2

