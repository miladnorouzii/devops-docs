# Install and configure Zabbix for
first of all we need add zabbix repository and to do that we run this command
``` bash
 wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb
 dpkg -i zabbix-release_latest+ubuntu24.04_all.deb
 apt update
 ```

 then we need to install the following package 
 ``` bash
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```
after this step we must install database in this case i install mysql
```bash
apt install mysql-server
```
## Run the following on your database host for configuration

mysql -uroot -p

password

mysql> create database zabbix character set utf8mb4 collate utf8mb4_bin;

mysql> create user zabbix@localhost identified by 'password';

mysql> grant all privileges on zabbix.* to zabbix@localhost;

mysql> set global log_bin_trust_function_creators = 1;

mysql> quit;


### then run
 zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix 

 and enter password

### Disable log_bin_trust_function_creators option after importing database schema.
 mysql -uroot -p

password

mysql> set global log_bin_trust_function_creators = 0;

mysql> quit;
 
 after all these you need to change DBpassword=password in  /etc/zabbix/zabbix_server.conf
 ``` bash
 vim  /etc/zabbix/zabbix_server.conf
 ```
### Start Zabbix server and agent processes
``` bash
 systemctl restart zabbix-server zabbix-agent apache2
 systemctl enable zabbix-server zabbix-agent apache2
```
### Open Zabbix UI web page
The default URL for Zabbix UI when using Apache web server is http://host/zabbix

done.

