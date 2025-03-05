# Zabbix in ubuntu 24.04 LTS
## Zabbix 6.0.35 LTS / PostgreSQL / Apache
### Set Network Configuration (DNS)
```bash
nameserver:
    addresses: [10.202.10.202,10.202.10.102]
```
### Installation
#### Become root user
```bash
    sudo -s
```
####  Install Zabbix repository
```bash
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb
    dpkg -i zabbix-release_latest+ubuntu24.04_all.deb
    apt update
```
#### Install Zabbix server, frontend, agent
```bash
    apt install zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```
#### Install PostgreSQL
```bash
    apt install postgresql postgresql-contrib -y
```
#### Create initial database
```bash
    sudo -u postgres createuser --pwprompt zabbix
    sudo -u postgres createdb -O zabbix zabbix 
    zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
```
#### Configure the database for Zabbix server
##### Edit file /etc/zabbix/zabbix_server.conf
###### Search in vim and modify "# DBPassword="
```bash
    DBPassword="Your_Password"
```
### Start Zabbix server and agent processes
```bash
    systemctl restart zabbix-server zabbix-agent apache2
    systemctl enable zabbix-server zabbix-agent apache2
```
### Open Zabbix UI web page
```bash
    Your_IP_Address/zabbix
    "Default Zabbix Credential"
    Username : Admin
    Password : zabbix
```
### Configure Zabbix for Connect to PostgreSQL DataBase
```bash
    in Database Connection Set "Your_Password" in "Configure the database for Zabbix server" Title
```
Done.


## Configuration Zabbix 
### Create User
```bash
    on Left Panel Go to Administration >> Users
    Create New_User and config Permission
```


### Configuration Host for Zabbix Server Agent 
```bash
    on Left Panel Go to Configuration >> Hosts
    Modify Host
        Modify Interface IP Address (127.0.0.1) to "Zabbix_Server_IP" and Default Port 10050
```
### Configure zabbix_agentd.conf in Zabbix Server
```bash
    find / | grep -i zabbix_agentd.conf
    vim /etc/zabbix/zabbix_agentd.conf
    Search "Server" and Modify (Server)
        in Passive to "Zabbix_Server_IP/24"
        in Active to "Zabbix_Server_IP:10051"
    systemctl restart zabbix-agent
    systemctl enable zabbix-agent
```

### Configuration Host for Add Agent 
```bash
    on Left Panel Go to Configuration >> Hosts
    Create Host
        Set Tamplate to "Linux by Zabbix Agent"
        Set Interface to Agent and "Target_IP for Monitoring" and Default Port 10050
```
### Configure zabbix_agentd.conf in Server for Monitor (Rocky Minimal 9.4)
#### Install and configure Zabbix for your platform
```bash
    sudo -s
    rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rocky/9/x86_64/zabbix-release-latest.el9.noarch.rpm
    dnf clean all
```
#### Install Zabbix agent
```bash
    dnf install zabbix-agent
```
#### Start Zabbix agent process
```bash
    systemctl restart zabbix-agent
    systemctl enable zabbix-agent
```
#### Configure zabbix_agentd.conf in Target Server
```bash
    find / | grep -i zabbix_agentd.conf
    vim /etc/zabbix/zabbix_agentd.conf
    Search "Server" and Modify (Server)
        in Passive to "Zabbix_Server_IP/24"
        in Active to "Zabbix_Server_IP:10051"
    systemctl restart zabbix-agent
    systemctl enable zabbix-agent
```
#### Configure Firewall in (Rocky Minimal 9.4)
```bash
    firewall-cmd --add-port=10050/tcp --permanent
    firewall-cmd --add-port=10051/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports
```
Done.