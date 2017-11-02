#!/bin/bash

# (c) Copyright 2017 tuyenpham <pham.thanh.tuyen@styl.com.vn>
# Licensed under terms of GPLv2

export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin

UPGRADE_PATH=/upgrade/styl
MOUNT_POINT=/upgrade
UBOOT_IMAGE=u-boot.imx
UIMAGE_IMAGE=uImage
DTB_IMAGE=*.dtb
ROOTFS_IMAGE=rootfs.tar.gz
#define error code
# ERR_USB_NOT_FOUND=1
# ERR_EXTRACT_ROOT=2

trap_usr_interrupt()
{
  echo "Flashing is running. Don't stop me!"
}

trap_error_cmd()
{
  #trap error when excute command
  echo "Error Occured $1"
  case "$1" in
   "ERR_USB_NOT_FOUND") echo "USB Not Found." ;
                        cat /home/root/pics/flash_error.raw > /dev/fb0
   ;;
   "ERR_EXTRACT_ROOT")  echo "Extract Rootfs Error.";
                        cat /home/root/pics/flash_error.raw > /dev/fb0
   ;;
  esac
  #stty -echo
  exit;
}

scan_usb_dev()
{
  file_usb_dev="."
  umount ${MOUNT_POINT}

  for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
  do
    #echo "test $i "
    if [ -e "/dev/sd$i" ]
      then
        #echo "found $i"
        for j in 1 2 3 4 5 6 7 8 9 10
        do
          if [ -e "/dev/sd$i$j" ]
            then
            # echo "good $i$j"
            mount "/dev/sd$i$j" ${MOUNT_POINT}
            if [ -f "$UPGRADE_PATH/${ROOTFS_IMAGE}" ] || [ -f "$UPGRADE_PATH/${UIMAGE_IMAGE}" ]
              then
              #echo echo "good image at: $i$j"
              file_usb_dev="/dev/sd$i$j"
              #umount /media
              return 0;
            fi
            umount ${MOUNT_POINT}
          fi
        done
    # else
    #    echo "not found"
    fi
  done
  echo "Finished scan "
  return 1;
}


#sleep 5
echo "===============USB Flasher================"
#trap '' SIGHUP SIGTERM SIGINT TSTP
#stty -ixon -echo

#stty -echo
#create mount point
if ! [ -d ${MOUNT_POINT} ]; then
  mkdir -p ${MOUNT_POINT}
fi

scan_usb_dev
if [ $? -eq 1 ]; then
  echo "No USB or Image Found"
  trap_error_cmd "ERR_USB_NOT_FOUND"
else
  echo "Found Image at: $file_usb_dev"
fi

#echo on LCD
cat /home/root/pics/flashing.raw > /dev/fb0

# Burn U-boot
#check file u-boot.imx is valid

# if [ -f "$UPGRADE_PATH/${UBOOT_IMAGE}" ]
# then
#   echo "File ${UBOOT_IMAGE} is valid ================================>USB@@@Burning U-boot"
#   #echo "================================>USB@@@Burning U-boot"
#   #sh /boot/mksdcard.sh /dev/mmcblk0
#   dd if=/dev/zero of=/dev/mmcblk0 bs=1k seek=384 conv=fsync count=129
#   echo 0 > /sys/block/mmcblk5boot0/force_ro
#   dd if=/dev/zero of=/dev/mmcblk5boot0 bs=512 seek=2 count=1000
#   dd if=${UPGRADE_PATH}/u-boot.imx of=/dev/mmcblk5boot0 bs=512 seek=2
#   echo 1 > /sys/block/mmcblk5boot0/force_ro
#   echo 8 > /sys/block/mmcblk0/device/boot_config
#   #bus console VERSION=v1.0.0 2016.11.25
#   sleep 1
#   sync
# else
#   echo "File ${UBOOT_IMAGE} is not valid ==> Don't upgrade u-boot"
# fi


