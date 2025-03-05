1. config 2 server (srv1 and srv2)
   
   srv1 have 2 network adapter enss33(192.168.1.10/24) and enss37(10.10.10.1/24)

   srv2 have 1 network adapter enss33(10.10.10.2/24) and the gateway(10.10.10.1)

   two servers shuld ping echother.

   we have internet access in srv1 and we want to have internet access in srv2 via srv1.

   continue wuth root access

2. in srv2 edit the file /etc/sysctl.conf and uncomment  “net.ipv4.ip_forward”
   ```bash
    sysctl –p
   ```
3. install the iptables-persistent package
   ```bash
   apt install iptables-persistent
   ```
4. list the corrent configuration
   ```bash
   iptables –L
   ```
5. now mask the requests from inside the LAN with the external IP of NAT router
   ```bash
   iptables -t nat -A POSTROUTING -j MASQUERADE
   iptables -t nat –L
   ```
6. save the iptable rulse
   ```bash
   sudo sh -c “iptables-save > /etc/iptables/rules.v4”
   ```
7. now we can access the internet from srv2