# Switch to the root user without a password
### first step:
```bash
cd /etc/sudoers.de/
```
### second step:
#### create a file called our username.
```bash
vim (user name) 
```
#### write the following text exactly. 
```bash
(user name) ALL=(ALL) NOPASSWD:ALL
```
#### save an back. :wq

