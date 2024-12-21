# zabix

## step 1 
install zabbix repository

``` bash
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb

dpkg -i zabbix-release_latest+ubuntu24.04_all.deb

apt update 

apt upgrade -y
```
## step 2

install zabbix server and dependencies

``` bash
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts
```
## step 3

create database 

```bash
mysql -uroot -p
 -create database zabbix character set utf8mb4 collate utf8mb4_bin;
 -create user zabbix@localhost identified by 'password';
 -grant all privileges on zabbix.* to zabbix@localhost;
 -set global log_bin_trust_function_creators = 1;
 -quit;
 ```

## step 4

Set the database password of Zabix server (This is the password you created when creating the database)

```bash
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
```

## step 5

configure the database on this path /etc/zabbix/zabbix_server.conf
 
 ```bash 
vim
DBPassword=password
```
## step 6

start zabbix server and web server 

```bash 
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
```

Finally, enter Zabix by entering the server IP in the browser



## To connect the Zabbix agent to the server

### step 1

Install Zabbix repository

```bash
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb

dpkg -i zabbix-release_latest+ubuntu24.04_all.deb

apt update
```

### step 2

Install Zabbix agent

```bash
apt install zabbix-agent
```

### step 3

Change the Zabbix Agent configuration file in the following path


### /etc/zabbix/zabbix_agentd.conf

```bash
vim
server= your ip address
hostname=your agent hostname 
```
### step 4

Start Zabbix agent process

```bash
systemctl restart zabbix-agent
systemctl enable zabbix-agent
```

## Adding a Host to the Zabbix Server

1. Log in to the Zabbix web interface.

2. Go to the data collection > Hosts menu and click on Create Host.

3. In the Hostname field, enter the name of the host (which should match the name you entered in the agent configuration file).

4. In the Interfaces section, select the type of interface and enter the IP address of your Zabbix server.

5. Finally, click Save.
