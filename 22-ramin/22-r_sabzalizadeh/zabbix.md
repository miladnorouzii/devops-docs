# ZABBIX installation:
## step1 : connect as root user : sudo su -
## step2 : install bash requirements
```bash
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu$(lsb_release -rs)_all.deb
sudo dpkg -i zabbix-release_7.0-1+ubuntu$(lsb_release -rs)_all.deb
sudo apt update
sudo apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```

## step3 : install mariaDB : there was an error with maria  DB installation, so i tried next method
```bash 
#not worked
sudo apt install software-properties-common -y
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup 
sudo bash mariadb_repo_setup --mariadb-server-version=10.11
sudo apt update 
sudo apt -y install mariadb-common mariadb-server-10.11 mariadb-client-10.11
#worked
sudo rm /etc/apt/sources.list.d/mariadb.list
curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc | sudo gpg --dearmor -o /usr/share/keyrings/mariadb-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/mariadb-archive-keyring.gpg] https://dlm.mariadb.com/repo/mariadb-server/10.11/repo/ubuntu mantic main" >> /etc/apt/sources.list
apt update
apt install mariadb-server
```
## step4: start the MariaDB service and enable it to start on boot 
```bash 
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

## step5: restart the password of mariaDB:
```bash
sudo mysql_secure_installation
Enter current password for root (enter for none): Press Enter
Switch to unix_socket authentication [Y/n] y
Change the root password? [Y/n] y
New password: <Enter root DB password, I will set "123">
Re-enter new password: <Repeat root DB password, I will set "123">
Remove anonymous users? [Y/n]: Y
Disallow root login remotely? [Y/n]: Y
Remove test database and access to it? [Y/n]:  Y
Reload privilege tables now? [Y/n]:  Y
```

## step6: create DB
```bash
sudo mysql -uroot -p'123' -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -uroot -p'123' -e "create user 'zabbix'@'localhost' identified by 'zabbixDBpass';"
sudo mysql -uroot -p'123' -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbixDBpass';"
```

## step5 :Import initial schema and data.
```bash
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p'zabbixDBpass' zabbix
```

## step6 : Enter database password in Zabbix configuration file
```bash
sudo nano /etc/zabbix/zabbix_server.conf

#nano/vim :import below text anywhere in file
DBPassword=zabbixDBpass

```


## step7 : configure firewall
```bash
ufw allow 10050/tcp
ufw allow 10051/tcp
ufw allow 80/tcp
ufw reload
```



## Step8 : Start Zabbix server and agent processes
```bash
sudo systemctl restart zabbix-server zabbix-agent 
sudo systemctl enable zabbix-server zabbix-agent

```

## Step9 : Start Zabbix server and agent processes
```bash
systemctl restart apache2
systemctl enable apache2
```


## step10: configure front end
```bash
#put server ip with zabbix
http://192.168.1.10/zabbix)
#username “Admin” and password “zabbix”
```



## reference
```bash
# https://bestmonitoringtools.com/how-to-install-zabbix-server-on-ubuntu/
```