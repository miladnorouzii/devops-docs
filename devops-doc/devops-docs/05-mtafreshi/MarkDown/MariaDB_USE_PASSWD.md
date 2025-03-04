## change login Method to MariaDB with Force use Password
### Login to MariaDB
```bash
mysql
or
mysql -u root
or
mysql -u root -p
```
```bash
GRANT ALL PRIVILEGES ON *.* TO `root`@`localhost` IDENTIFIED BY 'Your_Password' WITH GRANT OPTION;
flush privileges;
ctrl + d
```
### now you must type password for Login to MariaDB with This Command (another Method >> Access Denied)
```bash
mysql -u root -p
```