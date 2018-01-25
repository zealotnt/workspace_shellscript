#!/bin/bash

set -x

# stress --cpu 1 --io 1 --vm 1 --hdd 1 &
stress --cpu 1 &

RESULT_FOLDER="/home/root/test_ota_result"
RESULT_FILE="$RESULT_FOLDER/test_ota_result.txt"
COUNT_FILE="$RESULT_FOLDER/test_ota_count.txt"
COUNT=0

if [ ! -d $RESULT_FOLDER ]; then
	mkdir -p $RESULT_FOLDER
fi

if [ ! -f $COUNT_FILE ]; then
	echo 0 > $COUNT_FILE
fi

check_number() {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]] ; then
	   return -1
	fi
	return 0
}

COUNT=$(cat $COUNT_FILE)
COUNT=$((COUNT+1))
echo $COUNT > $COUNT_FILE
LOG_FILE="$RESULT_FOLDER/log_$COUNT"

bash /home/root/temp/content/run.sh 2>&1 | tee $LOG_FILE
ret=${PIPESTATUS[0]}
set -x
CUR_DATE=$(date)
if [ $ret -eq 0 ]; then
	echo "$CUR_DATE : $LOG_FILE: SUCCESS" >> $RESULT_FILE
else
	echo "$CUR_DATE : $LOG_FILE: FAIL" >> $RESULT_FILE
fi

cp /home/root/new_profile /etc/profile
echo "Sleep 5 second before reset, retest ota"
sleep 5
reboot
