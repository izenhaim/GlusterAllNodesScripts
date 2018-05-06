#!/bin/bash
peerNumberFlag="false" #for checing the Number of Peers: n line in peer status
connectedNum=0 # for the number of connected peers 
gluster peer status > /tmp/tmp2.txt # put the gluster peer status result in file 
while read LINE  # read file lines to parse and extract desired parts 
do
        if [[ $LINE == "Number of Peers: 3" ]]
        then
                peerNumberFlag="true"
        else
                x=$(echo $LINE | tr "/n" "/n") # split Line for " " (spaces) 
                y=$(echo $x | awk '{print $1}') # put first element in y
                z=$(echo $x | awk '{print $5}') # put fifth element in y
                if [[ $y == "State:" && $z == "(Connected)" ]]
                then
                        connectedNum=$(($connectedNum+1)) # increase number of connected nodes 
                fi
        fi
done < /tmp/tmp2.txt # give file to 'while'
if [[ $peerNumberFlag == "true"  && $connectedNum == "3" ]]
 then
        echo "Connected"
else
        # alert zabbix 
        echo "DissConnected"
fi