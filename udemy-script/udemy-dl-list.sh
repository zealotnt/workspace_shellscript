#!/bin/bash
# @Author: zealotnt
# @Date:   2018-06-04 00:36:12

COURSES=(
)

for course in "${COURSES[@]}"
do
    echo $course
    ./udemy-dl.sh $course
done
