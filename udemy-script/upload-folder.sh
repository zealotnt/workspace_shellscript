#!/bin/bash

if [[ $# != 1 ]]; then
    echo "course name must be specified"
    exit 0
fi

COURSE_NAME=$1
COURSE_PATH=COURSES/$COURSE_NAME

set -x

OUT_DATA=$(gdrive mkdir $COURSE_NAME)
OUT_DATA_ARR=($OUT_DATA)
FOLDER_ID=${OUT_DATA_ARR[1]}

for d in $COURSE_PATH/*/; do
	# compress the folder
	FileCompressed=$(basename "$d")
	tar -cvf "$FileCompressed.tar.gz" -C "$COURSE_PATH" "$FileCompressed"

	# upload the compressed file
	gdrive upload -p $FOLDER_ID "$FileCompressed.tar.gz"

	# remove the compress file
	rm "$FileCompressed.tar.gz"
done
