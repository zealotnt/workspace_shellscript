#!/bin/bash

SCRIPT_NAME=`basename "$0"`
HDR="[${SCRIPT_NAME}]"
SD_DEV="mmcblk1"
SD_PART_PREFIX="${SD_DEV}p"
SD_MOUNT_PREFIX="sd-$SD_PART_PREFIX"

if [ ! -e /dev/SD_DEV ]; then
	echo "$HDR No sdcard, suppose to do nothing"
	exit 0
fi

# We found sd card, mount all of them like the udev rule
for SD_DEV_NUM in {1..9}
do
	if [ -e /dev/$SD_PART_PREFIX$SD_DEV_NUM ]; then
		echo "$HDR Detect $SD_PART_PREFIX$SD_DEV_NUM, mount to /media/$SD_MOUNT_PREFIX$SD_DEV_NUM"
		mkdir -p /media/$SD_MOUNT_PREFIX$SD_DEV_NUM
		mount -o relatime /dev/$SD_PART_PREFIX$SD_DEV_NUM /media/$SD_MOUNT_PREFIX$SD_DEV_NUM
	fi
done
