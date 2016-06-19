#!/bin/bash

# Setup config on 3PCB
# echo "Setup Serial for UART1 on Maxim <--> UART2 on A9 <--> ttymxc1"
# stty -F /dev/ttymxc1 speed 115200 cs8 -cstopb -parenb
# echo "Setup Serial for UART0 on Maxim <--> UART5 on A9 <--> ttymxc4"
# stty -F /dev/ttymxc4 speed 115200 cs8 -cstopb -parenb
# echo "Setup Serial connection to Host <--> UART4 on A9 <--> ttymxc3"
# stty -F /dev/ttymxc3 speed 115200 cs8 -cstopb -parenb

# Setup config on P1
echo "Setup Serial for UART1 on Maxim <--> UART5 on A9 <--> ttymxc4"
stty -F /dev/ttymxc4 speed 115200 cs8 -cstopb -parenb
echo "Setup Serial for UART0 on Maxim <--> UART4 on A9 <--> ttymxc3"
stty -F /dev/ttymxc3 speed 115200 cs8 -cstopb -parenb
echo "Setup Serial connection to Host <--> UART2 on A9 <--> ttymxc1"
stty -F /dev/ttymxc1 speed 115200 cs8 -cstopb -parenb


# Test high speed:
# stty -F /dev/ttymxc1 speed 460800 cs8 -cstopb -parenb
# stty -F /dev/ttymxc1 speed 230400 cs8 -cstopb -parenb
# stty -F /dev/ttyO4 speed 460800 cs8 -cstopb -parenb #UART4 on BBB
# stty -F /dev/ttyO4 speed 230400 cs8 -cstopb -parenb #UART4 on BBB