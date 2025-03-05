Instalation gitlabce on ubunto 24.04   
1. donload the the file "gitlab-ce_17.4.6-ce.0_amd64.deb" from the site https://packages.gitlab.com/gitlab/gitlab-ce
   (you need free access to this site)
2. transfer the downlouded file to /home/youruser of your server via file transfer application like filezila or winScp
   and cuntinue with root access.
3. go to the file loaction and install the pakage
```bash
 dpkg -i gitlab-ce_17.4.6-ce.0_amd64.deb
```
4. update the packages
```bash
  apt update
```
5. upgrade your server packages
```bash
  apt upgrade
```
6. Install required dependencies
```bash
  apt install -y ca-certificates curl openssh-server tzdata 
```
7. Install additional dependencies
```bash
  sudo apt install curl debian-archive-keyring lsb-release ca-certificates apt transport-https software-properties-common -y
```
8. after finde your IP address edit the GitLab configuration file to set your server's IP address
```bash   
  vim /etc/gitlab/gitlab.rb 
```
9. reconfigure GitLab to apply the changes
```bash
  sudo gitlab-ctl reconfigure 
```
10. retrieve the initial root password
```bash
  cat /etc/gitlab/initial_root_password 
```
11. now login to your gitlab by use your browser and your server IP address.


