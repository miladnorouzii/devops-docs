## mariadb issue ##


step 1

```bash
sudo mysql -u root 
```
step2

in this step we must be creat super USER

```bash
CREATE USER 'new'@'%' IDENTIFIED BY 'newpassword';
```

step 3 

after that give privilages:

```bash
GRANT ALL PRIVILEGES ON *.* TO 'new'@'%' WITH GRANT OPTION;
```

step 4

```bash
show databases;

use mysql;

select host,user,password from user;
```

step 5

```bash
FLUSH PRIVILEGES;
```

