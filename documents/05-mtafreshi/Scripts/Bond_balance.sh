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

check_bond()
{
    sudo apt update
    sudo apt install ifenslave net-tools -y
    lsmod | grep bond
    if [ `$?` == 0 ]; then
        echo "Bond Module is Loaded. "
        sleep 2
    else
        echo "Bond Module is NOT Loaded. "
        sleep 2
        sudo modprobe bonding
    fi
}

configure_bond_active_backup ()
{
path=/etc/netplan/50-cloud-init.yaml
    echo "Check your Ethernet with 'ifconfig'"
    ifconfig
    sleep 10
    ifconfig | awk $'{print $1}' > eth
    sort eth | uniq -u | cut -d : -f 1 > seth
    cat seth
    read -p "How much Ethernet join to Bond? " num
    for (( i=1; i<=${num}; i++ ));
        do
            read -p "Select Ethernet name: " temp
            sudo ifconfig $temp down
            echo "${temp}" > file"${i}"
        done
    read -p "Enter your Bond Number: (Example: 1) " number
    echo bond"${number}" > bond
    #if [ ${number} -eq int() ]; then
        sudo ip link add bond${number} type bond mode 802.3ad
        sleep 2
        for (( i=1; i<=${num}; i++ ));
            do
                sudo ip link set `cat file"${i}"` master bond${number}
            done
        sudo ifconfig bond${number} up
        read -p "Enter IP Address with Prefix for Bond Adapter: (Example: 192.168.10.1/24) " ip
        echo ${ip} > IP
        sudo sed -i -e 's/^/              - /' IP
        echo "    bonds:" >> ${path}
        echo "        "`cat bond`":" >> ${path}
        for (( i=1; i<=${num}; i++ ));
            do
                echo "`cat file${i}`" >> final
                echo "-" >> symbol
            done
        paste -d " " symbol final > net
        sudo sed -i -e 's/^/              /' net
        sudo sed -i "s/version: 2/#    version: 2/g" ${path}
        echo "            interfaces:" >> ${path}
        echo "`cat net`" >> ${path}
        echo "            addresses:" >> ${path}
        echo "`cat IP`" >> ${path}
        echo "            parameters:" >> ${path}
        echo "                mode: active-backup" >> ${path}
        echo "                transmit-hash-policy: layer3+4" >> ${path}
        echo "                mii-monitor-interval: 1" >> ${path}
        echo "            nameservers:" >> ${path}
        echo "                addresses: []" >> ${path}
        echo "                search: []" >> ${path}
        echo "    version: 2" >> ${path}
        sudo netplan apply
        sudo modprobe bonding
        sudo rm file1 final net symbol eth file2 IP seth bond
        sleep 5
        sudo ifconfig bond${number}
        sleep 5
        sudo ethtool bond${number}
}

configure_bond_balance ()
{
    path=/etc/netplan/50-cloud-init.yaml
    echo "Check your Ethernet with 'ifconfig'"
    ifconfig
    sleep 10
    ifconfig | awk $'{print $1}' > eth
    sort eth | uniq -u | cut -d : -f 1 > seth
    cat seth
    read -p "How much Ethernet join to Bond? " num
    for (( i=1; i<=${num}; i++ ));
        do
            read -p "Select Ethernet name: " temp
            sudo ifconfig $temp down
            echo "${temp}" > file"${i}"
        done
    read -p "Enter your Bond Number: (Example: 1) " number
    echo bond"${number}" > bond
    #if [ ${number} -eq int() ]; then
        sudo ip link add bond${number} type bond mode balance-rr
        sleep 2
        for (( i=1; i<=${num}; i++ ));
            do
                sudo ip link set `cat file"${i}"` master bond${number}
            done
        sudo ifconfig bond${number} up
        read -p "Enter IP Address with Prefix for Bond Adapter: (Example: 192.168.10.1/24) " ip
        echo ${ip} > IP
        sudo sed -i -e 's/^/              - /' IP
        echo "    bonds:" >> ${path}
        echo "        "`cat bond`":" >> ${path}
        for (( i=1; i<=${num}; i++ ));
            do
                echo "`cat file${i}`" >> final
                echo "-" >> symbol
            done
        paste -d " " symbol final > net
        sudo sed -i -e 's/^/              /' net
        sudo sed -i "s/version: 2/#    version: 2/g" ${path}
        echo "            interfaces:" >> ${path}
        echo "`cat net`" >> ${path}
        echo "            addresses:" >> ${path}
        echo "`cat IP`" >> ${path}
        echo "            parameters:" >> ${path}
        echo "                mode: balance-rr" >> ${path}
        echo "                mii-monitor-interval: 100" >> ${path}
        echo "            nameservers:" >> ${path}
        echo "                addresses: []" >> ${path}
        echo "                search: []" >> ${path}
        echo "    version: 2" >> ${path}
        sudo netplan apply
        sudo modprobe bonding
        sudo rm file1 final net symbol eth file2 IP seth bond
        sleep 5
        sudo ifconfig bond${number}
        sleep 5
        sudo ethtool bond${number}
    #else
        #echo "Run Script Again and Please Enter Correct Number. " 
    #fi
}

main ()
{
    check_root
    check_bond
    configure_bond_balance
}
main