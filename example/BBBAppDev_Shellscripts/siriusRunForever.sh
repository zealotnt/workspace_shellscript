#!/bin/bash
# To run this script automatically on Sirius board:
# copy this script to absolute path: /home/root/siriusRunLoop.sh
# $vi /etc/profile
# Search to end of file, insert:
# $bash /home/root/siriusRunLoop.sh
echo "Simple script that run sirius serial protocol forever!"
cd /home/root

while [ 1 ]; do
	./testSerialBBB -s 3
	echo "App quit, restart again"
done