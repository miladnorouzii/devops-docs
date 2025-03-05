# How To Install GitLab on Ubuntu

Follow below steps to Install Gitlab on Ubuntu 22.04|20.04|18.04.

**Step 1: Update system & install dependencies**

Kickoff the installation by ensuring your system is updated:

```
sudo apt update
sudo apt upgrade -y
```
Install GitLab dependencies below:

```
sudo apt install -y ca-certificates curl openssh-server tzdata
```

**Step 2: Add the GitLab Repository**

Install dependency packages required:

```
sudo apt install curl debian-archive-keyring lsb-release ca-certificates apt-transport-https software-properties-common -y
```
Run the script below to configure GitLab repository for Debian based systems.

```
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
```

**Step 3: Download and Install GitLab from package file**

- Visit the following URL to download the GitLab package:
   - [GitLab Packages](https://packages.gitlab.com/gitlab/gitlab-ee)
- Download the package `gitlab-ee_17.4.3-ee.0_amd64.deb` to your local machine.

```
sudo dpkg -i gitlab-ee_17.4.3-ee.0_amd64.deb
```

**Step 4: Edit the GitLab configuration file**

Edit the GitLab configuration file to set hostname and other parameters:

```
sudo vim /etc/gitlab/gitlab.rb
```
Replace `gitlab.example.com` with your IP address or domain for GitLab server.

When done, start your GitLab instance by running the following command:

```
sudo gitlab-ctl reconfigure
```
All GitLab services should be started after configuration.

```
sudo gitlab-ctl status
```

**Step 5: Access GitLab CE Web Interface**

Open the URL `http://[your_IP_address]` on your browser to finish the installation of Gitlab.

A password for root user is randomly generated and stored in `/etc/gitlab/initial_root_password`.
You can check the password with the commands below:

```
sudo cat /etc/gitlab/initial_root_password
```
Use this password with username root to login.

**Step 6: Reset root user password**

- Go to root user profile > Preferences

- Then Password section