#check file uImage is valid
if [ -f "$UPGRADE_PATH/${UIMAGE_IMAGE}" ]
then
  #check signature
  sh ./verify.sh ${UPGRADE_PATH}/uImage ${UPGRADE_PATH}/uImage.sig  stylorca7public.pem
  if [ $? -eq 1 ]; then trap_error_cmd "ERR_EXTRACT_ROOT"
  fi
  echo "File ${UIMAGE_IMAGE} is valid ================================>USB@@@Create fat partition"
  #echo "================================>USB@@@Create fat partition"
  umount /dev/mmcblk0p1
  #mkfs.vfat /dev/mmcblk0p1
  mkdir -p /mnt/mmcblk0p1
  mount -t vfat /dev/mmcblk0p1 /mnt/mmcblk0p1

  #Burn uImage and dtb
  echo "================================>USB@@@Burning uImage"
  cp ${UPGRADE_PATH}/uImage /mnt/mmcblk0p1/uImage
  #check file file .dtb is valid
  files=$(ls $UPGRADE_PATH/${DTB_IMAGE} 2> /dev/null | wc -l)
  if [ "$files" != "0" ]
  then
     echo "File ${DTB_IMAGE} is valid ================================>USB@@@Burning dtb"
     #echo "================================>USB@@@Burning dtb"
     cp ${UPGRADE_PATH}/*.dtb /mnt/mmcblk0p1/
  else
     echo "File ${DTB_IMAGE} is not valid ==> Don't upgrade dtb"
  fi
  sync
  umount /mnt/mmcblk0p1
else
  echo "File ${UIMAGE_IMAGE} is not valid ==> Don't upgrade uImage"
fi



#check file rootfs.tar.gz is valid
if [ -f "$UPGRADE_PATH/${ROOTFS_IMAGE}" ]
then
  #check signature
  sh ./verify.sh ${UPGRADE_PATH}/rootfs.tar.gz ${UPGRADE_PATH}/rootfs.tar.gz.sig  stylorca7public.pem
  if [ $? -eq 1 ]; then trap_error_cmd "ERR_EXTRACT_ROOT"
  fi
  echo "File ${ROOTFS_IMAGE} is valid ================================>USB@@@Burning rootfs"
  # Burn rootfs main
  #echo "================================>USB@@@Burning rootfs"
  umount /dev/mmcblk0p3
  yes | mkfs.ext3 -E nodiscard /dev/mmcblk0p3 || trap_error_cmd "ERR_EXTRACT_ROOT"
  #mke2fs -jE nodiscard /dev/mmcblk0p3
  mkdir -p /mnt/mmcblk0p3
  mount -t ext3 /dev/mmcblk0p3 /mnt/mmcblk0p3
  tar -zxf ${UPGRADE_PATH}/rootfs.tar.gz -C /mnt/mmcblk0p3/ || trap_error_cmd "ERR_EXTRACT_ROOT"
  sync
  chown -R root:root /mnt/mmcblk0p3/
  umount /mnt/mmcblk0p3
else
  echo "File ${ROOTFS_IMAGE} is not valid ==> Don't upgrade rootfs"
fi

# # Burn rootfs update
# # echo "================================>Burning rootfs update"
# # umount /dev/mmcblk0p2
# # mkfs.ext3 -E nodiscard /dev/mmcblk0p2
# # mkdir -p /mnt/mmcblk0p2
# # mount -t ext3 /dev/mmcblk0p2 /mnt/mmcblk0p2
# # tar -xvf /boot/rootfs_upgrade.tar -C /mnt/mmcblk0p2/
# # sync
# # chown -R root:root /mnt/mmcblk0p2/
# # umount /mnt/mmcblk0p2



# #Enable boot config
# x=1
# while [ $x -le 1 ]
# do
#   echo 8 > /sys/block/mmcblk0/device/boot_config
#   cat /sys/block/mmcblk0/device/boot_info > test.txt
#   if grep -q "BOOT_PARTITION-ENABLE: 1" test.txt;
#   then
#       x=$(( $x + 1 ))
#     echo "Boot Partition has been enabled"
#   else
#     echo 8 > /sys/block/mmcblk0/device/boot_config
#     echo "Enable Boot Partition"
#   fi
#   rm test.txt
# done
#update fw for orcanfc
orca_fw=$(ls ${UPGRADE_PATH}/orcanfc-fw-updater/*.tar 2> /dev/null | wc -l)
if [ "$orca_fw" != "0" ]
then
	echo "update fw orca-nfc"
	#check signature
  sh ./verify.sh ${UPGRADE_PATH}/orcanfc-fw-updater/*.tar ${UPGRADE_PATH}/orcanfc-fw-updater/*.sig  stylorca7public.pem
  if [ $? -eq 1 ]; then trap_error_cmd "ERR_EXTRACT_ROOT"
  fi
	sh ${UPGRADE_PATH}/orcanfc-fw-updater/onNfc.sh
	sh ${UPGRADE_PATH}/orcanfc-fw-updater/orcanfc-updater.sh -p ${STYL_SVC_RF_CMD} -f ${UPGRADE_PATH}/orcanfc-fw-updater/*.tar -t ALL
fi
###############################
umount ${MOUNT_POINT}
#remove file boot_config.txt in /dev/mmcblk0p1
mount /dev/mmcblk0p1 ${MOUNT_POINT}
rm -f ${MOUNT_POINT}/boot_config.txt
sync
umount ${MOUNT_POINT}

#echo on LCD
cat /home/root/pics/flash_complete.raw > /dev/fb0
echo ".............................."
echo "......Finish USB flashing....."
echo ".............................."
