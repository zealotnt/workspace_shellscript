#!/bin/bash

getDeviceBaseOnDiff()
{
	printf '%s\n' "$diff" | {
		while IFS= read -r line; do
			if [[ $line =~ [+]sd.[1-9] ]]; then
				# printf '%d. %s \r\n' "$count" "$line"
				itemToMount=$line
				itemToMount="${itemToMount//+}"
				echo "$itemToMount"
				exit 0
			fi
		done
	}
}

mountDevice()
{
	echo "Going to mount $item to /media/usb"
	if [ ! -d "/media/usb" ]; then
		mkdir /media/usb
	fi
	mount "/dev/$item" /media/usb
}

copyFileToUSBAndUmount()
{
	echo "Copying $fileToCopy to /media/usb..."
	cp "$fileToCopy" /media/usb
	sync
	echo "Copy finished"
	umount /media/usb
}

case $# in
1)	readonly fileToCopy=$1
	;;
*)	echo "Syntax: testUSBThumbDrive.sh <fileToCopy>"
	exit 2
	;;
esac


read -p "Please plug out all of USB thumbdrive device and press enter to begin testing!"

if [ -d "$fileToCopy" ]; then
	echo "$1 is a directory"
	exit 1
elif [ -f "$fileToCopy" ]; then
	echo "Waiting for plugging in test USB thumbdrive (FAT filesystem)..."
fi


while [ 1 ]; do

	first=$(ls /dev/ | grep sd.)
	let count=0

	while [ 1 ]; do
		compare=$(ls /dev/ | grep sd.)
		diff=$(diff -u <(echo "$first") <(echo "$compare"))
		# There is some differece, let's check
		if [ "$diff" != "" ]; then
			sleep 1s
			compare=$(ls /dev/ | grep sd.)
			diff=$(diff -u <(echo "$first") <(echo "$compare"))
			first=$(ls /dev/ | grep sd.)
			compare=$(ls /dev/ | grep sd.)
			item=$(getDeviceBaseOnDiff)

			if [ "$item" == "" ]; then
				echo "USB removed"
				break
			fi


			mountDevice
			copyFileToUSBAndUmount

			echo "Please plug out the usb thumbdrive, then plug it in again!!!"
			while [ -e "/dev/$item" ]; do
				sleep 1s
			done
			echo "USB thumbdrive was plugged out!"

			#echo "Then plug your usb in again"
			first=$(ls /dev/ | grep sd.)



			while [ 1 ]; do
				compare=$(ls /dev/ | grep sd.)
				diff=$(diff -u <(echo "$first") <(echo "$compare"))
				if [ "$diff" != "" ]; then
					item=$(getDeviceBaseOnDiff)
					break
				else
					sleep 1s
				fi
			done

			echo "USB thumbdrive is plugged in!"
			mountDevice
			echo "Comparing copied file..."
			
			fileName=$(basename $fileToCopy)

			diff=$(diff -u $1 /media/usb/$fileName)

			if [ "$diff" == "" ]; then
				if [ -f "/media/usb/$fileName" ]; then
					echo "File exactly same, read/write successfully!"
				else
					echo "No file found, read/write or mount fail !"
				fi
			else
				echo "File different, read/write fail !"
			fi

			umount /media/usb
			exit 0
		fi
	done

done
