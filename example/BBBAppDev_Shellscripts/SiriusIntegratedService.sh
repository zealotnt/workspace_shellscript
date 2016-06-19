#!/bin/bash
HDR="[SHELL]"
KNRM="\033[0m"
KRED="\033[31m"
KGRN="\033[32m"
KYEL="\033[33m"
KBLU="\033[34m"
KMAG="\033[35m"
KCYN="\033[36m"
KWHT="\033[37m"

KLGRN="\033[92m"
KLRED="\033[91m"
KLYEL="\033[93m"
KLBLU="\033[94m"
KLMAG="\033[95m"
KLCYN="\033[96m"

# Console style print
KBOLD="\033[1m"
KUDLN="\033[4m"

# Reset all settings of console print
KRESET="\033[0m"
KRBOLD="\033[21m"

removeAndReplaceAppRetVal="NONE"
appRetVal=1

exportLed()
{
	if [ ! -d /sys/class/gpio/gpio150 ]; then
		echo 150 > /sys/class/gpio/export
	fi

	if [ ! -d /sys/class/gpio/gpio151 ]; then
		echo 151 > /sys/class/gpio/export
	fi

	if [ ! -d /sys/class/gpio/gpio152 ]; then
		echo 152 > /sys/class/gpio/export
	fi
}

resetMaxim()
{
	if [ ! -d /sys/class/gpio/gpio81 ]; then
		echo "Export GPIO81 to manually control it"
		echo 81 > /sys/class/gpio/export
	else
		echo "Already exported"
	fi
	echo "Going to pull reset pin high"
	echo high > /sys/class/gpio/gpio81/direction
	sleep 1
	echo "Going to pull reset pin low"
	echo low > /sys/class/gpio/gpio81/direction
	echo "Maxim ready to start over"	
}

turnOnLed()
{
	echo high > /sys/class/gpio/gpio150/direction
	echo high > /sys/class/gpio/gpio151/direction
	echo high > /sys/class/gpio/gpio152/direction
}

turnOffLed()
{
	echo low > /sys/class/gpio/gpio150/direction
	echo low > /sys/class/gpio/gpio151/direction
	echo low > /sys/class/gpio/gpio152/direction	
}


removeAndReplaceApp()
{
	sleep 1
	if [ -f xmsdk ]; then
		if [ -f tempApp ]; then

			echo -e "${KRED}${KBOLD}Backing up old app${KRESET}"
			mv xmsdk xmsdk.bak

			sleep 1
			echo -e "${KRED}${KBOLD}Rename new app${KRESET}"
			mv tempApp xmsdk

			sleep 1
			chmod +x xmsdk
			echo -e "${KRED}${KBOLD}$HDR Upgrade and write to memory complete${KRESET}"
			sleep 1

			# Return Success
			removeAndReplaceAppRetVal="SUCCESS"
		else
			echo -e "${KRED}${KBOLD}Not found tempApp, rerun !!!${KRESET}"
			# Return Fail
			removeAndReplaceAppRetVal="RERUN"
		fi
	else
		echo -e "${KRED}${KBOLD}xmsdk app not found, quit !!!${KRESET}"
		# Force script to exit
		removeAndReplaceAppRetVal="EXIT"
	fi
}

exportLed
# resetMaxim
turnOnLed
bReRun=y
while [ "$bReRun" == "y" ]; do
	case $appRetVal in
	0)	echo -e "${KRED}${KBOLD}App exit and want to upgrade itself !!!${KRESET}"
		removeAndReplaceApp
		case "$removeAndReplaceAppRetVal" in
		"SUCCESS")	echo -e "${KLYEL} Upgrade app successfully, run app with \"App_Upgrade_Flag\" set to True ${KRESET}"
					./xmsdk Upgrade_Successfully
					appRetVal=$?
					;;
		"EXIT")		exit 1
					;;
		*)	echo -e "${KLYEL} Run app with \"App_Upgrade_Flag\" set to False ${KRESET}"
			./xmsdk
			appRetVal=$?
			;;
		esac
		;;
	*)	echo -e "${KRED}${KBOLD}Unexpected return code, rerun app !!!${KRESET}"
		./xmsdk
		appRetVal=$?
		echo "appRetVal=$appRetVal"
		sleep 2
		;;
	esac
done