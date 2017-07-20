#!/bin/bash

SCRIPT_NAME=`basename "$0"`
HDR="[$SCRIPT_NAME]"

if [ ! -e /dev/mmcblk1 ]; then
	echo "$HDR No sdcard, suppose to do nothing"
	exit 0
fi

# We found sd card, mount all of them like the udev rule
for SD_DEV_NUM in {1..9}
do
	if [ -e /dev/mmcblk1p$SD_DEV_NUM ]; then
		echo "$HDR Detect mmcblk1p$SD_DEV_NUM, mount to /media/sd-mmcblk1p$SD_DEV_NUM"
		mkdir -p /media/sd-mmcblk1p$SD_DEV_NUM
		mount -o relatime /dev/mmcblk1p$SD_DEV_NUM /media/sd-mmcblk1p$SD_DEV_NUM
	fi
done
