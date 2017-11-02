#!/bin/bash

TIME="`date +"%Y%m%d-%T"`"
LOG_FILE=/home/root/.reboot.log

sleep 60

echo "[${TIME}]: Invoke reboot" >> ${LOG_FILE} && sync && reboot


