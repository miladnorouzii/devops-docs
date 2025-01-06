sudo apt update
sudo apt install haproxy

sudo systemctl start haproxy
sudo systemctl enable haproxy

sudo nano /etc/haproxy/haproxy.cfg



global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /usr/share/haproxy
    stats socket /var/run/haproxy.sock mode 660 level admin
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    option  httplog
    option  dontlognull
    timeout connect 5000ms
    timeout client  50000ms
    timeout server  50000ms

frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    option httpchk GET /health
    server web1 <BACKEND_SERVER_1_IP>:80 check
    server web2 <BACKEND_SERVER_2_IP>:80 check

listen stats
    bind *:8080
    stats enable
    stats uri /haproxy_stats
    stats refresh 30s
    stats auth <username>:<password> 



from flask import Flask

app = Flask(__name__)

@app.route('/health')
def health_check():
    return "Healthy", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)

sudo systemctl restart haproxy



local0.*    /var/log/haproxy.log
local1.*    /var/log/haproxy.log

sudo systemctl restart rsyslog

tail -f /var/log/haproxy.log
