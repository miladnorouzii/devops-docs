sudo mysql -u root -p

SELECT user, host, authentication_string FROM mysql.user;

[mysqld]

skip-grant-tables=0

sudo systemctl restart mariadb

INSTALL PLUGIN validate_password SONAME 'validate_password.so';

SET GLOBAL validate_password.policy=STRONG;

UPDATE mysql.user SET authentication_string=PASSWORD('new_secure_password') WHERE user='username' AND host='localhost';

FLUSH PRIVILEGES;

sudo nano /etc/mysql/my.cnf

mysql -u username

SELECT user, host, authentication_string FROM mysql.user;
