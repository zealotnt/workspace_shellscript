#!/bin/bash
 
cat /sys/class/thermal/thermal_zone0/temp > /tmp/tempTemp
tempVal=$(cat /tmp/tempTemp)
tempValOld=0
 
while [ 1 ]; do
	cat /sys/class/thermal/thermal_zone0/temp > /tmp/tempTemp
	tempVal=$(cat /tmp/tempTemp)
	if test $tempValOld -ne $tempVal
	then
		tempValOld=$tempVal
		echo "Current temp = $tempValOld"
	fi
done