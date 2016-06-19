#!/bin/bash

currentDir=$(pwd)

#####################################################################
# Setup environment
#####################################################################
cd /home/root/secureROM-Sirius
bash setup.sh linux ./


#####################################################################
# Going to loadkey to Maxim
#####################################################################
cd /home/root/secureROM-Sirius/Host/customer_scripts/scripts/

bash ./sendscp_mod.sh /dev/ttymxc3 buildSCP/prod_p3_write_crk/ y
retVal=$?

if [ $retVal != 0 ]; then
	echo "Can't loadkey to board !!!"
else 
	echo "Loadkey successfully !!!"
fi

#####################################################################
# Going load settings to OTP
#####################################################################
bash ./sendscp_mod.sh /dev/ttymxc3 buildSCP/OTP_UART_250ms/ y
retVal=$?

if [ $retVal != 0 ]; then
	echo "Can't load OTP settings !!!"
else 
	echo "Load OTP settings successfully !!!"
fi

#####################################################################
# Going to load App to Maxim
#####################################################################
bash ./sendscp_mod.sh /dev/ttymxc3 buildSCP/maximFw/ y
retVal=$?

if [ $retVal != 0 ]; then
	echo "Can't flash firmware to board !!!"
else 
	echo "Firmware flash successfully !!!"
fi

exit 0