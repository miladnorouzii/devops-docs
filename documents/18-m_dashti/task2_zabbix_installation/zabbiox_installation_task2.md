# https://www.zabbix.com/download?os_distribution=ubuntu
# b. Install Zabbix repository 

    #wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb
    #sudo dpkg -i zabbix-release_latest_7.2+ubuntu24.04_all.deb
    #sudo apt update 
 # c. Install Zabbix server, frontend, agent 
    #apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
 # d. Create initial database
   #sudo mysql -uroot -p
   sql123    #passwrod
   #prompt for sql
   create database zabbix character set utf8mb4 collate utf8mb4_bin;
   create user zabbix@localhost identified by 'sqlpass;
   grant all privileges on zabbix.* to zabbix@localhost;
   set global log_bin_trust_function_creators = 1;
   quit; 
    #ls /usr/share/zabbix/sql-scripts/mysql/
    server.sql.gz
    # zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix 
    #enter password:
    sqlpass
    #check sql table for zabbix
    #mysql -uzabbix -psqlpass
    #show databases;
    #use zabbix;
    #show tables;
    #select * from users;
    #ok 🤩
    #Disable log_bin_trust_function_creators option after importing database schema. 
    # mysql -uroot -p
    sql123
    mysql> set global log_bin_trust_function_creators = 0;
    mysql> quit; 
 # e. Configure the database for Zabbix server 
    #sudo vim /etc/zabbix/zabbix_server.conf 
    #search DBPassword=password
    #remove #
    DBPassword=sqlpass
    :wq
 # f. Start Zabbix server and agent processes 
   #Start Zabbix server and agent processes and make it start at system boot.
    # systemctl restart zabbix-server zabbix-agent apache2
    # systemctl enable zabbix-server zabbix-agent apache2 
    #down