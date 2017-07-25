#!/bin/bash

SCRIPT_NAME=`basename "$0"`
HDR="[${SCRIPT_NAME}]"

umount /media/*

for STORAGE_DEV_NUM in {0..9}
do
	if [ ! -e /dev/mmcblk${STORAGE_DEV_NUM} ]; then
		continue
	fi

	SD_PART_PREFIX="mmcblk${STORAGE_DEV_NUM}p"
	SD_MOUNT_PREFIX="sd-$SD_PART_PREFIX"
	# We found sd card, mount all of them like the udev rule
	for SD_PART_NUM in {1..9}
	do
		if [ -e /dev/${SD_PART_PREFIX}${SD_PART_NUM} ]; then
			echo "$HDR Detect ${SD_PART_PREFIX}${SD_PART_NUM}, mount to /media/${SD_MOUNT_PREFIX}${SD_PART_NUM}"
			mkdir -p /media/${SD_MOUNT_PREFIX}${SD_PART_NUM}
			mount -o relatime /dev/${SD_PART_PREFIX}${SD_PART_NUM} /media/${SD_MOUNT_PREFIX}${SD_PART_NUM}
		fi
	done

done
