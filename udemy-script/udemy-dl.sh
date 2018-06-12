#!/bin/bash
# @Author: zealotnt
# @Date:   2018-06-04 00:21:46

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# != 2 ]]; then
        echo "course name must be specified"
fi

source $DIR/udemy-credential.sh
COURSE_NAME=$1

echo "Downloading $COURSE_NAME"

set -x

python udemy-dl.py -u $CRED_USER \
-p $CRED_PASS -q 720 -o ./COURSES \
https://www.udemy.com/$COURSE_NAME

#tar -cvf $COURSE_NAME.tar.gz ./COURSES/$COURSE_NAME
#gdrive upload --recursive ./COURSES/$COURSE_NAME
#rm $COURSE_NAME.tar.gz
#rm -rf ./COURSES/$COURSE_NAME
