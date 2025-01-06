#!/bin/bash

iptables ()
{
    apt install iptables-persistent -y
    while (true)
        do
            echo "Select iptables CHAIN: (INPUT, FORWARD, OUTPUT ) " chain
            if [ ${chain} == INPUT ]; then
                echo "Do you Want to Change Master CHAIN (y/n): " answer
                if [ ${answer} == y ]; then
                    echo "Select CHAIN Mode: (ACCEPT, REJECT, DROP, LOG, MASQURATE) " chainmode
                    iptables -P ${chain} ${chainmode}
                else
                    echo " Select Rule TYPE (Append, Insert, Delete): " ruletype
                    if [ ${ruletype} == Append ]; then
                        echo "Select iptables CHAIN: (INPUT, FORWARD, OUTPUT ) " rulechain
                        echo "Select Input / Output Interface (input or output): " interface
                        if [ ${interface} == input ]; then
                            echo ""
                        elif [ ${interface} == output ]; then

                        else
                            echo "Type Correct Answer. "
                    elif [ ${ruletype} == INSERT ]; then

                    elif [ ${ruletype} == Delete ]; then

                    else
                        echo "Type Correct Rule TYPE. "
                fi 
            elif [ ${chain} == FORWARD]; then

            elif [ ${chain} == OUTPUT]; then

            else
                echo "Type Correct CHAIN. "            
            fi
}