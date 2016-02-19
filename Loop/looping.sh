#!/bin/bash
# Example of working on array
# Reference:
# http://www.cyberciti.biz/faq/bash-for-loop-array/

# Enable color code
. ../colorCode.sh

# Declare and an array called array and assign three values:
array=(one two three)
# More examples:
files=( "/etc/passwd" "/etc/group" "/etc/hosts" )
limits=( 10, 20, 26, 39, 48)

# To print an array use:
echo -e "${ENDL}${KRED}${KBOLD}Example: Print array${KRESET}"
printf "%s\n" "${array[@]}"
printf "%s\n" "${files[@]}"
printf "%s\n" "${limits[@]}"

# To Iterate Through Array Values
# for i in "${arrayName[@]}"
# do
#    :
#    # do whatever on $i
# done
# $i will hold each item in an array. Here is a sample working script:


# Example loop through array:
echo -e "${ENDL}${KRED}${KBOLD}Example: Loop through array${KRESET}"
for i in "${array[@]}"
do
	echo $i
done

