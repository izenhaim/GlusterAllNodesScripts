#!/bin/bash
#check if all gluster services are running on machine
# flags for each process :
glusterFlag="false"
glusterfsdFlag="false"
glusterdFlag="false"
glusterfsFlag="false"
ps aux | grep gluster > /tmp/serv.txt # get all processes of gluster and put them in file
while read LINE # read through file lines to extract desired info 
do

        x=$(echo $LINE | tr "/n" "/n") # split line by " " (spaces)
        y=$(echo $x | awk '{print $11}') # put 11th element in z
        z=$(echo $x | awk '{print $12}') # put 12th element in y
        #check which process this line represents : 
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
                echo "UnrecognizedProcess" # if it was none of the above, it is an unrecognized process. 
        fi
done < /tmp/serv.txt # give file to 'while'
if [[ $glusterFlag == "false" || $glusterfsdFlag == "false" || $glusterdFlag == "false" || $glusterfsFlag == "false" ]]
then
        # alert zabbix 
        echo "DOWN"
else
        echo "OK"
fi