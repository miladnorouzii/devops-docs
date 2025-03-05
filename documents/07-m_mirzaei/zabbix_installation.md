# Install Zabbix 7 on Ubunto server 24.04
```bash
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu24.04_all.deb
```
```bash
$ sudo dpkg -i zabbix-release_7.0-1+ubuntu24.04_all.deb
```
```bash
$ sudo apt update
```
```bash
$ sudo apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf 
zabbix-sql-scripts zabbix-agent2 php-mysql php-gd php-bcmath php-net-socket
```

# Install mysql as Database 
``` bash
$ sudo apt -y install mysql-server-8.0
```
```bash
# mysql
```
```bash
> create database zabbix character set utf8mb4 collate utf8mb4_bin; 
Query OK, 1 row affected (0.00 sec)
```
mysql> create user 'zabbix'@'localhost' identified by '123456';
Query OK, 0 rows affected (0.13 sec)
```bash
mysql> grant all privileges on zabbix.* to zabbix@'localhost' with grant option;
Query OK, 0 rows affected (0.05 sec)
```
```bash
> exit
```
```bash
# zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p zabbix
Enter password:   # the password you set above for [zabbix] user
```
```bash
# vim /etc/zabbix/zabbix_server.conf
 line 107 : confirm DB name
DBName=zabbix
 line 123 : confirm DB username
DBUser=zabbix
 line 132 : add DB user's password
DBPassword=password
```
```bash
systemctl restart zabbix-server
systemctl enable zabbix-server
```
# Install zabbix Agent 
```bash
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu24.04_all.deb
```
```bash
$ sudo dpkg -i zabbix-release_7.0-1+ubuntu24.04_all.deb
```
# Configure and start Zabbix Agent to monitor Zabbix Server
```bash
vi /etc/zabbix/zabbix_agent2.conf
# line 80 : specify Zabbix server
Server=IP of zabbix server
# line 133 : specify Zabbix server
ServerActive=IP of zabbix server
# line 144 : change to your hostname
Hostname=hostname of zabbix server
```
```bash
systemctl restart zabbix-agent2

```