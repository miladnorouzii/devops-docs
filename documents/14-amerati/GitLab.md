# GitLab Installation Guide #
**Follow below steps to Install Gitlab on Ubuntu Server.**
## Requirements ##
1. *Access to a Ubuntu Linux server.*
2. *WinSCP or any file transfer tool to upload the package.*
### Step 1: Download GitLab EE Package ###
1. *Visit the following URL to download the GitLab EE package:*
   - *[GitLab Packages](https://packages.gitlab.com/gitlab/gitlab-ce)*
2. *Download the package `gitlab-ee_17.4.3-ee.0_amd64.deb` to your local machine.*
 
### Step 2: Transfer the Package to Ubuntu Server ###
 - *Use WinSCP to transfer the downloaded `gitlab-ee_17.4.3-ee.0_amd64.deb` file to your Linux server.*
### Step 3: Install GitLab ###
1. *Open a terminal on your Linux server.*

2. *Navigate to your home directory:*
   ```bash
   cd ~
   ```

3. *List the files to ensure the package is present:*
   ```bash
   ls
   ```

4. *Install the GitLab package:*
   ```bash
   sudo dpkg -i gitlab-ee_17.4.3-ee.0_amd64.deb
   ```

5. *Update the package lists:*
   ```bash
   sudo apt update
   ```

6. *Upgrade all packages:*
   ```bash
   sudo apt upgrade -y
   ```

7. *Install required dependencies:*
   ```bash
   sudo apt install -y ca-certificates curl openssh-server tzdata
   ```

8. *Install additional dependencies:*
   ```bash
   sudo apt install curl debian-archive-keyring lsb-release ca-certificates apt-transport-https software-properties-common -y
   ```
### Step 4: Configure GitLab ###
1. *Edit the GitLab configuration file to set your server's IP address:*
   ```bash
   sudo vim /etc/gitlab/gitlab.rb
   ```

2. *Reconfigure GitLab to apply the changes:*
   ```bash
   sudo gitlab-ctl reconfigure
   ```

3. *Retrieve the initial root password:*
   ```bash
   sudo cat /etc/gitlab/initial_root_password
   ```
### Step 5: Access GitLab ###

1. *Open your web browser and navigate to your server's IP address.*
2. *Log in using the username `root` and the initial password retrieved in the previous step.*
### Conclusion ###
*You have successfully installed GitLab on your Linux server. For further configuration and management, refer to the [GitLab documentation](https://docs.gitlab.com/).*