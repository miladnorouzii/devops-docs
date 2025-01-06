
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y postgresql postgresql-contrib


psql --version


sudo systemctl start postgresql


sudo systemctl enable postgresql

sudo nano /etc/postgresql/{version}/main/postgresql.conf

listen_addresses = '*'

sudo nano /etc/postgresql/{version}/main/pg_hba.conf

host    all             all             192.168.0.0/24          md5


sudo systemctl restart postgresql


sudo -u postgres psql


CREATE DATABASE mydatabase;


CREATE USER myuser WITH PASSWORD 'mypassword';


GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;


\q


curl https://binaries.cockroachdb.com/cockroach-v23.1.4.linux-amd64.tgz | tar -xz
sudo cp cockroach-v23.1.4.linux-amd64/cockroach /usr/local/bin/


cockroach version

cockroach start --insecure --listen-addr=127.0.0.1 --http-addr=127.0.0.1:8080 --join=<Node2_IP>:26257,<Node3_IP>:26257 --store=path=/mnt/data/cockroach --background

cockroach start --insecure --listen-addr=127.0.0.2 --http-addr=127.0.0.2:8080 --join=<Node1_IP>:26257,<Node3_IP>:26257 --store=path=/mnt/data/cockroach --background

cockroach start --insecure --listen-addr=127.0.0.3 --http-addr=127.0.0.3:8080 --join=<Node1_IP>:26257,<Node2_IP>:26257 --store=path=/mnt/data/cockroach --background

cockroach init --insecure --host=127.0.0.1:26257

cockroach node status --insecure --host=127.0.0.1:26257

http://<Node_IP>:8080

cockroach sql --insecure --host=127.0.0.1:26257


CREATE DATABASE mydatabase;


CREATE USER myuser WITH PASSWORD 'mypassword';


GRANT ALL ON DATABASE mydatabase TO myuser;


\q


sudo nano /etc/systemd/system/cockroach.service

[Unit]
Description=CockroachDB
After=network.target

[Service]
ExecStart=/usr/local/bin/cockroach start --insecure --listen-addr=127.0.0.1 --http-addr=127.0.0.1:8080 --join=<Node2_IP>:26257,<Node3_IP>:26257 --store=path=/mnt/data/cockroach
Restart=always
User=root
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target

sudo systemctl daemon-reload
sudo systemctl enable cockroach
sudo systemctl start cockroach

