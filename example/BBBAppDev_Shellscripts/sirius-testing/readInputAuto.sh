#!/bin/bash

gpioInputRead=(121 122 123 124 127 133 134 135)
gpioInputReadVal=()
gpioInputReadValOld=()
for pin in "${gpioInputRead[@]}"
do
	echo in > /sys/class/gpio/gpio$pin/direction
done

while [ 1 ]; do
	for pin in "${!gpioInputRead[@]}"
	do
		pinNum=${gpioInputRead[$pin]}
		# echo $pinNum

		gpioInputReadVal[$pin]=$(cat /sys/class/gpio/gpio$pinNum/value)
		# echo "cat /sys/class/gpio/gpio$pinNum/value)"
		# echo "$pinNum is ${gpioInputReadVal[$pin]}"

		# if test ${gpioInputReadValOld[$pin]} -ne ${gpioInputReadVal[$pin]}
		if [ "${gpioInputReadValOld[$pin]}" != "${gpioInputReadVal[$pin]}" ];
		then
			gpioInputReadValOld[$pin]=$gpioInputReadVal[$pin]
			if [ ${gpioInputReadVal[$pin]} == 1 ]; then
				echo "$pinNum is high"
			else
				echo "$pinNum is low"
			fi
		fi

		# if test ${gpioInputReadValOld[$pin]} -ne 1
		# then
		# 	echo "$pin is high"
		# else
		# 	echo "$pin is low"
		# fi

	done
done