1. find your os version
```bash
cat /etc/os-release
```
this document written for Ubuntu OS Versio:24.04(Noble), Zabbix Component:Server,frontend,agent ,Database:MySQL, WEB Server: Apache

2. install repository
```bash
sudo su -
 wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb
 dpkg -i zabbix-release_latest+ubuntu24.04_all.deb
 apt update
 ```
3. install Zabbix server,front end,agent
```bash
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```
4. create database 
```bash
mysql -uroot -p
1234
mysql> create database zabbix character set utf8mb4 collate utf8mb4_bin;
mysql> create user zabbix@localhost identified by '1234';
mysql> grant all privileges on zabbix.* to zabbix@localhost;
mysql> set global log_bin_trust_function_creators = 1;
mysql> quit;
```
5. import initial schema and data
```bash
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix 
```
6. Disable log_bin_trust_function_creators option after importing database schema
```bash
mysql -uroot -p
1234
mysql> set global log_bin_trust_function_creators = 0;
mysql> quit;
```
7. Edit file /etc/zabbix/zabbix_server.conf
DBPassword=1234

8. Start Zabbix server and agent processes and make it start at system boot
```bash
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
```
9. find your ip address
```bash
ip -br a
```
10. The default URL for Zabbix UI when using Apache web server is http://your-ip-address/zabbix
11. after config your server you can login with user:Admin and Password:zabbix


