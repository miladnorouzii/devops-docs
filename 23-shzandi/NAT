nat in linux


you have two NIC

## step 1 ##

Suppose the ENS33 is a LAN network and the ENS37 is connected to the Internet network.

at First you need to enable IP forwarding

```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```
After saving the file, run the following command to load the changes:

```bash
sudo sysctl -p
```

## step2 ##

Configuring NAT with iptables

```bash
sudo iptables -t nat -A POSTROUTING -o ens37 -j MASQUERADE
```

## step 3 ##

After configuring NAT, you need to save the iptables settings

```bash
sudo iptables-save > /etc/iptables/rules.v4
```

## step 4 ##

Be sure to test and review the settings before saving them

