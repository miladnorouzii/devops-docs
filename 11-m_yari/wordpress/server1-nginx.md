## implementing nginx and config on server1
- **Update the Ubuntu system**
    ```bash
    sudo apt update
    sudo apt upgrade
    ```
- **Install Nginx:**
    ```bash
    sudo apt install nginx
    ```
- **Start Nginx:**
    ```bash
    sudo start nginx
    ```
- **Enable Nginx to start at boot:**
    ```bash
    sudo systemctl enable nginx
    ```
- **Open the Nginx configuration file on the first server**
    ```bash
    sudo vim /etc/nginx/sites-available/rtw.conf
    ```
- **The configuration should be like this:**
    ```bash
    server {
    listen 80;
    server_name 192.168.112.154;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log warn;

    location / {
        proxy_pass http://192.168.112.155;  # Proxy to the WorldPress server
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
  }

    ```
 - **After editing, test and restart Nginx configuration**
     ```bash
    sudo nginx -t
    sudo systemctl restart nginx
    ``` 
- **Enable the Nginx configuration file**
    ```bash
    sudo ln -s /etc/nginx/sites-available/rtw.conf /etc/nginx/sites-enabled/rtw.conf
    ```
- **And Set Below Command**    
    ```bash
    sudo unlink default
    ```
