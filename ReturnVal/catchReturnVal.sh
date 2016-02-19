#!/bin/bash

case $# in
1)	valIn=$1
	;;
*)	echo "only 1 argument accepted"
	exit -1
	;;
esac

# this script will return what you put in it
./returnVal.sh $valIn
valOut=$?

# this script will always return -1
echo "going to call returnMinus1.sh"
./returnMinus1.sh
valMinus1=$?
if [ $valMinus1 != 255 ]; then
	echo "not expected"
	exit 2
fi

# this script will always return -2
echo "going to call returnMinus2.sh"
./returnMinus2.sh
valMinus2=$?

# this script will always return 1
echo "going to call returnPlus1.sh"
./returnPlus1.sh
valPlus1=$?

# this script will always return 2
echo "going to call returnPlus2.sh"
./returnPlus2.sh
valPlus2=$?

echo "Your input: $valIn"
echo "Shell returnMinus1.sh return $valMinus1"
echo "Shell returnMinus2.sh return $valMinus2"
echo "Shell returnPlus1.sh return $valPlus1"
echo "Shell returnPlus2.sh return $valPlus2"
echo "Shell return $valOut"						# $? is the return value from shell/program

