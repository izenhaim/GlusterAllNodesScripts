#!/bin/bash
bOnlineNum=0
dOnlineNum=0
gluster volume status > /tmp/volstat.txt
while read LINE
do
        x=$(echo $LINE | tr "/n" "/n")
        y=$(echo $x | awk '{print $1}')
        z=$(echo $x | awk '{print $5}')
        m=$(echo $x | awk '{print $7}')
        if [[ $y == "Brick" ]]
        then
                if [[ $z == "Y" ]]
                then
                        bOnlineNum=$(($bOnlineNum + 1))
                fi
        else
                if [[ $y == "Self-heal" ]]
                then
                        if [[ $m == "Y" ]]
                        then
                                dOnlineNum=$(($dOnlineNum+1))
                        fi
                fi
        fi
done < /tmp/volstat.txt
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