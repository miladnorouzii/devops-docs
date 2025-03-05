sudo apt update
sudo apt install nginx -y

sudo yum install nginx -y

sudo apt install php php-fpm php-mysql php-xml php-mbstring php-curl php-zip -y

sudo yum install php php-fpm php-mysqlnd php-xml php-mbstring php-curl php-zip -y

cd /var/www
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html
sudo chown -R www-data:www-data /var/www/html/wordpress

sudo apt install mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

sudo apt install postgresql postgresql-contrib -y
sudo systemctl enable postgresql
sudo systemctl start postgresql

sudo mysql_secure_installation
sudo mysql -u root -p

CREATE DATABASE wordpress;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

sudo -u postgres psql

CREATE DATABASE wordpress;
CREATE USER wp_user WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE wordpress TO wp_user;
\q

sudo nano /etc/nginx/sites-available/wordpress

server {
    listen 80;
    server_name example.com;  

    root /var/www/html/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock; 
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}

sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo systemctl restart nginx

sudo nano /var/www/html/wordpress/wp-config.php

define('DB_NAME', 'wordpress');
define('DB_USER', 'wp_user');
define('DB_PASSWORD', 'password');
define('DB_HOST', 'localhost');

sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT    
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT    
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT   
sudo iptables -A INPUT -j DROP

sudo apt install iptables-persistent -y  
sudo service iptables save  

sudo apt install lvm2 -y  
sudo yum install lvm2 -y 

sudo pvcreate /dev/sdb  

sudo vgcreate my_volume_group /dev/sdb

sudo lvcreate -n my_lv_name -L 10G my_volume_group

sudo mkfs.ext4 /dev/my_volume_group/my_lv_name

sudo mkdir /mnt/my_mount_point
sudo mount /dev/my_volume_group/my_lv_name /mnt/my_mount_point

/dev/my_volume_group/my_lv_name /mnt/my_mount_point ext4 defaults 0 2

