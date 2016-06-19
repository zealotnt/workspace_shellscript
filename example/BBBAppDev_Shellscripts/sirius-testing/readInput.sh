#!/bin/bash

gpioInputRead=(121 122 123 124 127 133 134 135)

for pin in "${gpioInputRead[@]}"
do
	echo in > /sys/class/gpio/gpio$pin/direction
done

for pin in "${gpioInputRead[@]}"
do
	gpioVal=$(cat /sys/class/gpio/gpio$pin/value)
	if [ gpioVal == 1 ]; then
		echo "$pin is high"
	else
		echo "$pin is low"
	fi
done