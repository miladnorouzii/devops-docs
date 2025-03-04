# Install Gitlab On Ubunto Server 24.0.4

## first Update Package lists
```bash
$ sudo apt update
```
## Install Dependencies
```bash
$ sudo apt install -y curl openssh-server 
```
## Add Gitlab APT repositories
```bash
$ curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
```
## Install Gitlab on Ubunto 24.0.4
```bash
$ sudo apt install gitlab-ce
```
## Configure Gitlab
```bash
vim /etc/gitlab/gitlab.rb
```
EXTERNAL_URL="http://IP_ADDRESS_OF_YOUR_SERVER"
```bash
$ sudo gitlab-ctl reconfigure
```
username for gitlab web interface is root and password is stored at "/etc/gitlab/initial_root_password"
