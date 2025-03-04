# How To Install and Configure Zabbix Server on Ubuntu
Follow below steps to Install Zabbix Server on Ubuntu:


**Step 1: Change DNS Nameserver(s) via Netplan**
- Go to the Netplan directory via the cd command.
```
cd /etc/netplan
```
- List the directory contents to see the name of the YAML file containing network configuration and open the file in a text editor.
```
ls
```
```
sudo vim [network-manager-file].yaml
```
- Replace the addresses located in the file with the DNS addresses you want to use. You can enter more than two addresses.
  
>  For Example: `178.22.122.100`, `185.51.200.2`

- Save the changes and exit.

- Apply the changes you made in the config file.
  
```
sudo netplan try && sudo netplan apply
```


**Step 2: Ensure System is Updated**

- Ensure all packages are updated via the commands below.

```
sudo apt update && sudo apt -y upgrade
```
- Reboot if kernel updates were applied to the system.

```
[ -f /var/run/reboot-required ] && sudo reboot -f
```


**Step 3: Install PHP, Apache, and MariaDB**

- Install PHP and all modules of PHP required to run Zabbix monitoring server on Ubuntu.

```
sudo apt install php php-{snmp,cgi,mbstring,common,net-socket,gd,xml-util,mysql,bcmath,imap}
```

- Install Apache web server that will serve Zabbix web pages.

```
sudo apt install apache2 libapache2-mod-php
```

- Let’s install MariaDB.

```
sudo echo "deb [signed-by=/usr/share/keyrings/mariadb-archive-keyring.gpg] https://dlm.mariadb.com/repo/mariadb-server/10.11/repo/ubuntu mantic main" >> /etc/apt/sources.list
```

```
sudo apt install mariadb-server
```
- Once the installation is complete, start the MariaDB service and enable it to start on boot using the following commands.

```
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

- Validate installation by checking software versions installed.

```
php --version
mariadb -V
apache2 -version
```


**Step 4: Add Zabbix APT Repository**

- Since Ubuntu is Debian based Linux system we’re downloading `.deb` package file.

```
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu24.04_all.deb
```

- Install downloaded repository file.

```
sudo dpkg -i zabbix-release_7.0-2+ubuntu24.04_all.deb
```


**Step 5: Install and Configure Zabbix Server**

- Update repository packages list.

```
sudo apt update
```

We’ve configured repositories and ready to install Zabbix server packages.

- Run the commands below to do so.

```
sudo apt install vim zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```

- Enable PHP CGI by executing the following commands in your terminal.

```
sudo  a2enconf php8.*-cgi
```

- Reload apache for the changes to be applied and confirm the status of your web service.


```
sudo systemctl restart apache2
systemctl status apache2
```
- Reset root password for database

Secure MySQL/MariaDB by changing the default password for MySQL root.

```
sudo mysql_secure_installation
```
`Enter current password for root (enter for none): Press Enter`

`Switch to unix_socket authentication [Y/n] y`

`Change the root password? [Y/n] y`
`New password: <Enter root DB password>`

`Re-enter new password: <Repeat root DB password>`

`Remove anonymous users? [Y/n]: n`

`Disallow root login remotely? [Y/n]: n`

`Remove test database and access to it? [Y/n]:  n`

`Reload privilege tables now? [Y/n]:  Y`


- Login to MariaDB shell as _root_ user.

```
sudo mysql -u root -p'<Root DB password>'
```

- Create a database and user for Zabbix.

```
CREATE DATABASE zabbix character set utf8 collate utf8_bin;
GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@'localhost' IDENTIFIED BY 'ZabbixDBPassw0rd';
FLUSH PRIVILEGES; 
QUIT
```

- Next import data into the database created.

```
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p'ZabbixDBPassw0rd' zabbix
```

- Edit your Zabbix server configuration and set database credentials.

```
sudo vim /etc/zabbix/zabbix_server.conf
```

`DBName=zabbix`

`DBUser=zabbix`

`DBPassword=ZabbixDBPassw0rd`

- Restart Zabbix server services using systemctl command.

```
sudo systemctl restart zabbix-server zabbix-agent
```

> [!NOTE]
> Don’t forget to enable services starting automatically on system boot.

```
sudo systemctl enable apache2 zabbix-server zabbix-agent
```

- Services status can checked with the commands below.

```
systemctl status zabbix-server zabbix-agent
```


**Step 6: Configure Firewall**

- If you have a UFW firewall installed on Ubuntu, use these commands to open TCP ports: `10050 (agent)`, `10051 (server)`, and `80 (frontend)`

```
ufw allow 10050/tcp
ufw allow 10051/tcp
ufw allow 80/tcp
ufw reload
```


**Step 7: Configure Zabbix Server from Web UI**

- Open your browser and access Zabbix web interface using the URL `http://SeverIP/zabbix/` or `http://hostname/zabbix/`

- At the page shown, click `Next step` and confirm all the dependencies are met. It should return `OK`.

- Set your database details as configured earlier.

> Set your password

- Give your Zabbix server a name, this can be the hostname. Also choose the default theme and set timezone correctly.

-  Confirm all configurations are set correctly then proceed to finalize the process.

- A congratulations message is shown if everything went as expected. Finish the installation to login.

- Use the following default credentials to access Zabbix admin dashboard.

> Username: "Admin"
> 
>Password: "zabbix"


**Step 8: Set strong Admin User Password**

- Go to Administration > Users > Admin > Password > Change Password

Set a strong password for the admin user to better secure your Zabbix installation against attacks


**Step 9: Adding Monitoring Agents to Zabbix Server**

- To add a new target host to be monitored by Zabbix, go to Configuration > Hosts, you should see the local Zabbix Server status enabled.

Host graphs and dashboards can be viewed by going to Monitoring > Hosts. Other hosts can be added by giving it a name and IP address.

> But remember to configure Zabbix Agent on the end device.


**Step 10: Install Zabbix Agents to Zabbix Client**

- In order to install the zabbix-agent on a host , you can do the following steps:

```
sudo apt install zabbix-agent - y
```

***OR***

```
sudo dpkg -i zabbix-release_7.0-2+ubuntu24.04_all.deb
```

- Check zabbix-agent status

```
systemctl status zabbix-agent.service
```

- After the installation, you can do the necessary configuration changes in the file:

```
sudo vim /etc/zabbix/zabbix_agentd.conf
```

Edit zabbix server IP address where is `Server=127.0.0.1`

- Configure firewall

```
ufw allow 10050/tcp
ufw allow 10051/tcp
ufw allow 80/tcp
ufw reload
```

- One done, restart the service:

```
sudo systemctl restart zabbix-agent.service
```

## FIN ##