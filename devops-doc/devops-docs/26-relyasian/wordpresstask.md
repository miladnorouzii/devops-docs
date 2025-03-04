## install and configuration nginx reverse proxy and wordpress with external db
### to do this senario we need three server. the first server  is our nginx server the second one is our wordprees server  and the last one is database server
# server one configs
```bash 
sudo apt install nginx
```
and then unlink the default config file 
```bash 
cd /etc/nginx/sies-available
unlink /etc/nginx/sites-enabled/default
```
now we need to create a new config file 
```bash
vim #your config file name
```
and then wright the following 
```yaml

server {
        listen 80;
        server_name _;
        access_log /var/log/nginxreverse-access.log;
                error_log /var/log/nginx/reverse-error.log;

                location /app1 {
                        proxy_pass http://#your word pressserver ip:5000/;
                }

}
```
and link this new config file 
```bash
ln -s /etc/nginx/sites-available/#your config file name /etc/nginx/sites-enabled/#your config file name
```
then 
```bash 
nginx -s reload
systemctl restart nginx.service
```
server one is done.
# server two
```bash
apt-get update
apt-get upgrade -y
apt-get install apache2 -y
sudo apt install php php-curl php-mysql php-mbstring php-xml php-gd
sudo apt install libapache2-mod-php7.4
```
#### The first four commands will update repositories, upgrade packages, install Apache, and install PHP along with the PHP libraries required for WordPress. And the last one will install MySQL client that we can use to test the remote connection with our database server.

#### To verify if Apache and PHP are installed and configured correctly, execute the following commands and then access the public IP address of the application server in the browser.
```bash
rm /var/www/html/index.html
echo "<?php phpinfo(); ?>" > /var/www/html/index.php
```
#### If you can see On the browser, you should see a page with PHP configuration information, you have successfully configured the application server. Now, we can move on to the configuration of our database server. 
# server three
```bash
apt-get update
apt-get upgrade -y
apt-get install mysql-server mysql-client -y
```
and then 
```bash 
mysql_secure_installation
```
While executing the third command, you have to enter the MySQL root password. And while running the fourth command, You have to answer a few questions. Answer it like this.

Enable Validate Password Plugin? No  
Change the password for root? No  
Remove anonymous users? Yes  
Disallow root login remotely? Yes  
Remove test database and access to it? Yes  
Reload privilege table now? Yes

Once done, try to log in to your MySQL server using the following command.
```bash 
mysql -uroot -p
```
#### If you can log into your MySQL server, you have successfully installed MySQL on the server. Now, it is time to update the MySQL configuration file to allow remote connections. Execute the following command to open the MySQL configuration file in edit mode.
```bash 
vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
#### In the file, find a line containing bind-address. You have to uncomment this line and replace the default value with the IP address of your database server. The updated line should look like the following.
```yaml
bind-address = #your ip adress
```
```bash 
service mysql restart
```
### Create Database for WordPress on Database Server
#### First of all, log in to your MySQL server using the following command.
```bash 
mysql -uroot -p;
```
```yaml
mysql> CREATE DATABASE wordpress;
mysql> CREATE USER ‘#YOUR USERNAME‘@’#YOUR SECOND SERVER IP‘ IDENTIFIED BY ‘#PASS‘;
mysql> GRANT ALL PRIVILEGES ON wordpress.* TO ‘#YOUR USERNAME‘@’#YOUR SECOND SERVER IP‘;
mysql> FLUSH PRIVILEGES;
```
# server two
```bash
mysql -u#YOUR USERNAME  -p -h#database server ip
``` 
### Download WordPress on the Application server
```yaml
cd /var/www/html
rm -rf *
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress/* ./
rm wordpress latest.tar.gz
chown -R www-data:www-data /var/www/html
```
#### In this series of commands, the first command will change the directory to /var/www/html and the second command will remove all the files inside that directory. The third and fourth command will download and extract WordPress files in the directory. The fifth will move WordPress files from the wordpress directory to the current directory. The sixth command will remove the extra directories and files that are no longer required. The last command will set the proper permissions on our /var/www/html directory where our WordPress files are stored.
### Finally, the downloading part of our WordPress installation process is done. So, we can now begin WordPress installation from the browser. Open up a new browser tab or window and access the public IP address of your application server.
# done.
