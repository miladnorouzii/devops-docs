# Description how to install GitLab

#at First, the system must be updated with this commands :


apt update 
apt upgrade -y


#add dependencies:

sudo apt-get install -y curl openssh-server ca-certificates tzdata perl


#After that, the Git Lab repository should be added to the system repository file with this command :

echo "deb [signed-by=/usr/share/keyrings/gitlab.gpg] https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ jammy main" | tee /etc/apt/sources.list.d/gitlab_gitlab-ce.list


#I received many errors in this section
#And I had to manually download the debien package from the main Git Lab site on Windows
#And I transferred the package from Windows to Ubuntu using the WinSCP program

#after that i used this command to run gitlab package :

dpkg -i gitlab-ce_17.3.6-ce.0_amd64.deb


#for configure gitlab, i changed gitlab.rb file in this path :

vim /etc/gitlab/gitlab.rb

#i chaneged line 32 to my ip address

- external_url 'http://192.168.234.16'

#I used this command to apply changes to the GitLab.rb file:

gitlab-ctl reconfigure

#I checked its status with this command:

gitlab-ctl status 

#that was runing and just needed a reboot :)

#for log in to Gitlab, I typed the IP address of Ubuntu in the browser
#used the username root and the password that was in the following path:

cat /etc/gitlab/initial_root_password

