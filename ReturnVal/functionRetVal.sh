#!/bin/bash

gVar=""
funRet()
{
	gVar="Return from function 1"
}
funRet2()
{
	echo "Return from function 2"
}

funRet3()
{
	echo "Echo 1st"
	echo "Echo 2nd"
	echo "Return from function 3"
}
funRet
echo "$gVar"

retVal=$(funRet2)
echo "$retVal - Call from main"

retVal=$(funRet3)
echo "$retVal - Call from main"