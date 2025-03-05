#!/bin/bash

# Variables
ZABBIX_VERSION="7.0"  # Zabbix version
DB_NAME="zabbix"
DB_USER="zabbix"
DB_PASSWORD="zabbixDBpass"
DB_ROOT_PASSWORD="root_password"
CONFIG_FILE="/etc/zabbix/zabbix_server.conf"
NEW_LINE="DBPassword=zabbixDBpass"
# Function to check the success of a command
check_command() {
    if [ $? -eq 0 ]; then
        echo "SUCCESS: $1"
    else
        echo "ERROR: $1"
        exit 1
    fi
}

# Update and Upgrade System
echo "Updating system..."
sudo apt update && sudo apt upgrade -y
check_command "System update and upgrade"

# Install MariaDB
echo "Installing MariaDB..."
sudo rm -f /etc/apt/sources.list.d/mariadb.list
curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc | sudo gpg --dearmor -o /usr/share/keyrings/mariadb-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/mariadb-archive-keyring.gpg] https://dlm.mariadb.com/repo/mariadb-server/10.11/repo/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mariadb.list

sudo apt update

sudo apt install -y mariadb-server
check_command "Installed MariaDB server"

sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB
echo "Securing MariaDB..."
sudo mysql_secure_installation <<EOF

y
$123
$123
y
y
y
y
EOF
check_command "Secured MariaDB"

# Add Zabbix Repository
echo "Adding Zabbix repository..."
wget https://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VERSION}-1+ubuntu$(lsb_release -rs)_all.deb
check_command "Downloaded Zabbix repository package"

sudo dpkg -i zabbix-release_${ZABBIX_VERSION}-1+ubuntu$(lsb_release -rs)_all.deb
check_command "Installed Zabbix repository"

sudo apt update
check_command "Updated package list after adding Zabbix repository"

# Install Zabbix Server, Frontend, and Agent
echo "Installing Zabbix server, frontend, and agent..."
required_packages=(
    "zabbix-server-mysql" "zabbix-frontend-php" "zabbix-apache-conf" "zabbix-sql-scripts" "zabbix-agent"
)

for package in "${required_packages[@]}"; do
    sudo apt install -y "$package"
    check_command "Installing $package"
done

# Configure Database
echo "Configuring MariaDB for Zabbix..."
sudo systemctl start mariadb
check_command "Started MariaDB"

sudo mysql -u root -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
check_command "Created Zabbix database"

sudo mysql -u root -p"$DB_ROOT_PASSWORD" -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
check_command "Created Zabbix database user"

sudo mysql -u root -p"$DB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
check_command "Granted privileges to Zabbix database user"

sudo mysql -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
check_command "Flushed privileges in MariaDB"

# Import Initial Schema
echo "Importing initial schema for Zabbix..."
zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME"
check_command "Imported Zabbix database schema"

# Configure Zabbix Server
echo "Configuring Zabbix server..."
sudo sed -i "s/# DBPassword=/DBPassword=$DB_PASSWORD/" /etc/zabbix/zabbix_server.conf
check_command "Configured Zabbix server DBPassword"






# Check if the line already exists
if grep -q "^$NEW_LINE$" "$CONFIG_FILE"; then
    echo "The line '$NEW_LINE' already exists in $CONFIG_FILE."
else
    # Add the line to the end of the file
    echo "$NEW_LINE" | sudo tee -a "$CONFIG_FILE" > /dev/null
    echo "Added the line '$NEW_LINE' to $CONFIG_FILE."
fi


# Restart Services
echo "Restarting services..."
services=("zabbix-server" "zabbix-agent" "apache2")

for service in "${services[@]}"; do
    sudo systemctl restart "$service"
    check_command "Restarted $service"
    sudo systemctl enable "$service"
    check_command "Enabled $service"
done

# Verify Zabbix Agent
echo "Configuring Zabbix agent..."
sudo sed -i "s/Server=127.0.0.1/Server=127.0.0.1/" /etc/zabbix/zabbix_agentd.conf
check_command "Set Zabbix agent Server"

sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1/" /etc/zabbix/zabbix_agentd.conf
check_command "Set Zabbix agent ServerActive"

sudo sed -i "s/Hostname=Zabbix server/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf
check_command "Set Zabbix agent Hostname"

sudo systemctl restart zabbix-agent
check_command "Restarted Zabbix agent"

# Final Output
echo "Zabbix installation and configuration completed successfully!"
echo "Access the Zabbix frontend via: http://<server-ip>/zabbix"
echo "Default login: Admin / zabbix"
