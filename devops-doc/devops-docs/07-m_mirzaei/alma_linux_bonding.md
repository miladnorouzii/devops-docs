# Configuring a network bond 
# display network devices
```bash
 nmcli device
 ```

# delete existing network connections
```bash
 nmcli connection delete enp1s0
 ```

# add a new teaming device [team0] 
```bash
 nmcli connection add type team con-name team0 ifname team0 config '{"runner": {"name": "roundrobin"}}'
```

# add member devices to the teaming device
```bash
 nmcli connection add type team-slave con-name team0-member0 ifname enp1s0 master team0

 nmcli connection add type team-slave con-name team0-member1 ifname enp7s0 master team0

 nmcli connection
```

# set IP address and so on to the teaming device and restart it
```bash
 nmcli connection modify team0 ipv4.addresses 10.0.0.30/24

 nmcli connection modify team0 ipv4.gateway 10.0.0.1

 nmcli connection modify team0 ipv4.dns "10.0.0.10 10.0.0.11"

 nmcli connection down team0 && nmcli connection up team0
```

# verify teaming state
```bash
 teamdctl team0 state
 ```

# configuration files are stored under the place
```bash
 ll /etc/NetworkManager/system-connections
 ```
