# GitLab in Ubuntu 24.04 LTS
## Run This command for update your Ubuntu
``` bash
sudo apt update
sudo apt upgrade -y
```
## Change IP configuration to Static and set DNS Server for access to gitlab Repository
``` bash
sudo vim /etc/netplan
```
## Go to Insert Mode with Type i and Change Configuration
``` bash
network:
    ethernets:
        ens33:
            dhcp4: false
            addresses:
            - YOUR IP ADDRESS
            gateway4: GATEWAY
            nameservers:
                addresses: [10.202.10.202,10.202.10.102]
                search: []
```
## Run This command for Apply Network Configuration
``` bash
sudo netplan try
```
## Run This command for Install necessary dependencies
``` bash
sudo apt install -y curl openssh-server ca-certificates tzdata perl
```
## Next Run This Command
``` bash
sudo apt install -y postfix
```
### During Postfix installation a configuration screen may appear. Select 'Internet Site' and press enter. Use your server's external DNS for 'mail name' and press enter. If additional screens appear, continue to press enter to accept the defaults
#### I use mohsen@mohsensrv.local
## Next Run This Command
``` bash
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
```
## Now you can Install GitLab -ee in Ubuntu
``` bash
sudo apt-get install gitlab-ee
```
## Now you Configure External_URL
``` bash
sudo vim /etc/gitlab/gitlab.rb
```
## and then Reconfigure GitLab
``` bash
gitlab-ctl reconfigure
```
## Done!~ . Local GitLab is Ready
### Browse your Domain or IP Address for acceess to Local GitLab Site
#### Example:
``` bash
192.168.10.1
```
## Root Password Store in This Place and you can access to with cat Command
``` bash 
cat /etc/gitlab/initial_root_password
```
### Login and Change Password Account from Admin Setting
![](./ScreenShot/GITLAB/GitLab_Login.JPG)
![](./ScreenShot/GITLAB/Change_PASSWORD.JPG)
![](./ScreenShot/GITLAB/Change_PASSWORD-2.JPG)
![](./ScreenShot/GITLAB/Change_PASSWORD-3.JPG)

# GitLab in Rocky 9.4 Minimal
## Run This command for update your Rocky
``` bash
sudo yum update
```
## Change IP configuration to Static and set DNS Server for access to gitlab Repository
``` bash
sudo vim /etc/sysconfig/network-scripts/ifcfg-"Logical_Name Adapter"
```
## Go to Insert Mode with Type i and Change Configuration
``` bash
DEVICE=ens33
ONBOOT=yes
BOOTPROTO=none
IPADDR=IP ADDRESS
NETMASK=SUBNET MASK
GATEWAY=Gateway
DNS1=10.202.10.202
DNS2=10.202.10.102
```
## Run This command for Apply Network Configuration
``` bash
sudo systemctl reload NetworkManager
```
## and after This Suggested to Reboot your Machine
## Run This command for Install necessary dependencies
``` bash
sudo yum install curl policycoreutils openssh-server openssh-clients postfix
```
## Next Run This Command
``` bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo systemctl reload firewalld
```
## Next Run This Command
``` bash
sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix
```
## Next Run This Command
``` bash
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
```
## Now you can Install GitLab -ee in Ubuntu
``` bash
sudo yum install gitlab-ce
```
## Now you Configure External_URL (I Configure http://MY_IP_ADDRESS)
``` bash
sudo vim /etc/gitlab/gitlab.rb
```
## and then Reconfigure GitLab
``` bash
gitlab-ctl reconfigure
```
``` bash 
sudo systemctl start gitlab-runsvdir.service
sudo systemctl enable gitlab-runsvdir.service
```
## For Veiw Service Status Type
``` bash
sudo systemctl status gitlab-runsvdir.service
```
## Done!~ . Local GitLab is Ready
### Browse your Domain or IP Address for acceess to Local GitLab Site
#### Example:
``` bash
192.168.10.2
```
## Root Password Store in This Place and you can access to with cat Command
``` bash 
cat /etc/gitlab/initial_root_password
```
### Login and Change Password Account from Admin Setting Like for Ubuntu Version, Becuase the Randomly Generated Password Store in this place for 24 Hr. (Recommended GitLab Document)

# For Restart GitLab Services Used This Command
``` bash
sudo gitlab-ctl restart
```
# Finish