#!/bin/bash
glusterFlag="false"
glusterfsdFlag="false"
glusterdFlag="false"
glusterfsFlag="false"
ps aux | grep gluster > tmp
while read LINE
do

        x=$(echo $LINE | tr "/n" "/n")
        y=$(echo $x | awk '{print $11}')
        z=$(echo $x | awk '{print $12}')
        if [[ $z == "gluster" ]]
        then
                glusterFlag="true"
        elif [[ $y == "/usr/sbin/glusterfsd" ]]
        then
                glusterfsdFlag="true"
        elif [[ $y == "/usr/sbin/glusterfs" ]]
        then
                glusterfsFlag="true"
        elif [[ $y == "/usr/sbin/glusterd" ]]
        then
                glusterdFlag="true"
        else
                echo "sth"
        fi
done < tmp
if [[ $glusterFlag == "false" || $glusterfsdFlag == "false" || $glusterdFlag == "false" || $glusterfsFlag == "false" ]]
then
        # alert zabbix 
        echo "DOWN"
else
        echo "OK"
fi