#!/bin/bash

check_root ()
{
    if [ `whoami` == "root" ]; then
        echo "you are login with Root User"
    else
        echo "Please Login "root" User and Run Script Agein." 
        exit 1
    fi
}

nat ()
{
    path=/etc/netplan/50-cloud-init.yaml
    ping -c 2 8.8.8.8
    sudo ip -br a
    echo ""
    echo ""
    read -p "Enter IP Local Network: " local
    sudo echo ${local} > ./dg
    sudo apt update
    sudo apt install -y iptables-persistent net-tools
    sudo sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
    sudo /sbin/sysctl -p/etc/sysctl.conf
    sudo iptables -t nat -A POSTROUTING -j MASQUERADE
    sudo iptables -t nat -L
    sudo sh -c iptables-save > /etc/iptables/rules.v4
    sudo echo 'sed -i "s/version: 2/#    version: 2/g" '${path}'' >> net.sh
    sudo echo 'echo "            routes:" >> '${path}'' >> net.sh
    sudo echo 'echo "              - to: default" >> '${path}'' >> net.sh
    sudo echo 'echo "                via: `cat dg`" >> '${path}'' >> net.sh
    sudo echo 'echo "    version: 2" >> '${path}'' >> net.sh
}

default_gateway ()
{
    ping -c 2 8.8.8.8
    sleep 5
    chmod +x net.sh
    sudo bash ./net.sh
    sudo netplan apply
    sudo ip route show
    sleep 1
    ping -c 2 8.8.8.8
    sleep 2
    logout
}

ssh_keygen ()
{
    read -p "Enter Remote Server Username: " name
    read -p "Enter Remote Server IP: " ip
    ssh-keygen
    ssh-copy-id ${name}@${ip}
}

main ()
{
    check_root
    nat
    ssh_keygen
    rsync ./dg ${name}@${ip}:/home/${name}
    rsync ./net.sh ${name}@${ip}:/home/${name}
    ssh -T -t ${name}@${ip} <<EOF
    $(declare -f default_gateway)
    default_gateway
EOF
}
main