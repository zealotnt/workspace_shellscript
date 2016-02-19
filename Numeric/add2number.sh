#!/bin/bash

# Example of adding 2 number, and using numeric comparison
# Reference:
# https://bash.cyberciti.biz/guide/Numeric_comparison

read -p "Enter two numbers : " x y
read -p "Enter comparison value : " compVal

ans=$((x+y))
echo "$x + $y = $ans"

echo "Comparing $ans and $compVal"

# -eq: equal
if test $ans -eq $compVal
then
	echo "-eq"
fi

# -ge: greater than or equal
if test $ans -ge $compVal
then
	echo "-ge"
fi

# -gt: greater than
if test $ans -gt $compVal
then
	echo "-gt"
fi

# -le: less than or equal
if test $ans -le $compVal
then
	echo "-le"
fi

# -lt: less than
if test $ans -lt $compVal
then
	echo "-lt"
fi

# -ne: not equal
if test $ans -ne $compVal
then
	echo "-ne"
fi