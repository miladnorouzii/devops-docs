#!/bin/bash

check_root ()
{
    if [ `whoami` == "root" ]; then
        echo "you are login with Root User"
    else
        echo "Please Login "root" User and Run Script Agein." 
        exit 1
    fi
}

hosts ()
{
    hosts=/etc/hosts
    file=./host_config
    echo "`cat ${file}`" >> ${hosts}
}

install_wordpress ()
{
    path=/etc/apache2/sites-available/wordpress.conf
    config=/srv/www/wordpress/wp-config.php
    hosts=/etc/hosts
    apt update
    apt install apache2 ghostscript libapache2-mod-php php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml php-zip iptables-persistent -y
    mkdir -p /srv/www
    chown www-data: /srv/www
    curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www
    touch ${path}
    echo "<VirtualHost *:80>" >> ${path}
    echo "    DocumentRoot /srv/www/wordpress" >> ${path}
    echo "    <Directory /srv/www/wordpress>" >> ${path}
    echo "        Options FollowSymLinks" >> ${path}
    echo "        AllowOverride Limit Options FileInfo" >> ${path}
    echo "        DirectoryIndex index.php" >> ${path}
    echo "        Require all granted" >> ${path}
    echo "    </Directory>" >> ${path}
    echo "    <Directory /srv/www/wordpress/wp-content>" >> ${path}
    echo "        Options FollowSymLinks" >> ${path}
    echo "        Require all granted" >> ${path}
    echo "    </Directory>" >> ${path}
    echo "</VirtualHost>" >> ${path}
    sudo a2ensite wordpress
    sudo a2enmod rewrite
    sudo a2dissite 000-default
    sudo service apache2 reload
    # SELECT wp_users.user_login, wp_users.user_email, firstmeta.meta_value as first_name, lastmeta.meta_value as last_name FROM wp_users left join wp_usermeta as firstmeta on wp_users.ID = firstmeta.user_id and firstmeta.meta_key = 'first_name' left join wp_usermeta as lastmeta on wp_users.ID = lastmeta.user_id and lastmeta.meta_key = 'last_name';
    sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php
    sudo -u www-data sed -i 's/database_name_here/wordpress/' ${config}
    sudo -u www-data sed -i 's/username_here/wordpress/' ${config}
    sudo -u www-data sed -i 's/password_here/'123456'/' ${config}
    tail -n 1 ${file} | awk '{print $2}' > dbhost
    sudo -u www-data sed -i "s/localhost/`cat dbhost`/" ${config}
    # https://api.wordpress.org/secret-key/1.1/salt/ (Secure Vulnerability input to /srv/www/wordpress/wp-config.php)
}

iptable ()
{
    file=./host_config
    tail -n 1 ${file} | awk '{print $1}' > db
    head -n 1 ${file} | awk '{print $1}' > web
    tail -n 2 ${file} > ngtemp
    head -n 1 ngtemp | awk '{print $1}' > ng
    iptables -A INPUT -d `cat web` -p TCP --dport 22 -j ACCEPT
    iptables -A INPUT -d `cat web` -p TCP --sport 22 -j ACCEPT
    iptables -A INPUT -s `cat ng` -d `cat web` -p TCP --dport 80 -j ACCEPT
    iptables -A INPUT -s `cat db` -d `cat web` -p TCP --sport 3306 -j ACCEPT
    iptables -A OUTPUT -s `cat web` -p TCP --sport 22 -j ACCEPT
    iptables -A OUTPUT -s `cat web` -p TCP --dport 22 -j ACCEPT
    iptables -A OUTPUT -s `cat web` -d `cat ng` -p TCP --sport 80 -j ACCEPT
    iptables -A OUTPUT -s `cat web` -d `cat db` -p TCP --dport 3306 -j ACCEPT
    iptables -nvL
    sleep 5
    #iptables -P INPUT DROP
    #iptables -P OUTPUT DROP
    iptables -nvL
    sleep 5
    iptables-save > /etc/iptables/rules.v4
    rm db dbhost web ngtemp ng ${file}
}

main ()
{
    check_root
    hosts
    install_wordpress
    iptable
}
main