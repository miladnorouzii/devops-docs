# Install and config postgresql cluster 
```bash
sudo apt update
sudo apt upgrade
```
Edit all /etc/hosts

192.168.249.81  node1
192.168.249.82  node2
192.168.249.83   node3

# Install postgresql server software on node1,node2 and node3
```bash
sudo apt install postgresql postgresql-contrib -y
sudo systemctl stop postgresql
```
# Create a symlink on all 3 nodes for patroni
```bash
sudo ln -s /usr/lib/postgresql/14/bin/* /usr/sbin
```
#  Install patroni on node1,node2,node3
```bash
sudo apt -y install python3-pip python3-dev libpq-dev
pip3 install --upgrade pip
sudo pip install patroni
sudo pip install python-etcd
sudo pip install psycopg2
```
# Configuration of etcd

Edit etcd config file / add below on /etc/default/etcd
ETCD_LISTEN_PEER_URLS  =  "http://192.168.249.83:2380,http://192.168.249.83:7001"
ETCD_LISTEN_CLIENT_URLS  =  "http://127.0.0.1:2379, http://192.168.249.83:3379"
ETCD_INITIAL_ADVERTISE_PEER_URLS  =  "http://192.168.249.83:2380"
ETCD_INITIAL_CLUSTER  =  "etcd0=http://192.168.249.83:2380"
ETCD_ADVERTISE_CLIENT_URLS  =  "http://192.168.249.83:2379"
ETCD_INITIAL_CLUSTER_TOKEN  =  "node1"
ETCD_INITIAL_CLUSTER_STATE  =  "new"

```bash
 sudo systemctl restart etcd
 sudo systemctl status etcd
```

 # Configuration of patroni on node1

 Create /etc/patroni.yml and add below lines to patroni.yml

```bash
 sudo vi /etc/patroni.yml
```
# Add below lines

scope: postgres
namespace: /db/
name: node1
restapi:
  listen: 192.168.249.80:8008
  connect_address: 192.168.249.80:8008
etcd:
  host: 192.168.249.83:2379
bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
    use_pg_rewind: true
  initdb:
    - encoding: UTF8
    - data-checksums
  pg_hba:
    - host replication replicator   127.0.0.1/32 md5
    - host replication replicator   192.168.249.80/0   md5
    - host replication replicator   192.168.249.81/0   md5
    - host replication replicator   192.168.249.82/0   md5
    - host all all   0.0.0.0/0   md5
  users:
    admin:
       password: admin
       options:
       - createrole
       - createdb
postgresql:
   listen: 192.168.249.80:5432
   connect_address: 192.168.249.80:5432
   data_dir:     /data/patroni
   pgpass:     /tmp/pgpass
   authentication:
    replication:
      username:   replicator
      password:     "A1qaz2wsx3edc"
    superuser:
      username:   postgres
      password:     "B1qaz2wsx3edc"
      parameters:
      unix_socket_directories:  '.'
tags:
   nofailover:   false
   noloadbalance:   false
   clonefrom:   false
   nosync:   false

   # Configuration of patroni on node2:

 Create /etc/patroni.yml and add below lines to patroni.yml

on node 2
 sudo vi /etc/patroni.yml

# Add below lines

scope: postgres
namespace: /db/
name: node2
restapi:
  listen: 192.168.249.81:8008
  connect_address: 192.168.249.81:8008
etcd:
  host: 192.168.249.83:2379
bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
    use_pg_rewind: true
  initdb:
    - encoding: UTF8
    - data-checksums
  pg_hba:
    - host replication replicator   127.0.0.1/32 md5
    - host replication replicator   192.168.249.80/0   md5
    - host replication replicator   192.168.249.81/0   md5
    - host replication replicator   192.168.249.82/0   md5
    - host all all   0.0.0.0/0   md5
  users:
    admin:
       password: admin
       options:
       - createrole
       - createdb
postgresql:
   listen: 192.168.249.81:5432
   connect_address: 192.168.249.81:5432
   data_dir:     /data/patroni
   pgpass:     /tmp/pgpass
   authentication:
    replication:
      username:   replicator
      password:   "A1qaz2wsx3edc"
    superuser:
      username:   postgres
      password:   "B1qaz2wsx3edc"
      parameters:
      unix_socket_directories:  '.'
tags:
   nofailover:   false
   noloadbalance:   false
   clonefrom:   false
   nosync:   false

# Configuration of patroni on node3:

 Create /etc/patroni.yml and add below lines to patroni.yml

on node 3
```bash
 sudo vi /etc/patroni.yml
```
# Add below lines

scope: postgres
namespace: /db/
name: node3
restapi:
  listen: 192.168.249.82:8008
  connect_address: 192.168.249.82:8008
etcd:
  host: 192.168.249.83:2379
bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
    use_pg_rewind: true
  initdb:
    - encoding: UTF8
    - data-checksums
  pg_hba:
    - host replication replicator   127.0.0.1/32 md5
    - host replication replicator   192.168.249.80/0   md5
    - host replication replicator   192.168.249.81/0   md5
    - host replication replicator   192.168.249.82/0   md5
    - host all all   0.0.0.0/0   md5
  users:
    admin:
       password: admin
       options:
       - createrole
       - createdb
postgresql:
   listen: 192.168.249.82:5432
   connect_address: 192.168.249.82:5432
   data_dir:     /data/patroni
   pgpass:     /tmp/pgpass
   authentication:
    replication:
      username:   replicator
      password:   "A1qaz2wsx3edc"
    superuser:
      username:   postgres
      password:   "B1qaz2wsx3edc"
      parameters:
      unix_socket_directories:  '.'
tags:
   nofailover:   false
   noloadbalance:   false
   clonefrom:   false
   nosync:   false

   # Create patroni data directory on node1,node2 and node3
```bash
sudo mkdir -p  /data/patroni
sudo chown postgres:postgres /data/patroni/
sudo chmod 700 /data/patroni/
```
# Create systemd file for patroni on node1,node2,node3:
```bash
sudo vi  /etc/systemd/system/patroni.service
```
# Add below lines
[Unit]
Description=Patroni Orchestration
After=syslog.target network.target
[Service]
Type=simple
User=postgres
Group=postgres
ExecStart=/usr/local/bin/patroni /etc/patroni.yml
KillMode=process
TimeoutSec=30
Restart=no
[Install]
WantedBy=multi-user.targ

Start only patroni services on node1,node2,node3

  # Create systemd file 

cat /etc/systemd/system/patroni.service
[Unit]
Description=Patroni Orchestration
After=syslog.target network.target
[Service]
Type=simple
User=postgres
Group=postgres
ExecStart=/usr/local/bin/patroni /etc/patroni.yml
KillMode=process
TimeoutSec=30
Restart=no
[Install]
WantedBy=multi-user.targ
```bash
 sudo systemctl daemon-reload
 sudo systemctl start patroni
```
Add below lines in /etc/haproxy/haproxy.cfg on haproxy node:

 vi /etc/haproxy/haproxy.cfg
# Add lines to this config

global
      maxconn 100
defaults
      log global
      mode tcp
      retries 2
      timeout client 30m
      timeout connect 4s
      timeout server 30m
      timeout   check   5s
listen stats
      mode http
      bind *:7000
      stats enable
      stats uri /
listen postgres
      bind *:5000
      option httpchk
      http-check expect status 200
      default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
      server node1 192.168.249.80:5432 maxconn 100   check   port 8008
      server node2 192.168.249.81:5432 maxconn 100   check   port 8008
      server node3 192.168.249.82:5432 maxconn 100   check   port 8008
