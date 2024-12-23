# How to install Gitlab on a Linux server
```bash

https://packages.gitlab.com/gitlab/gitlab-ce

gitlab-ce-17.3.6-ce.0.el7.x86_64.rpm

sudo dpkg -i  gitlab-ce-17.3.6-ce.0.el7.x86_64.rpm

sudo apt update

sudo apt upgrade -y

sudo apt install -y ca-certificates curl openssh-server tzdata

ls
  
vim /etc/gitlab/gitlab.rb
external_url http://192.168.---.--

sudo gitlab-ctl reconfigure

sudo cat /etc/gitlab/initial_root_password

```
~Meisam Amiri~~
