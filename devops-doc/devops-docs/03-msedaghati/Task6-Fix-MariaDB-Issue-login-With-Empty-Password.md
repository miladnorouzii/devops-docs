Configure default root password in mariadb

```bash

mysql
ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';
flush privileges;
exit;

```

Now login with new pass word
```bash
mysql -u root -p
```
