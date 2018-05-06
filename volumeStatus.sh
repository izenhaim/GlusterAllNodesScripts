#!/bin/bash
bOnlineNum=0 # number of Online bricks 
dOnlineNum=0 # number of Online deamons
gluster volume status > /tmp/volstat.txt # put the 'gluster volume status' result in file
while read LINE # read through file to extract desired info 
do
        x=$(echo $LINE | tr "/n" "/n") # split line by " " (spaces)
        y=$(echo $x | awk '{print $1}') # put first element in y
        z=$(echo $x | awk '{print $5}') # put 5th element in z
        m=$(echo $x | awk '{print $7}') # put 7th element in m
        if [[ $y == "Brick" ]] # check if is a brick status line 
        then
                if [[ $z == "Y" ]] # check if brick Online status is Yes
                then
                        bOnlineNum=$(($bOnlineNum + 1))
                fi
        else
                if [[ $y == "Self-heal" ]]  # check if is a deamon status line 
                then
                        if [[ $m == "Y" ]] # check if deamon Online status is Yes
                        then
                                dOnlineNum=$(($dOnlineNum+1))
                        fi
                fi
        fi
done < /tmp/volstat.txt # give file to 'while'
if [[ $bOnlineNum == "4"  && $dOnlineNum == "4" ]]
then
     echo "OK"
else
     if [[ $bOnlineNum != "4" ]]
         then
        echo "brickDown"
    else
        echo "deamonDown"
    fi
fi