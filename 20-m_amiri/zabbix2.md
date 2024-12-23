# zabbix2.md

### Frist
```bash
sudo -s
```
### Second: Install zabbix repository
```bash
# wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu22.04_all.deb
# dpkg -i zabbix-release_latest+ubuntu22.04_all.deb
# apt update
```

### Third: Install Zabbix server, frontend, agent
```bash
# apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```

### Fourth: Install sql server
```bash
# sudo apt-get install mysql-server
# sudo systemctl start mysql
```

### Fifth: Create initial database
```bash
# sudo mysql
mysql> create database zabbix character set utf8mb4 collate utf8mb4_bin;
```
#### Important: set user and password heir, If you want a different password, write it instead of password.
```bash
mysql> create user zabbix@localhost identified by 'password';
mysql> grant all privileges on zabbix.* to zabbix@localhost;
mysql> set global log_bin_trust_function_creators = 1;
mysql> quit;
```
### Sixth: On Zabbix server host import initial schema and data. You will be prompted to enter your newly created password.
```bash
# sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
```
### Seventh: Disable log_bin_trust_function_creators option after importing database schema.
```bash 
# sudo mysql 
mysql> set global log_bin_trust_function_creators = 0;
mysql> quit;
```
### Eighth:  Configure the database for Zabbix server
```bash
# sudo vim/etc/zabbix/zabbix_server.conf
DBPassword=password
```

### Ninth: Start Zabbix server and agent processes
#### Start Zabbix server and agent processes and make it start at system boot.
```bash
# systemctl restart zabbix-server zabbix-agent apache2
# systemctl enable zabbix-server zabbix-agent apache2
```

### And finally: Open Zabbix UI web page
#### The default URL for Zabbix UI when using Apache web server is http://host/zabbix

```bash
http://192.168.73.153/zabbix.php?action=dashboard.view&dashboardid=1&clone=1
```

~meisam~~
