## implementing worldpress on server2
- **Update the Ubuntu system**
    ```bash
    sudo apt update
    ```
- **Install Nginx, PHP, and required PHP extensions for WordPress**
    ```bash
    sudo apt install nginx php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip curl unzip

    ```
- **Navigate to the web root and download the latest WordPress package**
    ```bash
    cd /var/www/html
    sudo curl -O https://wordpress.org/latest.tar.gz
    sudo tar -xzvf latest.tar.gz
    sudo rm latest.tar.gz
    sudo mv wordpress/* .
    sudo rmdir wordpress
    ```
- **Set the correct permissions**
    ```bash
    sudo chown -R www-data:www-data /var/www/html
    sudo chmod -R 755 /var/www/html
    ```
- **Create a new Nginx server block for WordPress**
    ```bash
    sudo vim /etc/nginx/sites-available/wordpress
     ```
- **Add the following configuration**
  ```bash
  server {
    listen 80;
    server_name 192.168.112.155;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    error_log /var/log/nginx/wordpress_error.log;
    access_log /var/log/nginx/wordpress_access.log;
    }
    ```
 - **Enable the site:**
    ```bash
    sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
    ```  
- **Test the Nginx configuration**
    ```bash
    sudo nginx -t
    ```
- **Reload Nginx to apply the changes**    
    ```bash
    sudo systemctl reload nginx
    ```
- **Create the WordPress configuration file: On the WordPress server, copy the sample configuration file to wp-config.php**    
    ```bash
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
- **Edit the wp-config.php file: Open the configuration file**    
    ```bash
    sudo vim /var/www/html/wp-config.php
    ```
- **Modify the following lines to point to the external MariaDB database**    
    ```bash
    define( 'DB_NAME', 'wordpress_db' );
    define( 'DB_USER', 'pmke' );
    define( 'DB_PASSWORD', '1qaz!QAZ' );
    define( 'DB_HOST', '192.168.112.156' );  // IP address of the MariaDB server
    ```
