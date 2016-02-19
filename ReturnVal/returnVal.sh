#!/bin/bash
case $# in
1)	val=$1
	;;
*)	echo "only 1 argument accepted"
	exit -1
	;;
esac
exit $val
